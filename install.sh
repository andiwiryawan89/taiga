#!/bin/bash
HOST=${TAIGA_HOST}
DEBUG=${TAIGA_DEBUG}
PUBLIC=${TAIGA_PUBLIC}

LOCAL_UID=${USER_UID}
LOCAL_GID=${USER_GID}
cd /home/taiga/
if [ ! -e setup.txt ]; then
    touch setup.txt
    if [ "$LOCAL_GID" != "0" ]; then
        groupmod -g "$LOCAL_GID" taiga
        find /var/www -group 1002 -exec chgrp -h taiga {} \;
    fi
    if [ "$LOCAL_UID" != "0" ]; then
        usermod -u "$LOCAL_UID" taiga
        find /var/www -user 1001 -exec chown -h taiga {} \;
    fi
    cd /home/taiga/taiga-front-dist
    sed -i "s/TAIGA_HOST/$HOST/g" ./dist/conf.json
    cd /etc/nginx/
    sed -i "s/TAIGA_HOST/$HOST/g" ./nginx.conf
    cd /home/taiga
    # sudo su taiga
    echo "VIRTUALENVWRAPPER_PYTHON='/bin/python3.6'" >> .bashrc
    echo "source /usr/bin/virtualenvwrapper.sh" >> .bashrc
    sudo -u taiga -i source .bashrc
    sudo -u taiga -i mkvirtualenv -p /bin/python3.6 taiga
    cd /home/taiga/taiga-back
    sed -i "s/TAIGA_HOST/$HOST/g" ./settings/local.py
    sed -i "s/TAIGA_DEBUG/$DEBUG/g" ./settings/local.py
    sed -i "s/TAIGA_PUBLIC/$PUBLIC/g" ./settings/local.py
    pip3.6 install -r requirements.txt
    sudo -u taiga -i bash -c "cd /home/taiga/taiga-back; python3.6 manage.py migrate --noinput"
    sudo -u taiga -i bash -c "cd /home/taiga/taiga-back; python3.6 manage.py loaddata initial_user"
    sudo -u taiga -i bash -c "cd /home/taiga/taiga-back; python3.6 manage.py loaddata initial_project_templates"
    sudo -u taiga -i bash -c "cd /home/taiga/taiga-back; python3.6 manage.py compilemessages"
    sudo -u taiga -i bash -c "cd /home/taiga/taiga-back; python3.6 manage.py collectstatic --noinput"
    #sudo su
    chown -hR taiga:taiga /home/taiga
fi
cd /home/taiga/
exec /usr/sbin/init
