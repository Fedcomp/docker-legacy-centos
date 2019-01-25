FROM centos:7

COPY ./RPM-GPG-KEY-CentOS-4 /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-4
RUN rm -rvf /etc/yum.repos.d/*
COPY ./CentOS-Vault.repo /etc/yum.repos.d/
RUN yum -y --installroot=/mnt install centos-release yum

# Move to /mnt as chroot into centos 4.0
FROM scratch
COPY --from=0 /mnt /
COPY .bashrc /root/
