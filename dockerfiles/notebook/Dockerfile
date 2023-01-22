FROM jupyter/datascience-notebook:python-3.10.8
#FROM jupyter/datascience-notebook:d53a302fbcd0
USER root
ENV DEBCONF_NOWARNINGS yes

# 最新のpostgresqlへの対応を行っている (参考: https://www.postgresql.org/download/linux/ubuntu/ )
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update \
    && apt-get install -y --no-install-recommends lsb-release gnupg \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgres-archive-keyring.gpg \
    && sh -c 'echo "deb [signed-by=/usr/share/keyrings/postgres-archive-keyring.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
    && apt-get update \
    && apt-get install -y --no-install-recommends libpq-dev libmariadb-dev \
    && apt-get remove -y lsb-release gnupg \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /opt/julia-*/share/julia/stdlib/v*/SuiteSparse/.devcontainer/Dockerfile \
    && find / -type f -perm /u+s -ignore_readdir_race -exec chmod u-s {} \; \
    && find / -type f -perm /g+s -ignore_readdir_race -exec chmod g-s {} \;

USER jovyan
WORKDIR /home/jovyan
COPY Pipfile .
COPY Pipfile.lock .

# hadolint ignore=SC2016
RUN pip install --no-cache-dir pipenv==2021.5.29 \
    && pipenv install --system \
    && Rscript -e 'install.packages("pak", repos = sprintf("https://r-lib.github.io/p/pak/stable/%s/%s/%s", .Platform$pkgType, R.Version()$os, R.Version()$arch))' \
    && Rscript -e 'pak::repo_add(CRAN = "RSPM@2022-12-16"); pak::pak(c("DBI", "RPostgreSQL", "themis"))' \
    && rm -rf Pipfile* /tmp/* /var/tmp/*

HEALTHCHECK --interval=5s --retries=20 CMD ["curl", "-s", "-S", "-o", "/dev/null", "http://localhost:8888"]
