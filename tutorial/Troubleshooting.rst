#################
Troubleshooting
#################

**I have my database up and running , but I cannot connect them from lightning ?**

Check that lightnign can access the ip of the database. Theplatfor VM is running either in NAT or bridged mode.
And the remote datasource that you want to connect may be running in a different network. Resolve the connectivity issue first and then try.

If the remote datasource is the docker container pulled form zetaris docker hub. make sure the container are runnign in the same docker-machine as that of the VM. To verify this check that the docker-machine and the Platform VM  are in the same subnet.

You will get the ip address of platform VM when it spins up . You can get the ip of the docker machine using ``docker-machine env vm`` . Alternatively also check the containers has exposed the required ports to the docker-machien container. Lightning cant connect to the containers directly, the contianers expose the port to the dockermachine. And Lighning will connect to the exposed port in the docker machine.

**How do I move data to and from the docker contianers ?**

To copy files into docker , Once will have to first copy the files into the docker-machine. And from there mount the files into docker container. Using ``docker-machine scp <src> vm:<dest>`` where the ``vm`` the name of docker machine and ``<dest>`` is the folder which would be mounted to docker and ``<src>`` is the folder in your local machine

**When I restarted my machine I cant access the docker instances ?**

Check if the docker-machine environment variable is set. If not execute eval $(docker-machine env vm).  In some cases the VMware driver used by the docker machine could be an old version , and this could lead inconsistancy . Get the lastest driver from `docker-machine-driver-vmware <https://github.com/machine-drivers/docker-machine-driver-vmware>`_ . Build the driver and use it.

**I find the zetaris services in the status page in waiting mode for ever ?**

None of the service should take more than 5 min to startup. If it stays in waiting mode for more than 10 minutes it could mean :

  - The service is hung - Stop and start the service to resolve the deadlock .
  - The license have expired - You need to contact zetaris to renew the license .
  - The network failed - You can restart the VM.



