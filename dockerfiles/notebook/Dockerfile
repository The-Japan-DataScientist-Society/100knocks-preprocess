FROM jupyter/datascience-notebook:python-3.9.6
#FROM jupyter/datascience-notebook:d53a302fbcd0
USER root
ENV DEBCONF_NOWARNINGS yes

# postgresql 13.x対応を行っている (参考: https://www.postgresql.org/download/linux/ubuntu/ )
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update \
    && apt-get install -y --no-install-recommends lsb-release=11.1.0ubuntu2 gnupg=2.2.19-3ubuntu2.1 \
    && sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update \
    && apt-get install -y --no-install-recommends libpq-dev=14.0-1.pgdg20.04+1 \
    && apt-get remove -y lsb-release gnupg \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

USER jovyan
WORKDIR /home/jovyan
COPY Pipfile .
COPY Pipfile.lock .

RUN pip install --no-cache-dir pipenv==2021.5.29 \
    && pipenv install --system \
    && rm Pipfile* \
    && Rscript -e "install.packages(c('DBI', 'RPostgreSQL', 'themis', 'formatR'), dependencies = TRUE, error = TRUE, repos='https://cran.microsoft.com/snapshot/2021-10-05/')"
