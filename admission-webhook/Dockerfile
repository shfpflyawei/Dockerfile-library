FROM  apache/apisix:2.13.3-centos
RUN yum -y install wget && wget https://openresty.org/package/centos/openresty.repo && mv openresty.repo /etc/yum.repos.d/openresty.repo && yum-config-manager --add-repo https://repos.apiseven.com/packages/centos/apache-apisix.repo  && yum check-update &&yum install openresty-resty openresty -y && yum -y install apisix-2.13
