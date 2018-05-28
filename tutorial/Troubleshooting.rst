#################
Troubleshooting
#################

**I have my database up and running , but I cannot connect them from lightning ?**

Check that lightnign can access the ip of the database. Theplatfor VM is running either in NAT or bridged mode.
And the remote datasource that you want to connect may be running in a different network. Resolve the connectivity issue first and then try.

If the remote datasource is the docker container pulled form zetaris docker hub. make sure the container are runnign in the same docker-machine as that of the VM. To verify this check that the docker-machine and the Platform VM  are in the same subnet.

You will get the ip address of platform VM when it spins up . You can get the ip of the docker machine using ``docker-machine env vm`` . Alternatively also check the containers has exposed the required ports to the docker-machien container. Lightning cant connect to the containers directly, the contianers expose the port to the dockermachine. And Lighning will connect to the exposed port in the docker machine.

**How do I move data to and from the docker contianers ?**

**When I restarted my machine I cant access the docker instances ?**

**I find the zetaris services in the status page in waiting mode for ever ?**



