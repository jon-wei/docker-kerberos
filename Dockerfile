FROM centos:6.6
MAINTAINER SequenceIQ

# EPEL
RUN rpm -Uvh https://vault.centos.org/6.10/extras/x86_64/Packages/epel-release-6-8.noarch.rpm

RUN sed -i -e 's!mirrorlist!#mirrorlist!g' /etc/yum.repos.d/CentOS-Base.repo; \
    sed -i -e 's!#baseurl=http://mirror.centos.org/centos/\$releasever!baseurl=https://vault.centos.org/6.10/!g' /etc/yum.repos.d/CentOS-Base.repo;

RUN sed -i 's/https/http/g' /etc/yum.repos.d/epel.repo

# kerberos
RUN yum install -y krb5-server krb5-libs krb5-auth-dialog krb5-workstation perl && yum clean all

# zulu java 8
COPY setup-zulu-repo.sh /root/setup-zulu-repo.sh
RUN /root/setup-zulu-repo.sh
RUN yum clean all && rpm --rebuilddb && yum install -y zulu-8 && yum clean all

ENV JAVA_HOME /usr/lib/jvm/zulu-8
ENV PATH $PATH:$JAVA_HOME/bin

EXPOSE 88 749 8888

ADD ./config.sh /config.sh

ENTRYPOINT ["/config.sh"]