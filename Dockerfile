FROM ubuntu:bionic

RUN apt-get -qqy update \
    && apt-get install -y --no-install-recommends ca-certificates gnupg2 \
    && rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver keys.gnupg.net --recv-keys "539A 3A8C 6692 E6E3 F69B 3FE8 1D85 E93F 801B B43F" \
    && echo "deb https://download.rethinkdb.com/apt bionic main" > /etc/apt/sources.list.d/rethinkdb.list

ENV RETHINKDB_PACKAGE_VERSION 2.3.7~0bionic
ENV RETHINKDB_PYTHON_CLIENT_VERSION 2.3.0.post6

RUN apt-get -qqy update \
  && apt-get install -y rethinkdb=$RETHINKDB_PACKAGE_VERSION \
  && rm -rf /var/lib/apt/lists/* |
  && apt-get -y install python-pip \
  && sudo pip install rethinkdb==$RETHINKDB_PYTHON_CLIENT_VERSION \
  && mkdir /backups \
  && mkdir /scripts

ENV CRON_TIME="0 0 * * *"

ADD run.sh /run.sh

VOLUME ["/backups"]

CMD ["/run.sh"]
