##################
Exercise2
##################

To complete this exercise you will need the following setup

      - Zetaris Platform VM
      - Postgres
      - Mysql

If you find it difficult to set the database up and running. You get the contianer from zetaris docker hub and get it up and running

Zetaris Platform VM
======================

Follow the instructions under Download and Go start guide. <link>


Postgres
==========

Pull the postgres container::

    docker pull zetaris/zetaris-postgres

To init the postgres::

    docker run -ti  --security-opt=label:disable -v /home/docker/srv:/srv:rw zetaris/zetaris-postgres:9.6-3 /init.sh

To spin up the container::

    docker run -d -ti --security-opt=label:disable --name postgres -p 5432:5432 -v /home/docker/srv:/srv:rw zetaris/zetaris-postgres:9.6-3 /bin/bash`

To start postgres::

    docker exec -d -ti --user postgres:postgres postgres /start.sh

To stop postgres::

    docker exec -d -ti --user postgres:postgres postgres /start.sh

Mysql
=======

Pull the mysql container::

    docker pull zetaris/zetaris-mysql

To start mysql::

    docker start mysql1

To stop  mysql::

    docker stop mysql1


NB
All data and scripts for the exercise are present under the platform-VM and the containers under the directory - /srv/zetaris/docs/html/tutorial/files/
