
# pull official base image
FROM python:3.8

# To print output to the terminal
ENV PYTHONUNBUFFERED 1

# create and set working directory
RUN mkdir /service
WORKDIR /service

# Copy requirements and install with pip
COPY requirements.txt /service/
RUN pip install -r requirements.txt

# Copy contents to service folder
COPY . /service/




