# pull official base image
FROM python:3.8.1-slim-buster

# set work directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV DB_URI sqlite:///db.sqlite3

# install dependencies
RUN pip install --upgrade pip
COPY ./requirements.txt /usr/src/app/requirements.txt

COPY ./.env.dev /usr/src/app/
COPY services/web /usr/src/app/services/web


RUN pip install -r requirements.txt
EXPOSE 8080
WORKDIR /usr/src/app/services/web/project
RUN rm db.sqlite3
RUN python init_default_db.py
CMD gunicorn --bind 0.0.0.0:8080 --log-level debug project.wsgi:app