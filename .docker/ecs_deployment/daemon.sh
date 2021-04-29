python /badgr_server/manage.py migrate

python /badgr_server/manage.py dist

python /badgr_server/manage.py collectstatic --noinput

/usr/bin/supervisord
