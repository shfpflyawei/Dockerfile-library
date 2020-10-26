FROM centos:7
MAINTAINER test
WORKDIR /usr/local/download
#RUN yum -y update & yum -y install yum-utils &yum -y install epel-release
RUN yum install -y  git  
RUN yum -y install python3
RUN git clone https://github.com/cr0hn/dockerscan.git
RUN python3 -m pip install -U pip && \
  python3 -m pip install -r requirements.txt 
EXPOSE 8000
CMD python3 ./dockerscan/setup.py
