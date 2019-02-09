FROM postgres:10

RUN apt-get install -y python3 python3-pip python-dev python3-dev python-pip virtualenvwrapper \
    && apt-get install -y libxml2-dev libxslt-dev \
    && apt-get install -y libssl-dev libffi-dev git

RUN adduser taiga \
    adduser taiga sudo
USER taiga
WORKDIR /home/taiga
RUN git clone https://github.com/taigaio/taiga-back.git taiga-back
WORKDIR /home/taiga/taiga-back
RUN git checkout stable
RUN mkvirtualenv -p /usr/bin/python3 taiga
RUN pip install -r requirements.txt
WORKDIR /home/taiga
COPY install.sh install.sh
RUN chmod +x install.sh
ENTRYPOINT [ "./install.sh" ]