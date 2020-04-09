An image which contains ultility like `rethinkdb dump` or `rethinkdb restore`, to serve the purpose of backup & restore RethinkDB data in containerized environment.

It's mainly because the [official Dockerfile](https://github.com/rethinkdb/rethinkdb-dockerfiles) to run RethinkDB doesn't have those ultilites.

https://github.com/rethinkdb/rethinkdb-dockerfiles

https://registry.hub.docker.com/_/rethinkdb/

## Usage:

Assume that you have a running RethinkDB instance inside `rethinkdb-devel` container.
If you do not have it, you can create one with the following command:

```
$ sudo docker run -d --name rethinkdb-devel -p 127.0.0.1:8080:8080 -p 127.0.0.1:28015:28015 -p 127.0.0.1:29015:29015 rethinkdb:2.3.7
```


Build the docker image:

```
$ cd rethinkdb-backup
$ sudo docker build -t ptgamr/rethinkdb-backup:2.0 .
```

Run it  & link with `rethinkdb-devel`

```
$ sudo docker run -d --name rethinkdb-backup --link rethinkdb-devel:rethinkdb -v /home/anh/backups:/backups ptgamr/rethinkdb-backup
```

Import from dump:

```
# Enter the container
$ sudo docker exec -it rethinkdb-backup bash

# Inside the container, run:
$ rethinkdb import -d rethinkdb_dump_2020-04-08T03:00:02 -c rethinkdb-devel -i schedulerapi_devel.gamereports
```


##################
# OLD Docs

# rethinkdb-backup

This image runs rethinkdb dump to backup data using cronjob to folder `/backups`

## Usages
    docker run -d \
        --env RETHINKDB_HOST=rethinkdb.host \
        --env RETHINKDB_PORT=27017 \
        --volume host.folder:/backups
        iteam1337/rethinkdb-backup

Moreover, if you link `rethinkdb-backup` to a rethinkdb container(e.g. `rethinkdb`) with an alias named rethinkdb, this image will try to auto load the `host`, `port` if possible.

    docker run -d -p 27017:27017 -p 28017:28017 -e --name rethinkdb tutum/rethinkdb
    docker run -d --link rethinkdb:rethinkdb -v host.folder:/backups tutum/rethinkdb-backup

## Parameters

    RETHINKDB_HOST      the host/ip of your rethinkdb database
    RETHINKDB_PORT      the port number of your rethinkdb database
    RETHINKDB_DB        the database name to dump. Default: `test`
    RETHINKDB_ENV       the environment, DEVELOPMENT, TEST or PRODUCTION
    EXTRA_OPTS      the extra options to pass to rethinkdb dump command
    CRON_TIME       the interval of cron job to run rethinkdb dump. `0 0 * * *` by default, which is every day at 00:00
    MAX_BACKUPS     the number of backups to keep. When reaching the limit, the old backup will be discarded. No limit by default
    INIT_BACKUP     if set, create a backup when the container starts
    INIT_RESTORE_LATEST if set, restores latest backup

## Restore from a backup

See the list of backups, you can run:

    docker exec tutum-backup ls /backups

To restore database from a certain backup, simply run:

    docker exec tutum-backup /restore.sh /backups/2015.08.06.171901
