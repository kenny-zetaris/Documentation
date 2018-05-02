#######################################################
Zetaris lightning build instructions
#######################################################

Build lightinig docker image
===============================

Clone zetaris automamtion source code from git to ``centos`` user home under a directory named codebase.::

    cd /home/centos
    mkdir codebase
    cd /home/centos/codebase
    git clone https://github.com/zetaris/ZMPP-Automation.git

Now create docker image from lightning configuration code using ``ansible-container``.::
     
     cd /home/centos/codebase/ZMPP-Automation/Ansible-container/lght-build
     ansible-container --vars-file build-vars.yml build --roles-path ../../Ansible-playbooks-scripts/roles -- --tags 'docker-img-build'

Check that the docker images has been successfully created using ``docker images``.
 
Now login to the created lightning docker image ::

     docker run -ti -v /home/centos/codebase/ZMPP-Automation:/data/Automation:rw -v /home/centos/codebase/zetaris-lightning:/data/Lightning:rw -v /home/centos/packages/:/root/packages:rw -v /repo-rhel:/repo:rw zetaris-lightning-build:latest /bin/bash

now set the environment variables::

    export BUNDLE_HOME=/data/Automation
    export SRCPATH=/data/Lightning
    export VERSION_NAME=zetaris-lightning-1.2.1.1-production

Now run the ansible playbook that builds the lightning binary.::

    ansible-playbook -i localhost, -vvvv -c local /data/Automation/Ansible-playbooks-scripts/playbook-bamboo-tasks.yml --tags "docker-release" --skip-tags "zmpp,lightning-gui,repo,znifi,installer,spark,zeppelin,alchemist,monitor,gateway,agent"