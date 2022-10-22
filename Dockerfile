FROM ubuntu:20.04

RUN apt-get update -y

RUN apt-get install -y python-dev python3-pip

COPY ./requirements.txt /python-app/requirements.txt
WORKDIR /python-app
RUN pip install -r requirements.txt

COPY ./python-webpage.py /python-app/python-webpage.py

EXPOSE 8080

ENTRYPOINT ["python3", "python-webpage.py"]