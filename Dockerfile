
# Top level build args
ARG build_for=linux/amd64

##
# base image (abstract)
##
FROM --platform=$build_for python:3.8-slim-bullseye as base

ARG dbt_core_ref=dbt-core@v1.3.0a1
ARG dbt_postgres_ref=dbt-core@v1.3.0a1
ARG dbt_redshift_ref=dbt-redshift@v1.0.0
ARG dbt_bigquery_ref=dbt-bigquery@v1.0.0
ARG dbt_snowflake_ref=dbt-snowflake@v1.0.0
ARG dbt_spark_ref=dbt-spark@v1.0.0
# special case args
ARG dbt_spark_version=all
ARG dbt_third_party

# System setup
RUN apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y --no-install-recommends \
    git \
    ssh-client \
    software-properties-common \
    make \
    build-essential \
    ca-certificates \
    libpq-dev \
  && apt-get clean \
  && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

# Env vars
ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8

# Update python
RUN python -m pip install --upgrade pip setuptools wheel --no-cache-dir

# Set docker basics
WORKDIR /usr/app/dbt/
VOLUME /usr/app
# ENTRYPOINT ["dbt"]

##
# dbt-bigquery
##
FROM base as dbt-bigquery
RUN python -m pip install --no-cache-dir "git+https://github.com/dbt-labs/${dbt_bigquery_ref}#egg=dbt-bigquery"

##
# Now add this app
##

WORKDIR /usr/app
COPY . .
COPY profiles/profiles.yml /root/.dbt/
CMD [ "dbt", "run" ]