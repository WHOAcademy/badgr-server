# quay.io/whoacademy/badgr-server:latest

version='0.1.0'

docker build -t quay.io/whoacademy/badgr-server:$version -f ./.docker/Dockerfile.openshift.test.api .