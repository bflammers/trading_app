
# pull official base image
FROM python:3.8.2-alpine

# To print output to the terminal
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# set working directory
WORKDIR /db

# install psycopg2 dependencies
RUN apk update \
    && apk add postgresql-dev gcc python3-dev musl-dev

# Copy requirements and install with pip
RUN pip install --upgrade pip
COPY ./requirements.txt ./
RUN pip install -r requirements.txt

COPY ./docker-entrypoint.sh .

# Copy contents to service folder
COPY ./ ./

# Apply database migrations
# RUN python manage.py migrate

# CMD [".", "docker-entrypoint.sh"]

# run entrypoint.sh
ENTRYPOINT ["sh", "/db/docker-entrypoint.sh", "python", "manage.py", "runserver", "0.0.0.0:8000"]

