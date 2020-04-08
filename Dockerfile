FROM ubuntu:trusty

# https://rethinkdb.com/docs/install/ubuntu/

RUN source /etc/lsb-release && echo "deb https://download.rethinkdb.com/apt $DISTRIB_CODENAME main" | tee /etc/apt/sources.list.d/rethinkdb.list
RUN wget -qO- https://download.rethinkdb.com/apt/pubkey.gpg | apt-key add -

ENV RETHINKDB_PACKAGE_VERSION 2.3.6
ENV RETHINKDB_PYTHON_CLIENT_VERSION 2.3.0.post6

# https://github.com/rethinkdb/rethinkdb/releases
# https://pypi.org/project/rethinkdb/#history

RUN apt-get update --fix-missing \
  && apt-get -y install python-pip \
  && apt-get install -y rethinkdb=$RETHINKDB_PACKAGE_VERSION \
  && rm -rf /var/lib/apt/lists/* \
  && sudo pip install rethinkdb==$RETHINKDB_PYTHON_CLIENT_VERSION \
  && mkdir /backups \
  && mkdir /scripts

ENV CRON_TIME="0 0 * * *"

ADD run.sh /run.sh

VOLUME ["/backups"]

CMD ["/run.sh"]
