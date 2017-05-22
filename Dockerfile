FROM shadowrobot/build-tools:xenial-kinetic

MAINTAINER "Shadow Robot's Software Team <software@shadowrobot.com>"

LABEL Description="An image generated during the testing of Shadow's release procedures." Version="1.0"

ENV remote_shell_script="https://raw.githubusercontent.com/shadow-robot/sr-build-tools/$toolset_branch/ansible/deploy.sh"

ENV PROJECTS_WS=/home/user/projects/shadow_robot
ENV toolset_repo=build-servers-check-release
ENV toolset_branch=kinetic-devel
ARG GITHUB_LOGIN
ARG GITHUB_PASSWORD

RUN set +x && \

    echo "Running one-liner" && \
    apt-get update && \
    wget -O /tmp/oneliner "$( echo "$remote_shell_script" | sed 's/#/%23/g' )" && \
    chmod 755 /tmp/oneliner && \
    gosu $MY_USERNAME /tmp/oneliner -w $PROJECTS_WS/base -r $toolset_repo -b $toolset_branch -i repository.rosinstall -v "kinetic" -l $GITHUB_LOGIN -p $GITHUB_PASSWORD && \
    
    echo "Removing cache" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/usr/bin/terminator"]
