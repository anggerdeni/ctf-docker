FROM ubuntu:18.04
ENV LC_CTYPE C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y build-essential strace ltrace curl wget rubygems ruby-dev gcc dnsutils netcat gcc-multilib net-tools vim gdb gdb-multiarch libssl-dev libffi-dev wget git make procps libpcre3-dev libdb-dev libxt-dev libxaw7-dev software-properties-common default-jdk libimage-exiftool-perl autoconf tmux sudo
RUN add-apt-repository universe
RUN apt-get install -y python3 python3-pip python3-dev 
RUN gem install seccomp-tools one_gadget
RUN wget https://golang.org/dl/go1.15.2.linux-amd64.tar.gz -O /tmp/go1.15.2.linux-amd64.tar.gz
RUN cd /tmp && tar -C /usr/local -xzf go1.15.2.linux-amd64.tar.gz
RUN useradd -ms /bin/bash ctf
RUN mkdir /tools
RUN chown ctf:ctf /tools
RUN adduser ctf sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER ctf
ENV PATH="${PATH}:/usr/local/go/bin:/root/go/bin:/home/ctf/.local/bin"
RUN pip3 install pwntools requests keystone-engine unicorn capstone ropper pycryptodome pillow
RUN git clone https://github.com/JonathanSalwan/ROPgadget /tools/ROPgadget
RUN git clone https://github.com/pwndbg/pwndbg.git /tools/pwndbg
RUN cd /tools/pwndbg && ./setup.sh --with-python=$(which python3)
RUN git clone https://github.com/NixOS/patchelf.git /tools/patchelf
RUN cd /tools/patchelf && sudo ./bootstrap.sh && sudo ./configure && sudo make && sudo make check && sudo make install
WORKDIR /pwd
