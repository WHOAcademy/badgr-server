# sleep 100

python /badgr_server/manage.py collectstatic --noinput

python /badgr_server/manage.py migrate

python /badgr_server/manage.py dist

./manage.py shell < create_user.py 

/usr/bin/supervisord