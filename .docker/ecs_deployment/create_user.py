from mainsite.models import *
from badgeuser.models import *
from oauth2_provider.models import *
user = BadgeUser.objects.create_superuser(username="whoacademy", email="whoa@who.int", password="YH5931FW29MREPJMJAF4OAMQQK9V528X9TDV5H1U")