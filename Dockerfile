# Inspired from : https://github.com/LiveOverflow/pwn_docker_example
# docker build -t ctf:ubuntu20.04 .
# If using Windows (CMD)
#   docker run --rm -v %cd%:/pwd --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -d --name ctf -i ctf:ubuntu19.10
# If using Windows (Powershell)
#   docker run --rm -v ${PWD}:/pwd --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -d --name ctf -i ctf:ubuntu19.10
# If using Linux    
#   docker run --rm -v $PWD:/pwd --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -d --name ctf -i ctf:ubuntu19.10
# docker exec -it ctf /bin/bash

FROM ubuntu:20.04
ENV LC_CTYPE C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y build-essential strace ltrace curl wget rubygems gcc dnsutils netcat gcc-multilib net-tools vim gdb gdb-multiarch libssl-dev libffi-dev wget git make procps libpcre3-dev libdb-dev libxt-dev libxaw7-dev libc6:i386 libncurses5:i386 libstdc++6:i386 software-properties-common
RUN add-apt-repository universe
RUN apt-get install -y python2 python2-dev python3 python3-pip python3-dev 
RUN curl https://bootstrap.pypa.io/get-pip.py --output /tmp/get-pip.py
RUN python2 /tmp/get-pip.py
RUN pip install capstone requests pwntools r2pipe
RUN pip3 install pwntools keystone-engine unicorn capstone ropper
RUN mkdir /tools
RUN git clone https://github.com/JonathanSalwan/ROPgadget /tools/ROPgadget
RUN git clone https://github.com/radare/radare2 /tools/radare2
RUN cd /tools/radare2 && sys/install.sh
RUN git clone https://github.com/longld/peda.git /tools/peda
RUN echo "source /tools/peda/peda.py" >> ~/.gdbinit
RUN git clone https://github.com/niklasb/libc-database /tools/libc-database
RUN gem install one_gadget
# RUN cd /tools/libc-database && ./get ubuntu