FROM centos:7
MAINTAINER test
WORKDIR /usr/local/download
RUN yum install -y python3 git  
RUN git clone https://github.com/cr0hn/dockerscan.git
RUN python3 -m pip install -U pip && \
  python3 -m pip install -r requirement.txt 
EXPOSE 8000
CMD python3 ./dockerscan/setup.py
