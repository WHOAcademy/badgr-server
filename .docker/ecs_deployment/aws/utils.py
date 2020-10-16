from storages.backends.s3boto3 import S3Boto3Storage


def StaticRootS3BotoStorage():
    return S3Boto3Storage(location='badgr-staticfiles')


def MediaRootS3BotoStorage():
    return S3Boto3Storage(location='badgr-media')
