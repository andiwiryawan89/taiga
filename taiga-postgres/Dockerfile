FROM postgres:10

RUN apt-get update -y
RUN apt-get install -y build-essential binutils-doc autoconf flex bison libjpeg-dev \
    && apt-get install -y libfreetype6-dev zlib1g-dev libzmq3-dev libgdbm-dev libncurses5-dev \
    && apt-get install -y automake libtool libffi-dev curl git tmux gettext
RUN apt-get install -y python3 python3-pip python-dev python3-dev python-pip virtualenvwrapper \
    && apt-get install -y libxml2-dev libxslt-dev \
    && apt-get install -y libssl-dev libffi-dev git

RUN adduser --disabled-password --gecos "" taiga \
    && adduser taiga sudo
RUN pip3 install --upgrade pip
RUN pip3 install virtualenv virtualenvwrapper
WORKDIR /home/taiga
USER taiga
RUN git clone https://github.com/taigaio/taiga-back.git taiga-back
RUN echo "VIRTUALENVWRAPPER_PYTHON='/usr/bin/python3'" >> .bashrc \
    && echo "source /usr/local/bin/virtualenvwrapper.sh" >> .bashrc
RUN source .bashrc
RUN /bin/bash --login -c "mkvirtualenv -p /usr/bin/python3 taiga"
WORKDIR /home/taiga/taiga-back
RUN git checkout stable
USER root
RUN pip3 install -r requirements.txt
COPY install.sh install.sh
RUN chmod +x install.sh
ENTRYPOINT [ "./install.sh" ]