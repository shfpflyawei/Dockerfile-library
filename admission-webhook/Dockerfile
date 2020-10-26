CMD python3 ./dockerscan/setup.py
FROM golang:1.10 as build
RUN apt update
RUN apt install -y python3 &&  python3 -m pip install -U pip
RUN pip3 install dockerscan

EXPOSE 8000
CMD python3 ./dockerscan/setup.py
