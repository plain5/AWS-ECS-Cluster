#Arguments
ARG BUILDER_VERSION=python:3.10.9-alpine3.17

#Image pulling
FROM ${BUILDER_VERSION} as builder

#Creating envs
ENV APP_DIR=/app

#Application directory
WORKDIR $APP_DIR

#Copy application requirements
ADD sample-django/requirements.txt $APP_DIR

#Installing application requirements
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt && rm requirements.txt

#Copy source directory
ADD sample-django $APP_DIR

#Open port
EXPOSE 8000

#Run container
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "mysite.wsgi:application"]
