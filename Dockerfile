# Inspired from : https://github.com/LiveOverflow/pwn_docker_example
# docker build -t ctf:ubuntu20.04 .
# If using Windows (CMD)
#   docker run --rm -v %cd%:/pwd --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -d --name ctf -i ctf:ubuntu20.04
# If using Windows (Powershell)
#   docker run --rm -v ${PWD}:/pwd --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -d --name ctf -i ctf:ubuntu20.04
# If using Linux    
#   docker run --rm -v $PWD:/pwd --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -d --name ctf -i ctf:ubuntu20.04
# docker exec -it ctf /bin/bash

# https://dev.to/darksmile92/run-gui-app-in-linux-docker-container-on-windows-host-4kde
# set-variable -name DISPLAY -value 192.168.1.2:0.0
# docker run --rm -v ${PWD}:/pwd -e DISPLAY=${DISPLAY} --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -d --name ctf -i ctf:ubuntu20.04

FROM ubuntu:20.04
ENV LC_CTYPE C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y build-essential strace ltrace curl wget rubygems gcc dnsutils netcat gcc-multilib net-tools vim gdb gdb-multiarch libssl-dev libffi-dev wget git make procps libpcre3-dev libdb-dev libxt-dev libxaw7-dev software-properties-common default-jdk libimage-exiftool-perl autoconf
RUN add-apt-repository universe
RUN apt-get install -y python2 python2-dev python3 python3-pip python3-dev 
RUN curl https://bootstrap.pypa.io/get-pip.py --output /tmp/get-pip.py
RUN python2 /tmp/get-pip.py
RUN wget https://golang.org/dl/go1.15.2.linux-amd64.tar.gz -O /tmp/go1.15.2.linux-amd64.tar.gz
RUN cd /tmp && tar -C /usr/local -xzf go1.15.2.linux-amd64.tar.gz
ENV PATH="${PATH}:/usr/local/go/bin:/root/go/bin"
RUN pip install capstone requests pwntools pycrypto pillow
RUN pip3 install pwntools keystone-engine unicorn capstone ropper pycrypto pillow
RUN mkdir /tools
RUN git clone https://github.com/JonathanSalwan/ROPgadget /tools/ROPgadget
RUN git clone https://github.com/pwndbg/pwndbg.git /tools/pwndbg
RUN cd /tools/pwndbg && ./setup.sh --with-python=$(which python3)
RUN gem install one_gadget
RUN git clone https://github.com/NixOS/patchelf.git /tools/patchelf
RUN cd /tools/patchelf && ./bootstrap.sh && ./configure && make && make check && make install
# RUN git clone https://github.com/niklasb/libc-database /tools/libc-database
# RUN cd /tools/libc-database && ./get ubuntu

WORKDIR /pwd
