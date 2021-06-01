sleep 100

python /badgr_server/manage.py collectstatic --noinput

python /badgr_server/manage.py migrate

python /badgr_server/manage.py dist

/usr/bin/supervisord