#!/bin/bash
cd /home/taiga
if [ ! -e setup.txt ]; then
    touch setup.txt
    cd /home/taiga/taiga-back
    python3 manage.py migrate --noinput
    python3 manage.py loaddata initial_user
    python3 manage.py loaddata initial_project_templates
#    python3 manage.py compilemessages
#    python3 manage.py collectstatic --noinput
fi
