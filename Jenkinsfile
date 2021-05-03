pipeline {
    agent {
        label "master"
    }

    environment {
        // GLobal Vars
        NAME = "badgr-server"
        PROJECT= "labs"

        // Config repo managed by ArgoCD details
        ARGOCD_CONFIG_REPO = "github.com/WHOAcademy/lxp-config.git"
        ARGOCD_CONFIG_REPO_PATH = "lxp-deployment/values-test.yaml"
        ARGOCD_CONFIG_STAGING_REPO_PATH = "lxp-deployment/values-staging.yaml"
        ARGOCD_CONFIG_REPO_BRANCH = "master"
        SYSTEM_TEST_BRANCH = "master"

        // Job name contains the branch eg ds-app-feature%2Fjenkins-123
        JOB_NAME = "${JOB_NAME}".replace("%2F", "-").replace("/", "-")

        GIT_SSL_NO_VERIFY = true

        // Credentials bound in OpenShift
        GIT_CREDS = credentials("${OPENSHIFT_BUILD_NAMESPACE}-git-auth")
        NEXUS_CREDS = credentials("${OPENSHIFT_BUILD_NAMESPACE}-nexus-password")
        QUAY_PUSH_SECRET = "who-lxp-imagepusher-secret"

        // Nexus Artifact repo
        NEXUS_REPO_NAME="labs-static"
        NEXUS_REPO_HELM = "helm-charts"

    }

    // The options directive is for configuration that applies to the whole job.
    options {
        buildDiscarder(logRotator(numToKeepStr: '50', artifactNumToKeepStr: '1'))
        timeout(time: 30, unit: 'MINUTES')
        ansiColor('xterm')
    }

    stages {
        stage('Prepare Environment') {
            failFast true
            parallel {
                stage("Release Build") {
                    options {
                        skipDefaultCheckout(true)
                    }
                    agent {
                        node {
                            label "master"
                        }
                    }
                    when {
                        expression { GIT_BRANCH.startsWith("master") }
                    }
                    steps {
                        script {
                            env.APP_ENV = "prod"
                            // External image push registry info
                            env.IMAGE_REPOSITORY = "quay.io"
                            // app name for master is just learning-experience-platform or something
                            env.APP_NAME = "${NAME}".replace("/", "-").toLowerCase()
                            env.TARGET_NAMESPACE = "whoacademy"
                        }
                    }
                }
                stage("Sandbox Build") {
                    options {
                        skipDefaultCheckout(true)
                    }
                    agent {
                        node {
                            label "master"
                        }
                    }
                    when {
                        expression { GIT_BRANCH.startsWith("dev") || GIT_BRANCH.startsWith("feature") || GIT_BRANCH.startsWith("fix") }
                    }
                    steps {
                        script {
                            env.APP_ENV = "dev"
                            // Sandbox registry deets
                            env.APP_NAME = "${GIT_BRANCH}-${NAME}".replace("/", "-").toLowerCase()
                            env.TARGET_NAMESPACE = "labs-dev"
                        }
                    }
                }
            }
        }

          stage("Build (Compile App)") {
            agent {
                node {
                    label "jenkins-agent-python38"
                }
            }
            steps {
                script {
                    // TODO FIX how version is pull
                    env.VERSION = "1.0.0"
                    env.VERSIONED_APP_NAME = "${NAME}-${VERSION}"
                    env.PACKAGE = "${VERSIONED_APP_NAME}.tar.gz"
                    env.SECRET_KEY = 'gs7(p)fk=pf2(kbg*1wz$x+hnmw@y6%ij*x&pq4(^y8xjq$q#f' //TODO: get it from secret vault
                }
                sh 'printenv'
            }
        }

  stage("Helm Package App (master)") {
            agent {
                node {
                    label "jenkins-agent-helm"
                }
            }
            steps {
                sh 'printenv'
                sh '''
                    # might be overkill...
                    yq e ".appVersion = env(VERSION)" -i chart/Chart.yaml
                    yq e ".version = env(VERSION)" -i chart/Chart.yaml
                    yq e ".name = env(APP_NAME)" -i chart/Chart.yaml # APP= feature-123-learning-experience-platform
                    
                    # probs point to the image inside ocp cluster or perhaps an external repo?
                    # yq e ".orchestrator.image_repository = env(IMAGE_REPOSITORY)" -i chart/values.yaml
                    yq e ".namespace = env(TARGET_NAMESPACE)" -i chart/values.yaml
                    
                    # latest built image
                    yq e ".app_tag = env(VERSION)" -i chart/values.yaml
                '''
                sh 'printenv'
                sh 'oc project ${TARGET_NAMESPACE}'
                sh '''
                    # package and release helm chart?
                    helm package chart/ --app-version ${VERSION} --version ${VERSION} --dependency-update
                    curl -v -f -u ${NEXUS_CREDS} http://${SONATYPE_NEXUS_SERVICE_SERVICE_HOST}:${SONATYPE_NEXUS_SERVICE_SERVICE_PORT}/repository/${NEXUS_REPO_HELM}/ --upload-file ${APP_NAME}-${VERSION}.tgz
                '''
            }
        }

        stage("Deploy App") {
            failFast true
            parallel {
                stage("sandbox - helm3 publish and install"){
                    options {
                        skipDefaultCheckout(true)
                    }
                    agent {
                        node {
                            label "jenkins-agent-helm"
                        }
                    }
                    when {
                        expression { GIT_BRANCH.startsWith("dev") || GIT_BRANCH.startsWith("feature") || GIT_BRANCH.startsWith("fix") }
                    }
                    steps {
                        // TODO - if SANDBOX, create release in rando ns
                        sh 'printenv'
                        sh 'ls'
                        sh '''
                            # helm uninstall ${APP_NAME} --namespace=${TARGET_NAMESPACE} --dry-run
                            # helm uninstall ${APP_NAME} --namespace=${TARGET_NAMESPACE} || rc=$?
                            sleep 40
                            helm upgrade --install ${APP_NAME} \
                                --namespace=${TARGET_NAMESPACE} \
                                http://${SONATYPE_NEXUS_SERVICE_SERVICE_HOST}:${SONATYPE_NEXUS_SERVICE_SERVICE_PORT}/repository/${NEXUS_REPO_HELM}/${APP_NAME}-${VERSION}.tgz
                        '''
                    }
                }
                stage("test env - ArgoCD sync") {
                    options {
                        skipDefaultCheckout(true)
                    }
                    agent {
                        node {
                            label "jenkins-agent-argocd"
                        }
                    }
                    when {
                        expression { GIT_BRANCH.startsWith("master") }
                    }
                    steps {
                        echo '### Commit new image tag to git ###'
                        sh  '''
                            git clone https://${ARGOCD_CONFIG_REPO} config-repo
                            cd config-repo
                            git checkout ${ARGOCD_CONFIG_REPO_BRANCH}
                            yq w -i ${ARGOCD_CONFIG_REPO_PATH} "applications.name==test-${NAME}.source_ref" ${VERSION}
                            git config --global user.email "edgarmonis@gmail.com"
                            git config --global user.name "eddiebarry"
                            git config --global push.default simple
                            git add ${ARGOCD_CONFIG_REPO_PATH}
                            git commit -m "🚀 AUTOMATED COMMIT - Deployment of ${APP_NAME} at version ${VERSION} 🚀" || rc=$?
                            git remote set-url origin  https://${GIT_CREDS_USR}:${GIT_CREDS_PSW}@${ARGOCD_CONFIG_REPO}
                            git push -u origin ${ARGOCD_CONFIG_REPO_BRANCH}
                            # Give ArgoCD a moment to gather it's thoughts and roll out a deployment before Jenkins races on to test things
                            # issue here is an asynchronous pipeline (argo) interacting with a synchronous job ie jenkins
                            sleep 20
                        '''
                    }
                }
                stage("staging env - ArgoCD sync") {
                    options {
                        skipDefaultCheckout(true)
                    }
                    agent {
                        node {
                            label "jenkins-agent-argocd"
                        }
                    }
                    when {
                        expression { GIT_BRANCH.startsWith("master") }
                    }
                    steps {
                        echo '### Commit new image tag to git ###'
                        sh  '''
                            git clone https://${ARGOCD_CONFIG_REPO} config-repo
                            cd config-repo
                            git checkout ${ARGOCD_CONFIG_REPO_BRANCH}
                            yq w -i ${ARGOCD_CONFIG_STAGING_REPO_PATH} "applications.name==${NAME}.source_ref" ${VERSION}
                            git config --global user.email "edgarmonis@gmail.com"
                            git config --global user.name "eddiebarry"
                            git config --global push.default simple
                            git add ${ARGOCD_CONFIG_STAGING_REPO_PATH}
                            git commit -m "🚀 AUTOMATED COMMIT - Deployment of ${APP_NAME} at version ${VERSION} 🚀" || rc=$?
                            git remote set-url origin  https://${GIT_CREDS_USR}:${GIT_CREDS_PSW}@${ARGOCD_CONFIG_REPO}
                            git push -u origin ${ARGOCD_CONFIG_REPO_BRANCH}
                            # Give ArgoCD a moment to gather it's thoughts and roll out a deployment before Jenkins races on to test things
                            # issue here is an asynchronous pipeline (argo) interacting with a synchronous job ie jenkins
                            sleep 20
                        '''
                    }
                }

            }
        }
    }
}