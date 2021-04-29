# READ THIS FOR MAKING CHANGES TO the openshift deployment

This helm chart is fairly straightforward :
    Uses a MySql Helm Chart
    
    Uses a deployment config + route + service for badgr server


# To build

Login to OCP cluster
'''
oc login ******* ******
'''
Login to target namespace
'''
oc project TARGET_NAMESPACE
'''

## Build dockerfile

'''
docker-compose -f docker-compose.openshift.test.yml up --build
'''

## Commit to quay
'''
docker commit badgr-server_api_1 quay.io/whoacademy/badgr-server
'''

## Push to quay
'''
docker push quay.io/whoacademy/badgr-server
'''

## To push to openshift 
'''
helm upgrade badgr-server ./chart
'''