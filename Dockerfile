FROM shadowrobot/build-tools:xenial-kinetic

MAINTAINER "Shadow Robot's Software Team <software@shadowrobot.com>"

LABEL Description="An image generated during the testing of Shadow's release procedures." Version="1.0"

ENV remote_shell_script="https://raw.githubusercontent.com/shadow-robot/sr-build-tools/$toolset_branch/ansible/deploy.sh"

ENV PROJECTS_WS=/home/user/projects/shadow_robot
ENV toolset_repo=build-servers-check-release
ENV toolset_branch=F_ssh_test

RUN set +x && \

    echo "Getting ssh key from the http server" && \
    mkdir /home/user/.ssh && \
    wget -O /home/user/.ssh/id_rsa http://172.17.0.1:8008/id_rsa && \
    ssh-keyscan github.com >> /home/user/.ssh/known_hosts && \
    chmod 400 /home/user/.ssh/id_rsa && \
    chown -R $MY_USERNAME:$MY_USERNAME /home/user/.ssh && \
    

    echo "Running one-liner" && \
    apt-get update && \
    wget -O /tmp/oneliner "$( echo "$remote_shell_script" | sed 's/#/%23/g' )" && \
    chmod 755 /tmp/oneliner && \
    gosu $MY_USERNAME /tmp/oneliner -w $PROJECTS_WS/base -r $toolset_repo -b $toolset_branch -i repository.rosinstall -v "kinetic" && \

    
    echo "Removing cache" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /home/$MY_USERNAME/.ssh/*
    
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/usr/bin/terminator"]
