# whoalxp.azurecr.io/badgr-server:0.2.0

version='0.2.0'

docker build -t whoalxp.azurecr.io/badgr-server:$version -f ./.docker/Dockerfile.openshift.test.api .

# docker run --rm -p 8080:8080 whoalxp.azurecr.io/badgr-server:0.2.0

#docker push whoalxp.azurecr.io/badgr-server:$version
