FROM python:3.9-slim
LABEL maintainer="londonappdeveloper.com"

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apt-get update && \
    apt-get install -y --no-install-recommends postgresql-client libjpeg-dev && \
    apt-get install -y --no-install-recommends build-essential postgresql-server-dev-all musl-dev zlib1g-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; then \
      /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /var/lib/apt/lists/* /tmp && \
    adduser \
      --disabled-password \
      --no-create-home \
      django-user && \
    mkdir -p /val/web/media && \
    mkdir -p /val/web/static && \
    chown -R django-user:django-user /val && \
    chmod -R 755 /val \

ENV PATH="/py/bin:$PATH"

USER django-user
