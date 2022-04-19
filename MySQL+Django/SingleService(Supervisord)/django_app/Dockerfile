FROM ubuntu:latest

# avoid debconf and initrd
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

# install packages
RUN apt-get update -qq && apt-get upgrade -y --autoremove -qq

RUN apt-get install -y python3-pip python3-dev nginx openssh-server mysql-server supervisor

# make /var/run/sshd
RUN mkdir /var/run/sshd

# setup mysql
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
ADD set-mysql-password.sh /tmp/set-mysql-password.sh

ARG MYSQL_SOCKET_DIRECTORY='/var/run/mysqld'

RUN mkdir -p $MYSQL_SOCKET_DIRECTORY && \
    chown root:mysql $MYSQL_SOCKET_DIRECTORY && \
    chmod 777 $MYSQL_SOCKET_DIRECTORY

RUN export MYSQL_DATABASE=app && export MYSQL_USER=user && export MYSQL_PASSWORD=userpass

RUN /bin/sh /tmp/set-mysql-password.sh

# set root password
RUN echo "root:root" | chpasswd

# clean packages
RUN apt-get clean
RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

COPY . .

# virtual env python
ENV PYTHONBUFFERED=1
RUN pip3 install --no-cache -r requirements.txt

EXPOSE 22 3306 3303

# volumes
VOLUME ["/var/lib/mysql"]

# copy supervisor conf
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN ["chmod", "+x", "./migrate.sh"]
RUN ["./migrate.sh"]
# start supervisor
CMD ["/usr/bin/supervisord"]
