FROM registry.access.redhat.com/ubi8/ubi

ENV container=docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum -y install \
        cronie \
        gcc \
        less \
        python38-pip \
        python38-setuptools \
        python3-libselinux \
        python38 \
        python38-devel \
        selinux-policy-targeted \
        sudo \
        vim \
    && rm -rf /var/cache/yum

RUN pip3 install ansible q

RUN sed -i 's/Defaults    requiretty/Defaults    !requiretty/g' /etc/sudoers

RUN echo '# BLANK FSTAB' > /etc/fstab

RUN mkdir -p /etc/ansible && \
    echo -e "localhost ansible_connection=local ansible_python_interpreter=/usr/bin/python3" > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/sbin/init"]
