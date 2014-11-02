docker-piwigo
=============

```
$ export MYSQL_BACKUP=/path/to/mysql/database

$ docker run -d --name db \
             -e MYSQL_ROOT_PASSWORD=piwigo \
 	     -e MYSQL_DATABASE=piwigo \
	     -e MYSQL_USER=piwigo \
	     -e MYSQL_PASSWORD=piwigo \
	     -v $MYSQL_BACKUP:/var/lib/mysql \
	     mysql
```

```
$ docker build -t `whoami`/piwigo .

$ export PIWIGO_GALLERIES=/path/to/synced/galleries
$ export PIWIGO_UPLOAD=/path/to/uploaded/pictures

$ docker run -d -p 80 --name piwigo \
             --link db:mysql \
	     -v $PIWIGO_GALLERIES:/var/www/galleries \
	     -v $PIWIGO_UPLOAD:/var/www/upload \
	     `whoami`/piwigo
```
