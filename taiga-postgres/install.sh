#!/bin/bash
cd /home/taiga
if [ ! -e setup.txt ]; then
    touch setup.txt
    cd /home/taiga/taiga-back
    python manage.py migrate --noinput
    python manage.py loaddata initial_user
    python manage.py loaddata initial_project_templates
    python manage.py compilemessages
    python manage.py collectstatic --noinput
fi