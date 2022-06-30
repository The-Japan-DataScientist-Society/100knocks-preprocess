FROM postgres:14.2-bullseye

RUN sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen \
    && locale-gen
ENV LANG ja_JP.utf8

HEALTHCHECK --interval=5s --retries=20 CMD ["pg_isready"]
