FROM ubuntu:20.04

RUN apt-get update && \
apt-get install -y software-properties-common && \
apt-add-repository universe && \
apt-get install -y python3-pip && \
apt-get install -y net-tools && \
apt-get install -y iproute2 && \
apt-get install -y libpq-dev && \
apt-get install -y python-dev


RUN python3 -m pip install --upgrade pip

RUN pip3 install substrate-interface

RUN pip3 install requests


RUN mkdir app
WORKDIR app

