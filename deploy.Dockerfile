# Base image https://hub.docker.com/u/rocker/
FROM rocker/r-base:4.1.0

# install some dependencies
RUN apt-get update -qq && apt-get -y --no-install-recommends install libcurl4-openssl-dev libssl-dev

# create shinyusr directory and move there
WORKDIR /home/shinyusr

# install renv & restore packages
RUN Rscript -e 'install.packages("renv")'
COPY renv.lock .
RUN Rscript -e 'renv::restore()'

# copy Shiny scripts
COPY server.R server.R
COPY ui.R ui.R

# create functions dir
RUN mkdir functions/

# copy functions
COPY functions/* functions/

# copy script to deploy app
COPY deploy.R deploy.R

# run deploy.R
CMD ["Rscript", "deploy.R"]
