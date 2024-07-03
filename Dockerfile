# SPDX-License-Identifier: (GPL-2.0+ OR MIT)
# Copyright 2023 SDT.
# david.kang@sdt.inc 

FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    man-db \
    sudo


RUN apt-get update && apt-get install -y sudo openssl apt-utils

# Define username 
ENV USER=builder 


#setup locale
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y locales && dpkg-reconfigure locales --frontend noninteractive && locale-gen "en_US.UTF-8" && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# jig
RUN apt-get update && apt-get install -y \
     kpartx parted

# Yocto
RUN apt-get update && apt-get install -y \
     gawk wget git diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping libsdl1.2-dev xterm libyaml-dev libssl-dev \
     autoconf libtool libglib2.0-dev libarchive-dev \
     sed cvs subversion coreutils texi2html docbook-utils \
     help2man make gcc g++ desktop-file-utils libgl1-mesa-dev libglu1-mesa-dev \
     mercurial automake groff curl lzop asciidoc u-boot-tools dos2unix mtd-utils pv \
     libncurses5 libncurses5-dev libncursesw5-dev libelf-dev zlib1g-dev bc rename \
     zstd libgnutls28-dev

RUN apt-get update && apt-get install -y \
     python3-git zstd liblz4-tool

# For Ubuntu 20.04 and earlier, install python2:
RUN apt-get update && apt-get install -y \
     python python-pysqlite2

# Starting in Ubuntu 22.04, python2 is no longer available. Install the following to create a symbolic link from python to python3:
RUN apt-get update && apt-get install -y \
     python-is-python3

# # B2Qt
# RUN apt-get update && apt-get install -y \
#      gawk curl git-core diffstat unzip p7zip gcc-multilib g++-multilib \
#      build-essential chrpath libsdl1.2-dev xterm gperf bison texinfo rename

# # B2Qt git-lfs
# RUN apt-get install -y git-lfs || \
#      curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && apt-get install -y git-lfs

# # Debian
# RUN apt-get update && apt-get install -y \
#      binfmt-support qemu qemu-user-static debootstrap kpartx \
#      lvm2 dosfstools gpart binutils bison git lib32ncurses5-dev libssl-dev gawk wget \
#      git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat libsdl1.2-dev \
#      autoconf libtool libglib2.0-dev libarchive-dev xterm sed cvs subversion \
#      kmod coreutils texi2html bc docbook-utils python-pysqlite2 help2man make gcc g++ \
#      desktop-file-utils libgl1-mesa-dev libglu1-mesa-dev mercurial automake groff curl \
#      lzop asciidoc u-boot-tools mtd-utils device-tree-compiler flex \
#      rsync cmake

# # Android
# RUN apt-get update && apt-get install -y \
#      gnupg flex bison gperf build-essential zip gcc-multilib g++-multilib \
#      libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libz-dev libssl-dev \
#      libgl1-mesa-dev libxml2-utils xsltproc unzip bc \
#      uuid uuid-dev zlib1g-dev liblz-dev liblzo2-2 liblzo2-dev lzop git curl \
#      u-boot-tools mtd-utils android-tools-fsutils device-tree-compiler gdisk m4 \
#      openjdk-8-jdk

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo && chmod a+rx /bin/repo

# Install development utilities
RUN apt-get update && apt-get install -y \
     vim tmux

# # Install others 
# RUN apt-get update && apt-get install -y \
#      liblz4-tool zstd 



# Update to latest
RUN apt-get update && apt-get dist-upgrade -y

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install SSH server
RUN apt-get update && apt-get install -y openssh-server
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config


# repo update  
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > repo
RUN chmod a+x repo
RUN mv repo /usr/local/bin

# set python 3 as the default python version
RUN sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1 


# User management 
RUN useradd  -m -s /bin/bash ${USER} && \
usermod -a -G sudo ${USER} && \
usermod -a -G root ${USER}
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create Working Directory
RUN mkdir /home/${USER}/Workspace
RUN mkdir /home/${USER}/Workspace/yocto-imx
RUN chmod -R +777 /home/${USER}



WORKDIR /home/${USER}/Workspace/yocto-imx


RUN git config --system user.name "mirikaKang" && git config --system user.email "david.kang@sdt.inc"

RUN cd /home/${USER}/Workspace/yocto-imx 
RUN repo init -u https://github.com/varigit/variscite-bsp-platform.git -b mickledore -m imx-6.1.36-2.1.0.xml
RUN sudo repo sync -j4
