import datetime
import os

## FOR DEBUG
if os.getenv("DEBUG") == True:
    AWS_ACCESS_KEY_ID = os.getenv('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = os.getenv('AWS_SECRET_ACCESS_KEY')


AWS_FILE_EXPIRE = 200
AWS_PRELOAD_METADATA = True
AWS_QUERYSTRING_AUTH = False
AWS_DEFAULT_ACL = None
AWS_S3_SIGNATURE_VERSION = 's3v4'

DEFAULT_FILE_STORAGE = 'mainsite.aws.utils.MediaRootS3BotoStorage'
STATICFILES_STORAGE = 'mainsite.aws.utils.StaticRootS3BotoStorage'
AWS_STORAGE_BUCKET_NAME = os.getenv('AWS_STORAGE_BUCKET_NAME')
AWS_S3_REGION_NAME = os.getenv('AWS_REGION_NAME')
AWS_S3_CUSTOM_DOMAIN = os.getenv('AWS_CLOUDFRONT_URI')
S3_URL = '//%s.s3.amazonaws.com/' % AWS_STORAGE_BUCKET_NAME
MEDIA_URL = '//%s.s3.amazonaws.com/badgr-media/' % AWS_STORAGE_BUCKET_NAME
MEDIA_ROOT = MEDIA_URL
STATIC_URL = S3_URL + 'badgr-staticfiles/'
ADMIN_MEDIA_PREFIX = STATIC_URL + 'admin/'

two_months = datetime.timedelta(days=61)
date_two_months_later = datetime.date.today() + two_months
expires = date_two_months_later.strftime("%A, %d %B %Y 20:00:00 GMT")

AWS_HEADERS = {
    'Expires': expires,
    'Cache-Control': 'max-age=%d' % (int(two_months.total_seconds()), )
}