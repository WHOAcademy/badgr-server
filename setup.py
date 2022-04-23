from setuptools import setup, find_packages

setup(name='badgr-server',
      version='1.6.7',
      packages=find_packages(),
      install_requires=[
            'Django~=3.1.13',
            'mysqlclient==2.0.3',
            'djangorestframework~=3.11.0',
            'django-restql==0.15.1'
            'nose==1.3.7',
            'coverage==5.2',
            'django-nose==1.4.6',
            'django-redis==5.2.0',
            'setuptools~=53.0.0',
            'PyJWT~=2.0.1',
            'Pillow==8.3.2',
            'cryptography==3.4.6',
            'django-cors-headers==3.7.0',
            'python-dotenv==0.15.0',
            'django-extensions==3.1.1',
            'requests==2.25.1',
            'drf-yasg==1.20.0',
            'gunicorn==20.0.4',
            'gevent==20.9.0',
            'greenlet==0.4.17',
      ],
      scripts=['manage.py'])