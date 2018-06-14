###########################
Setting up the environment
###########################


Requirements
=============

   *   VMWare fusion/vmware workstation
   *   Docker
   *   Zetaris Vplatform VM and zetaris tutorial docker images



Docker setup
============

Mac/VMware fusion
----------------------

The tuorials are build upon the Zetaris Lite Platform(Virtual Machine) and auxiliary docker images. To get these running on Mac we recommend the following

         - VMWare Fusion
         - Docker

To setup VMWare fusion - download the binaries from - https://my.vmware.com

Once the VMware is setup .One should be able to spin up and trial the Zetaris platform VM.

To run the docker images associated with the tutorial we need to install Docker.Get the latest docker from - https://www.docker.com


Configuring Docker in Mac.
~~~~~~~~~~~~~~~~~~~~~~~~~~~

One need to make sure that both the VM and the tutorial docker should run within the same Visualizer.

In our case its VMWare. Hence we need to setup docker to use vmware as the docker-machine driver.

Check that the docker machine have the vmware based docker machine created.::

    docker-machine ls 

If it displays something like

+--------+---------+--------------+-----------+---------------------------+---------+-------------+--------------+
|NAME    |  ACTIVE |  DRIVER      |   STATE   |          URL              |  SWARM  | DOCKER      |  ERRORS      |
+--------+---------+--------------+-----------+---------------------------+---------+-------------+--------------+
|default |   -     |  virtualbox  |   Saved   |                           |         | Unknown     |              |
+--------+---------+--------------+-----------+---------------------------+---------+-------------+--------------+
|native  |   -     |  xhyve       |   Running |  tcp://192.168.64.2:2376  |         | v18.05.0-ce |              |
+--------+---------+--------------+-----------+---------------------------+---------+-------------+--------------+
|vm      |   -     |  vmwarefusion|   Running |  tcp://172.16.15.154:2376 |         | v18.05.0-ce |              |
+--------+---------+--------------+-----------+---------------------------+---------+-------------+--------------+ 
                                                                                                         

Where the vmware fusion machine is already created and up and running .Then you are ready to go. Else you need to create one.

Create the vmware based docker machine::

    docker-machine create --driver vmwarefusion vm

Recreate the security certificate to access this machine::

    docker-machine regenerate-certs --client-certs vm

Now you should be able to see the vmware based docker machine running. To get its info ::

    docker-machine env vm

To set docker to use this docker machine::

    eval "$(docker-machine env vm)

It should show something like::

    export DOCKER_TLS_VERIFY="1"
    export DOCKER_HOST="tcp://172.16.15.154:2376"
    export DOCKER_CERT_PATH="/Users/varun/.docker/machine/machines/vm"
    export DOCKER_MACHINE_NAME="vm"
    # Run this command to configure your shell:
    # eval $(docker-machine env vm)

To copy files into the docker machine one sould ssh into them::

    ssh docker@172.16.15.154

Now you could start pulling the docker images for the various tutorials.


Windows/VMware workstation
------------------------------

To get these running on Windows we recommend the following

Docker Machine VMware Workstation Driver
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This plugin for Docker Machine creates Docker hosts locally on a VMware Workstation.

REQUIREMENTS

  * Windows 7+ (for now)
  * Docker Machine 0.5.0+
  * VMware Workstation Workstation Free/Pro 10 +

One need to make sure that both the VM and the tutorial docker should run within the same Visualizer.

We need to setup docker to use vmware as the docker-machine driver.

**Installing with Docker Toolbox**

- Install Docker Toolbox without VirtualBox::

    DockerToolbox-.exe /COMPONENTS="Docker,DockerMachine"


- Replace contents of ``C:\Program Files\Docker Toolbox\start.sh`` with this script.


Click here to download driver for start file

:download:`start.sh <doc/start.sh>`

**Usage**

To create a VMware Workstation based Docker machine, just run this command::

    $ docker-machine create --driver=vmwareworkstation vm


**Options**::

    --vmwareworkstation-boot2docker-url: The URL of the Boot2Docker image.
    --vmwareworkstation-disk-size: Size of disk for the host VM (in MB).
    --vmwareworkstation-memory-size: Size of memory for the host VM (in MB).
    --vmwareworkstation-cpu-count: Number of CPUs to use to create the VM (-1 to use the number of CPUs available).
    --vmwareworkstation-ssh-user: SSH user
    --vmwareworkstation-ssh-password: SSH password

Recreate the security certificate to access this machine::

    docker-machine regenerate-certs --client-certs vm

Now you should be able to see the vmware based docker machine running. To get its info ::

    docker-machine env vm

To set docker to use this docker machine::

    eval "$(docker-machine env vm)

It should show something like::

    export DOCKER_TLS_VERIFY="1"
    export DOCKER_HOST="tcp://172.16.15.154:2376"
    export DOCKER_CERT_PATH="/Users/foobar/.docker/machine/machines/vm"
    export DOCKER_MACHINE_NAME="vm"
    # Run this command to configure your shell:
    # eval $(docker-machine env vm)
