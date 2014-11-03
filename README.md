docker-piwigo
=============

## TL;DR

```
$ git clone https://www.github.com/hbredin/docker-piwigo
$ cd docker-piwigo
$ docker build -t `whoami`/piwigo .       # build your own `piwigo` image

$ docker run -d --name database \         # run MySQL container
         -e MYSQL_ROOT_PASSWORD=piwigo \  # MySQL root password
         -e MYSQL_DATABASE=piwigo \       # MySQL database name
         -e MYSQL_USER=piwigo \           # MySQL user name
         -e MYSQL_PASSWORD=piwigo \       # MySQL user password
         -v /path/to/db:/var/lib/mysql \  # path to MySQL files on host 
         mysql

$ docker run -d -p 80:80 --name piwigo \              # run `piwigo` in `nginx`
         --link database:mysql \
         -v /path/to/gallery:/var/www/galleries:ro \  # path to existing pictures on host
         -v /path/to/upload:/var/www/upload:rw \      # path to upload backup on host
         `whoami`/piwigo
```

Visit `http://localhost:80` and remember that MySQL hostname should be set to `mysql` in the installation form.

## Step 1: MySQL

Run MySQL in its own container, and name it `database`.

```
$ docker run -d \
         --name database \
         -e MYSQL_ROOT_PASSWORD=piwigo \
         mysql
```

Environment variable `MYSQL_ROOT_PASSWORD` is mandatory and sets `root` password. In the above example, it is set to `piwigo` but you should probably choose a safer password :)

Setting volume `/var/lib/mysql` to a directory on Docker host allows you to have direct access (e.g. for later backup) to the database files on the host.

```
$ export MYSQL_DATA=/path/where/to/store/database/files/on/host
$ docker run -d \
         --name database \
         -e MYSQL_ROOT_PASSWORD=piwigo \
         -v $MYSQL_DATA=/var/lib/mysql \     # <-- HERE
         mysql
```

Additionally, passing environment variables `MYSQL_DATABASE`, `MYSQL_USER` and `MYSQL_PASSWORD` will automatically create a user, a database and give the user full access to the database.

```
$ docker run -d --name database \
         -e MYSQL_ROOT_PASSWORD=piwigo \
         -e MYSQL_DATABASE=piwigo \          # <-- HERE
         -e MYSQL_USER=piwigo \              # <-- HERE
         -e MYSQL_PASSWORD=piwigo \          # <-- AND HERE
         -v $MYSQL_DATA:/var/lib/mysql \
         mysql
```

In the example above, user `piwigo` with password `piwigo` will have full access to database `piwigo`. Once again, you should probably be smarter when choosing your username and password :)

## Step 2: Piwigo

Build your very own `piwigo` docker image.
This actually 
  - installs `nginx` with `php-fpm` support on top of Ubuntu 14.04 image,
  - downloads the latest version of `piwigo` from `piwigo.org`,
  - configures `piwigo` in paranoiac mode (see file `config.inc.php`)  
  - configures `nginx` to deny any HTTP request to to `/galleries`, `/upload` and `/_data/i`

```
$ git clone https://www.github.com/hbredin/docker-piwigo
$ cd docker-piwigo
$ docker build -t `whoami`/piwigo .
```

We are almost there! 
Run `piwigo` linked with `database` container.

```
$ docker run -d --name piwigo \
         -p 80:80 \
         --link database:mysql \
         `whoami`/piwigo
```

Additionally, setting up volume `/var/www/galleries` to the host directory where your existing pictures are stored will permit the use of `piwigo` syncing functionalities.

Similarly, setting up volume `/var/www/upload` to another host directory will allow you to gain access to uploaded pictures directly from host (e.g. for backup purposes).

```
$ export PIWIGO_GALLERIES=/path/to/synced/galleries
$ export PIWIGO_UPLOAD=/path/to/uploaded/pictures

$ docker run -d -p 80:80 --name piwigo \
         --link database:mysql \
	     -v $PIWIGO_GALLERIES:/var/www/galleries:ro \
	     -v $PIWIGO_UPLOAD:/var/www/upload:rw \
	     `whoami`/piwigo
```

We are good to go! Just visit `http://localhost:80` and go through the standard `piwigo` installation process. Remember to use `mysql` (instead of default `localhost`) as MySQL hostname and fill in the rest of the form with information matching `MYSQL_DATABASE`, `MYSQL_USER` and `MYSQL_PASSWORD`.


