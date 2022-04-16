FROM alpine:3.14
RUN apk add python3-dev
RUN mkdir /app
WORKDIR /app

ADD . /app/

RUN apk add  --no-cache mariadb-connector-c-dev
RUN apk add --update --no-cache mariadb-dev build-base wget freetype-dev libpng-dev openblas-dev g++

ENV PYTHONBUFFERED=1
RUN apk add --update python3 python3-dev py3-pip && pip3 install setuptools mysqlclient
RUN apk add py3-pandas py3-cryptography && pip3 install typing_extensions requests django pymysql whitenoise

RUN ln -s /usr/include/locale.h /usr/include/xlocale.h && rm -rf /var/cache/apk/*

RUN apk add netcat-openbsd