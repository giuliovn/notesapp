FROM python:3.6.8

COPY . /app
WORKDIR /app
RUN pip3 install -r requirements.txt
RUN chmod +x notes.py 

ENTRYPOINT ./notes.py