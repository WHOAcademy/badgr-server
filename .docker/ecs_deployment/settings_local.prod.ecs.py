# settings_local.py is for all instance specific settings

import random
import string
from .settings import *
from mainsite import TOP_DIR
from mainsite.aws.conf import *

DEBUG = False
DEBUG_ERRORS = DEBUG
DEBUG_STATIC = DEBUG
DEBUG_MEDIA = DEBUG

TIME_ZONE = 'UTC'
LANGUAGE_CODE = 'en-us'


##
#
# Database Configuration
#
##
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': os.getenv('BADGR_DB_NAME'),
        'USER': os.getenv('BADGR_USERNAME'),
        'PASSWORD': os.getenv('BADGR_PASSWORD'),
        'HOST': os.getenv('BADGR_DB_HOST'),
        'PORT': os.getenv('BADGR_DB_PORT'),
        'OPTIONS': {
#            "SET character_set_connection=utf8mb3, collation_connection=utf8_unicode_ci",  # Uncomment when using MySQL to ensure consistency across servers
        },
    }
}


###
#
# CACHE
#
###
# CACHES = {
#      'default': {
#          'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
#          'LOCATION': 'memcached:11211',
#          'KEY_FUNCTION': 'mainsite.utils.filter_cache_key'
#      }
#  }



###
#
# Email Configuration
#
###
DEFAULT_FROM_EMAIL = 'noreply@academy.who.int'  # e.g. "noreply@example.com"
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'


###
#
# Celery Asynchronous Task Processing (Optional)
#
###
CELERY_RESULT_BACKEND = None
# Run celery tasks in same thread as webserver (True means that asynchronous processing is OFF)
CELERY_ALWAYS_EAGER = True


###
#
# Application Options Configuration
#
###
ALLOWED_HOSTS = ['*']

# Optionally restrict issuer creation to accounts that have the 'issuer.add_issuer' permission
BADGR_APPROVED_ISSUERS_ONLY = True

# Automatically send an email the first time that recipient identifier (email type) has been used on the system.
GDPR_COMPLIANCE_NOTIFY_ON_FIRST_AWARD = True

SECRET_KEY = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(40))
UNSUBSCRIBE_KEY = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(40))
UNSUBSCRIBE_SECRET_KEY = str(SECRET_KEY)


###
#
# Logging
#
###
LOGS_DIR = os.path.join(TOP_DIR, 'logs')
if not os.path.exists(LOGS_DIR):
    os.makedirs(LOGS_DIR)
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'mail_admins': {
            'level': 'ERROR',
            'filters': [],
            'class': 'django.utils.log.AdminEmailHandler'
        },

        # badgr events log to disk by default
        'badgr_events': {
            'level': 'INFO',
            'formatter': 'json',
            'class': 'logging.FileHandler',
            'filename': os.path.join(LOGS_DIR, 'badgr_events.log')
        }
    },
    'loggers': {
        'django.request': {
            'handlers': ['mail_admins'],
            'level': 'ERROR',
            'propagate': True,
        },

        # Badgr.Events emits all badge related activity
        'Badgr.Events': {
            'handlers': ['badgr_events'],
            'level': 'INFO',
            'propagate': False,

        }

    },
    'formatters': {
        'default': {
            'format': '%(asctime)s %(levelname)s %(module)s %(message)s'
        },
        'json': {
            '()': 'mainsite.formatters.JsonFormatter',
            'format': '%(asctime)s',
            'datefmt': '%Y-%m-%dT%H:%M:%S%z',
        }
    },
}

OPEN_FOR_SIGNUP = False