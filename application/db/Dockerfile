
# pull official base image
FROM python:3.8.2-alpine

# To print output to the terminal
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# create and set working directory
RUN mkdir /db
WORKDIR /db

# Copy requirements and install with pip
RUN pip install --upgrade pip
COPY requirements.txt ./
RUN pip install -r requirements.txt

# Copy contents to service folder
COPY ./db ./

# Apply database migrations
RUN python manage.py migrate

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

