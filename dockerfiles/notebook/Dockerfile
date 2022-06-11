FROM jupyter/datascience-notebook:python-3.9.6
#FROM jupyter/datascience-notebook:d53a302fbcd0
USER root

# mambaでR依存パッケージをインストール
RUN mamba install --quiet --yes r-themis==0.1.4 r-rpostgresql==0.6_2 \
    && rm -rf /tmp /var/tmp

USER jovyan
WORKDIR /home/jovyan
COPY Pipfile .
COPY Pipfile.lock .

RUN pip install --no-cache-dir pipenv==2021.5.29 \
    && pipenv install --system \
    && rm Pipfile*
