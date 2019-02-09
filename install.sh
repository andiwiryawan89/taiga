#!/bin/bash
cd /home/taiga/
if [ ! -d "${PGDATA}" ]; then
    mkdir -p "${PGDATA}" && chown -R postgres:postgres "${PGDATA}"
fi
if [ ! -e dbsetup.txt ]; then
    touch dbsetup.txt
    /usr/pgsql-10/bin/postgresql-10-setup initdb
    systemctl enable postgresql-10
    sudo -u postgres createuser taiga
    psql -c "ALTER USER taiga WITH ENCRYPTED password 'DBPassword'; CREATE DATABASE taiga OWNER taiga;"
    systemctl enable rabbitmq-server
    sudo rabbitmqctl add_user taiga StrongMQPassword
    sudo rabbitmqctl add_vhost taiga
    sudo rabbitmqctl set_permissions -p taiga taiga ".*" ".*" ".*"
    echo "VIRTUALENVWRAPPER_PYTHON='/bin/python3.6'" >> .bashrc
    echo "source /usr/bin/virtualenvwrapper.sh" >> .bashrc
    sudo -u taiga source .bashrc
    cd /home/taiga/taiga-back
    mkvirtualenv -p /bin/python3.6 taiga
    pip install -r requirements.txt
    python3.6 manage.py migrate --noinput
    python3.6 manage.py loaddata initial_user
    python3.6 manage.py loaddata initial_project_templates
    python3.6 manage.py compilemessages
    python3.6 manage.py collectstatic --noinput
    sed -i "s/TAIGA_HOST/${TAIGA_HOST}/g" ./settings/local.py \
    && sed -i "s/TAIGA_DEBUG/${TAIGA_DEBUG}/g" ./settings/local.py \
    && sed -i "s/TAIGA_PUBLIC/${TAIGA_PUBLIC}/g" ./settings/local.py
    cd /home/taiga/taiga-front-dist
    sed -i "s/TAIGA_HOST/${TAIGA_HOST}/g" ./dist/conf.json
    cd /etc/nginx/
    sed -i "s/TAIGA_HOST/${TAIGA_HOST}/g" ./nginx.conf
    systemctl restart nginx
    systemctl enable circus
fi
cd /home/taiga/
