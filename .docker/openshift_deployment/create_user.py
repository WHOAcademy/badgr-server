import os

from mainsite.models import *
from badgeuser.models import *
from oauth2_provider.models import *


user = BadgeUser.objects.create_superuser(
    username=os.getenv("BADGR_USERNAME", default = None), 
    email=os.getenv("BADGR_EMAIL", default = None), 
    password=os.getenv("BADGR_PASSWORD", default = None)
)