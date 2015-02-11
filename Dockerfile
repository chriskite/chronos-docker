FROM ubuntu:14.04

# add mesosphere repo and keys
RUN echo "deb http://repos.mesosphere.io/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/mesosphere.list
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF

# update apt
RUN apt-get update && apt-get dist-upgrade -y

# install the things we need
RUN apt-get install -qqy --force-yes mesos=0.21.1-1.1.ubuntu1404 chronos=2.3.2-0.1.20150207000917.ubuntu1404

# Clean up when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm /etc/mesos/zk
RUN rm /etc/chronos/conf/http_port

EXPOSE 8081

ENTRYPOINT ["/usr/bin/chronos"]
