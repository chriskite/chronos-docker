FROM phusion/baseimage:0.9.15

# Set correct environment variables.
ENV HOME /root

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# add mesosphere repo and keys
RUN echo "deb http://repos.mesosphere.io/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/mesosphere.list
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF

# update apt
RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -qqy --force-yes curl ruby openjdk-7-jdk

# install mesos (for the libraries)
RUN sudo apt-get -y install mesos=0.21.0-1.0.ubuntu1404

# add zookeepers helper script
ADD ./zookeepers.rb /usr/local/bin/zookeepers.rb

# install chronos
RUN curl -sSfL http://downloads.mesosphere.io/chronos/chronos-2.1.0_mesos-0.14.0-rc4.tgz --output chronos.tgz
RUN tar -xzf chronos.tgz
ADD run /etc/service/chronos/run

# Clean up when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* chronos.tgz

EXPOSE 8081
