#!/bin/bash
HOST = $1
DEBUG = $2
PUBLIC  = $3
cd /home/taiga/
if [ ! -e setup.txt ]; then
    touch setup.txt
    chown -hR taiga:taiga /home/taiga
    sudo su taiga
    echo "VIRTUALENVWRAPPER_PYTHON='/bin/python3.6'" >> .bashrc
    echo "source /usr/bin/virtualenvwrapper.sh" >> .bashrc
    source .bashrc
    cd /home/taiga/taiga-back
    mkvirtualenv -p /bin/python3.6 taiga
    pip3.6 install -r requirements.txt
    sed -i "s/TAIGA_HOST/${HOST}/g" ./settings/local.py
    sed -i "s/TAIGA_DEBUG/${DEBUG}/g" ./settings/local.py
    sed -i "s/TAIGA_PUBLIC/${PUBLIC}/g" ./settings/local.py
    python3.6 manage.py migrate --noinput
    python3.6 manage.py loaddata initial_user
    python3.6 manage.py loaddata initial_project_templates
    python3.6 manage.py compilemessages
    python3.6 manage.py collectstatic --noinput
    cd /home/taiga/taiga-front-dist
    sed -i "s/TAIGA_HOST/${HOST}/g" ./dist/conf.json
    cd /etc/nginx/
    sed -i "s/TAIGA_HOST/${HOST}/g" ./nginx.conf
    sudo su
    systemctl enable nginx
    systemctl restart nginx
    systemctl enable circus
    systemctl start circus
fi
cd /home/taiga/
