#https://github.com/andiwiryawan89/taiga.git
FROM andiwiryawan/centos

ENV PGDATA /var/lib/pgsql/10/data
ENV TAIGA_HOST localhost
ENV TAIGA_DEBUG False
ENV TAIGA_PUBLIC False

RUN yum -y update \
    && yum -y install epel-release \
    && yum clean all

RUN yum -y install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
RUN yum -y install postgresql10-server postgresql10-contrib postgresql10 
RUN yum -y install gcc autoconf flex bison libjpeg-turbo-devel freetype-devel zlib-devel zeromq3-devel gdbm-devel ncurses-devel automake libtool libffi-devel curl git tmux libxml2-devel libxslt-devel openssl-devel gcc-c++ sudo
RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm
RUN yum -y install python36u python36u-libs python36u-devel python36u-pip which nodejs nginx git redis
RUN rpm --import https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
RUN rpm --import https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
RUN yum -y install https://github.com/rabbitmq/erlang-rpm/releases/download/v21.2.5/erlang-21.2.5-1.el7.centos.x86_64.rpm
RUN yum -y install https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.11/rabbitmq-server-3.7.11-1.el7.noarch.rpm
RUN npm install -g coffee-script gulp
RUN python3.6 -m ensurepip
RUN pip3.6 install --upgrade setuptools pip
RUN pip3.6 install virtualenv virtualenvwrapper circus

RUN useradd taiga \
    && echo "taiga ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /home/taiga
RUN mkdir -p logs
RUN git clone https://github.com/taigaio/taiga-back.git taiga-back
RUN git clone https://github.com/taigaio/taiga-front-dist.git taiga-front-dist
RUN git clone https://github.com/taigaio/taiga-events.git taiga-events
WORKDIR /home/taiga/taiga-back
RUN git checkout stable
COPY local.py settings/local.py
WORKDIR /home/taiga/taiga-front-dist
RUN git checkout stable
COPY conf.json dist/conf.json
WORKDIR /home/taiga/taiga-events
RUN npm install
COPY config.json config.json

WORKDIR /etc/
COPY circus circus
WORKDIR /etc/systemd/system/
COPY circus.service circus.service

WORKDIR /etc/nginx/
COPY nginx.conf nginx.conf

WORKDIR /home/taiga
COPY install.sh install.sh
RUN chmod +x install.sh
EXPOSE 80 8080
#you must run with -v /sys/fs/cgroup:/sys/fs/cgroup:ro
VOLUME [ "/sys/fs/cgroup", "/home/taiga/media", "/home/taiga/static", "/var/lib/pgsql/10/data" ]
CMD ["./install.sh"]