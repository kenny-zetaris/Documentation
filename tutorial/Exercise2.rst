##################
Exercise2
##################

This exercise is aimed at introducing Data vitualization using the Zetaris Platform.
To complete this exercise you will need the following setup

      - Zetaris Platform VM
      - Postgres
      - Mysql

If you find it difficult to set the database up and running. You can get the respective contianer from zetaris docker hub and get it up and running

Zetaris Platform VM
====================

Follow the instructions under `Download and Go start guide <../Platform-VM/index.rst>`_.


Postgres
==========

Pull the postgres container::

    docker pull zetaris/zetaris-postgres

To init the postgres::

    docker-machine ssh vm mkdir postgres
    docker run -ti  --security-opt=label:disable -v /home/docker/postgres:/srv/zetaris/postgres:rw zetaris/zetaris-postgres:9.6-3 /init.sh

To spin up the container::

    docker run -d -ti --security-opt=label:disable --name postgres -p 5432:5432 -v /home/docker/postgres:/srv/zetaris/postgres:rw zetaris/zetaris-postgres:9.6-3 /bin/bash`

To start postgres::

    docker exec -d -ti --user postgres:postgres postgres /start.sh

To stop postgres::

    docker exec -d -ti --user postgres:postgres postgres /start.sh

Mysql
=======

Pull the mysql container::

    docker pull zetaris/zetaris-mysql

Initialize and run the database ::

    docker-machine ssh vm mkdir mysql
    docker run --name mysql -v /home/docker/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=vssvss -p 3306:3306 zetaris/zetaris-mysql

Change permissions for lightnign to connect ::

    docker exec -ti mysql bash
      - mysql -uroot -p
        - GRANT ALL ON *.* to root@'%' IDENTIFIED BY ‘vssvss'

To start mysql::

    docker start mysql

To stop  mysql::

    docker stop mysql


.. note:: Scripts and Files
Browse the code for this exercise at files_.
The same files can also be located under /srv/zetaris/docs/html/files in the respective containers

.. _files: ./files/exercise2