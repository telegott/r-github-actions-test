FROM r-base:4.0.5

ARG USERNAME=apprunner

ENV USER_HOME=/home/$USERNAME \
    RENV_VERSION=0.13.2

RUN set -xe \
    && apt-get update \
    && apt-get install -yqq --no-install-recommends libcurl4-openssl-dev libssl-dev libxml2-dev \
    && R -e "install.packages('renv')" \
    && rm -rf /var/lib/apt/lists/*

WORKDIR $USER_HOME
USER $USER_NAME
COPY --chown=$USER_NAME renv.lock renv.lock

RUN R -e 'renv::restore()'
RUN R -e 'renv::install("lintr")'
COPY . .

