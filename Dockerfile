FROM node:16-stretch-slim
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN echo '
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse \
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse \

deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse \
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse \

deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse \
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse \

deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse \
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse \

deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse \
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse \
' > /etc/apt/sources.list.d/aliyun.list
RUN apt-get update  &&  apt-get upgrade -y  &&  apt-get install -y git build-essential python3
RUN mkdir /src
COPY . /src
WORKDIR /src
RUN npm install
ARG viewer
ARG fork
RUN git clone https://github.com/${fork:-camicroscope}/camicroscope.git --branch=${viewer:-master}
EXPOSE 4010

RUN chgrp -R 0 /src && \
    chmod -R g+rwX /src

USER 1001

CMD node caracal.js
