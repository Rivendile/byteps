FROM horovod/horovod:0.16.1-tf1.12.0-torch1.0.0-mxnet1.4.0-py2.7

ENV USE_BYTESCHEDULER=1
ENV BYTESCHEDULER_WITH_MXNET=1
ENV BYTESCHEDULER_WITHOUT_PYTORCH=1
ENV MXNET_ROOT=/root/incubator-mxnet

WORKDIR /home/cluster

# install general dependencies
RUN apt-get install -y openssh-server openssh-client vim sudo

# setup cluster user and SSH access to container
ENV USER cluster
RUN useradd -ms /bin/bash $USER && usermod -p '*' $USER && usermod -g root cluster && echo "$USER:$USER" | chpasswd && adduser cluster sudo
ENV HOME /home/$USER
ENV SSHDIR $HOME/.ssh
RUN mkdir -p ${SSHDIR} \
    && touch ${SSHDIR}/sshd_config \
    && ssh-keygen -t rsa -f ${SSHDIR}/ssh_host_rsa_key -N '' \
    && cp ${SSHDIR}/ssh_host_rsa_key.pub ${SSHDIR}/authorized_keys \
    && cp ${SSHDIR}/ssh_host_rsa_key ${SSHDIR}/id_rsa \
    && echo "    IdentityFile ${SSHDIR}/id_rsa" >> ${SSHDIR}/config \
    && echo "    StrictHostKeyChecking no" >> ${SSHDIR}/config \
    && echo "    UserKnownHostsFile /dev/null" >> ${SSHDIR}/config \
    && echo "    Port 2022" >> ${SSHDIR}/config \
    && echo 'Port 2022' >> ${SSHDIR}/sshd_config \
    && echo "HostKey ${SSHDIR}/ssh_host_rsa_key" >> ${SSHDIR}/sshd_config \
    && echo "PidFile ${SSHDIR}/sshd.pid" >> ${SSHDIR}/sshd_config \
    && echo "PasswordAuthentication no" >> ${SSHDIR}/sshd_config \
    && chmod -R 600 ${SSHDIR}/* \
    && chown -R ${USER}:${USER} ${SSHDIR}/

# Install gcc 4.9
RUN mkdir -p /root/gcc/ && cd /root/gcc &&\
    wget http://launchpadlibrarian.net/247707088/libmpfr4_3.1.4-1_amd64.deb &&\
    wget http://launchpadlibrarian.net/253728424/libasan1_4.9.3-13ubuntu2_amd64.deb &&\
    wget http://launchpadlibrarian.net/253728426/libgcc-4.9-dev_4.9.3-13ubuntu2_amd64.deb &&\
    wget http://launchpadlibrarian.net/253728314/gcc-4.9-base_4.9.3-13ubuntu2_amd64.deb &&\
    wget http://launchpadlibrarian.net/253728399/cpp-4.9_4.9.3-13ubuntu2_amd64.deb &&\
    wget http://launchpadlibrarian.net/253728404/gcc-4.9_4.9.3-13ubuntu2_amd64.deb &&\
    wget http://launchpadlibrarian.net/253728432/libstdc++-4.9-dev_4.9.3-13ubuntu2_amd64.deb &&\
    wget http://launchpadlibrarian.net/253728401/g++-4.9_4.9.3-13ubuntu2_amd64.deb

RUN cd /root/gcc &&\
    dpkg -i gcc-4.9-base_4.9.3-13ubuntu2_amd64.deb &&\
    dpkg -i libmpfr4_3.1.4-1_amd64.deb &&\
    dpkg -i libasan1_4.9.3-13ubuntu2_amd64.deb &&\
    dpkg -i libgcc-4.9-dev_4.9.3-13ubuntu2_amd64.deb &&\
    dpkg -i cpp-4.9_4.9.3-13ubuntu2_amd64.deb &&\
    dpkg -i gcc-4.9_4.9.3-13ubuntu2_amd64.deb &&\
    dpkg -i libstdc++-4.9-dev_4.9.3-13ubuntu2_amd64.deb &&\
    dpkg -i g++-4.9_4.9.3-13ubuntu2_amd64.deb

# Pin GCC to 4.9 (priority 200) to compile correctly against MXNet
RUN update-alternatives --install /usr/bin/gcc gcc $(readlink -f $(which gcc)) 100 && \
    update-alternatives --install /usr/bin/x86_64-linux-gnu-gcc x86_64-linux-gnu-gcc $(readlink -f $(which gcc)) 100 && \
    update-alternatives --install /usr/bin/g++ g++ $(readlink -f $(which g++)) 100 && \
    update-alternatives --install /usr/bin/x86_64-linux-gnu-g++ x86_64-linux-gnu-g++ $(readlink -f $(which g++)) 100
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 200 && \
    update-alternatives --install /usr/bin/x86_64-linux-gnu-gcc x86_64-linux-gnu-gcc /usr/bin/gcc-4.9 200 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 200 && \
    update-alternatives --install /usr/bin/x86_64-linux-gnu-g++ x86_64-linux-gnu-g++ /usr/bin/g++-4.9 200

# May need to uninstall default MXNet and install mxnet-cu90==1.5.0

# Clone MXNet as ByteScheduler compilation requires header files
RUN git clone --recursive --branch v1.5.x https://github.com/apache/incubator-mxnet.git
RUN cd incubator-mxnet && git reset --hard 75a9e187d00a8b7ebc71412a02ed0e3ae489d91f

# Install ByteScheduler
RUN pip install bayesian-optimization==1.0.1
RUN git clone --branch bytescheduler --recursive https://github.com/Rivendile/byteps.git && \
    cd byteps/bytescheduler && python setup.py install

# Examples
WORKDIR /root/byteps/bytescheduler/examples/mxnet-image-classification

# Set default shell to /bin/bash
SHELL ["/bin/bash", "-cu"]

EXPOSE 2022

COPY container_entrypoint.sh /etc/

RUN chmod +x /etc/container_entrypoint.sh
ENTRYPOINT /etc/container_entrypoint.sh
