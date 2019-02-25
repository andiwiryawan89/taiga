#!/bin/bash
HOST=${TAIGA_HOST}
DEBUG=${TAIGA_DEBUG}
PUBLIC=${TAIGA_PUBLIC}
cd /home/taiga/
if [ ! -e setup.txt ]; then
    touch setup.txt
    cd /home/taiga/taiga-front-dist
    sed -i "s/TAIGA_HOST/$HOST/g" ./dist/conf.json
    cd /etc/nginx/
    sed -i "s/TAIGA_HOST/$HOST/g" ./nginx.conf
    cd /home/taiga
    sudo su taiga
    echo "VIRTUALENVWRAPPER_PYTHON='/bin/python3.6'" >> .bashrc
    echo "source /usr/bin/virtualenvwrapper.sh" >> .bashrc
    source .bashrc
    mkvirtualenv -p /bin/python3.6 taiga
    cd /home/taiga/taiga-back
    pip3.6 install -r requirements.txt
    sed -i "s/TAIGA_HOST/$HOST/g" ./settings/local.py
    sed -i "s/TAIGA_DEBUG/$DEBUG/g" ./settings/local.py
    sed -i "s/TAIGA_PUBLIC/$PUBLIC/g" ./settings/local.py
    python3.6 manage.py migrate --noinput
    python3.6 manage.py loaddata initial_user
    python3.6 manage.py loaddata initial_project_templates
    python3.6 manage.py compilemessages
    python3.6 manage.py collectstatic --noinput
    #sudo su
fi
cd /home/taiga/
exec /usr/sbin/init
