# quay.io/whoacademy/badgr-server:0.2.0

version='0.2.0'

docker build -t quay.io/whoacademy/badgr-server:$version -f ./.docker/Dockerfile.openshift.test.api .