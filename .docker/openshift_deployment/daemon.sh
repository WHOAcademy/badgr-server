python3 /badgr_server/manage.py collectstatic --noinput

python3 /badgr_server/manage.py migrate

python3 /badgr_server/manage.py dist

./manage.py shell < create_user.py 

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf