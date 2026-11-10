FROM quay.io/jupyter/datascience-notebook:python-3.13.18
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
    && rm -rf /var/lib/apt/lists/* \
              /opt/julia-*/share/julia/stdlib/v*/SuiteSparse/.devcontainer/Dockerfile \
              /opt/julia/packages/Pluto/*/.vscode/ \
              /opt/conda/etc/conda/test-files/conda-index/*/tests/index_data/legacy_cache/.cache \
              /opt/conda/etc/conda/test-files/conda-index/*/tests/index_data/corrupt/noarch/.cache \
    && find / -type f -perm /u+s -ignore_readdir_race -exec chmod u-s {} \; \
    && find / -type f -perm /g+s -ignore_readdir_race -exec chmod g-s {} \;

WORKDIR /home/jovyan
COPY pyproject.toml .

# uvのバージョンはpyproject.tomlのtool.uv.required-versionで管理している
RUN uv_version="$(sed -n -e 's/^required-version = "==\(.*\)"$/\1/p' pyproject.toml)" \
    && wget -qO- "https://astral.sh/uv/${uv_version}/install.sh" | env UV_UNMANAGED_INSTALL=/usr/local/bin sh

USER jovyan
COPY uv.lock .
COPY install.R .

RUN set -e \
    && ( \
      (uv export --frozen --no-emit-project -o requirements.txt && uv pip install --system --no-cache --require-hashes -r requirements.txt) & py_pid=$!; \
      Rscript install.R & r_pid=$!; \
      py_status=0; \
      r_status=0; \
      wait "$py_pid" || py_status=$?; \
      wait "$r_pid" || r_status=$?; \
      test "$py_status" -eq 0 && test "$r_status" -eq 0; \
    ) \
    && rm -rf requirements.txt pyproject.toml uv.lock install.R .cache/R/pkgcache/sysreqs/docker/*/Dockerfile /tmp/* /var/tmp/* .npm/

HEALTHCHECK --interval=5s --retries=20 CMD ["curl", "-s", "-S", "-o", "/dev/null", "http://localhost:8888"]
