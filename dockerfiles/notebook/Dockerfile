FROM quay.io/jupyter/datascience-notebook:python-3.11.9
#FROM jupyter/datascience-notebook:d53a302fbcd0
USER root
ENV DEBCONF_NOWARNINGS yes

# 最新のpostgresqlへの対応を行っている (参考: https://www.postgresql.org/download/linux/ubuntu/ )
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update \
    && apt-get install -y --no-install-recommends lsb-release gnupg \
    && wget --no-check-certificate --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgres-archive-keyring.gpg \
    && sh -c 'echo "deb [signed-by=/usr/share/keyrings/postgres-archive-keyring.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
    && apt-get update \
    && apt-get install -y --no-install-recommends libpq-dev libmariadb-dev \
    && apt-get remove -y lsb-release gnupg \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /opt/julia-*/share/julia/stdlib/v*/SuiteSparse/.devcontainer/Dockerfile /opt/julia/packages/Pluto/*/.vscode/ \
    && find / -type f -perm /u+s -ignore_readdir_race -exec chmod u-s {} \; \
    && find / -type f -perm /g+s -ignore_readdir_race -exec chmod g-s {} \;

USER jovyan
WORKDIR /home/jovyan
COPY requirements.txt .
COPY Pipfile .
COPY Pipfile.lock .
COPY install.R .

RUN pip install --no-cache-dir -r requirements.txt \
    && pipenv install --system \
    && Rscript install.R \
    && rm -rf requirements.txt Pipfile* install.R .cache/R/pkgcache/sysreqs/docker/*/Dockerfile /tmp/* /var/tmp/* .npm/

HEALTHCHECK --interval=5s --retries=20 CMD ["curl", "-s", "-S", "-o", "/dev/null", "http://localhost:8888"]
