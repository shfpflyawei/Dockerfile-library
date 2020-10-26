FROM centos:7
MAINTAINER test
WORKDIR /usr/local/download
RUN yum install -y python git  
RUN git clone https://github.com/cr0hn/dockerscan.git
RUN python -m pip install -U pip && \
  python -m pip install -r requirement.txt 
EXPOSE 8000
CMD python ./dockerscan/setup.py
