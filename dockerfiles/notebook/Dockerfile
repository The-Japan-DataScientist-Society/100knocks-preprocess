FROM jupyter/datascience-notebook:python-3.9.6
#FROM jupyter/datascience-notebook:d53a302fbcd0
USER root
ENV DEBCONF_NOWARNINGS yes
RUN apt-get update \
    && apt-get install -y --no-install-recommends libpq-dev=12.8-0ubuntu0.20.04.1 \
    && rm -rf /var/lib/apt/lists/*
USER jovyan
WORKDIR /home/jovyan
COPY Pipfile .
COPY Pipfile.lock .
RUN pip install --no-cache-dir pipenv==2021.5.29 \
    && pipenv install --system \
    && rm Pipfile* \
    && Rscript -e "install.packages(c('DBI', 'RPostgreSQL', 'rsample'), dependencies = TRUE, error = TRUE, repos='https://cran.r-project.org')"
#RUN Rscript -e "install.packages(c('DBI', 'RPostgreSQL', 'recipes'), dependencies = TRUE, error = TRUE, repos='https://cran.r-project.org')"
