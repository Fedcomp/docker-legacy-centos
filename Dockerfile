FROM centos:7

# Install Centos 4.9 repository certificate
COPY ./RPM-GPG-KEY-CentOS-4 /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-4

# Remove default repositories, only vault is available now for centos 4.9
RUN rm -rvf /etc/yum.repos.d/*
COPY ./CentOS-Vault.repo /etc/yum.repos.d/
RUN yum -y --installroot=/mnt install centos-release yum

# ------- Chroot into centos 4.9 WITHOUT package database -------
FROM scratch
COPY --from=0 /mnt /

# Install Centos 4.9 repository certificate
RUN mkdir -p /etc/pki/rpm-gpg/
COPY ./RPM-GPG-KEY-CentOS-4 /etc/pki/rpm-gpg/

# Remove default repositories, only vault is available now
RUN rm -f /etc/yum.repos.d/CentOS-Base.repo
COPY ./CentOS-Vault.repo /etc/yum.repos.d/

# rpm and yum won't work without working package database
RUN rm /var/lib/rpm/*

# Hotfix for the next command
RUN mkdir -p /mnt/var/lock/rpm/
# Install clear system with working package database
RUN yum -y --installroot=/mnt install centos-release yum

# # ------- Chroot into centos 4.9 WITH package database -------
FROM scratch
COPY --from=1 /mnt /

# Install Centos 4.9 repository certificate
RUN mkdir -p /etc/pki/rpm-gpg/
COPY ./RPM-GPG-KEY-CentOS-4 /etc/pki/rpm-gpg/

# Remove default repositories, only vault is available now
RUN rm -f /etc/yum.repos.d/CentOS-Base.repo
COPY ./CentOS-Vault.repo /etc/yum.repos.d/

# # Make PS1 more friendly :)
COPY .bashrc /root/
