# quay.io/whoacademy/badgr-server:0.2.0

version='0.2.0'

docker build -t quay.io/whoacademy/badgr-server:$version -f ./.docker/Dockerfile.openshift.test.api .

# docker run --rm -p 8080:8080 quay.io/whoacademy/badgr-server:0.2.0

#docker push quay.io/whoacademy/badgr-server:$version
