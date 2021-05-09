# Base image https://hub.docker.com/u/rocker/
FROM rocker/r-base:3.6.3

# system libraries of general use
## install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install libcurl4-openssl-dev

# create /home and move there
WORKDIR /home/

# copy necessary files
## renv.lock file
COPY renv.lock .

# install renv & restore packages
RUN Rscript -e 'install.packages("renv")'
RUN Rscript -e 'renv::restore()'

## app folder
COPY get_names.R .
COPY ggplot_covid_ww.R .
COPY plots_country.R .
COPY server.R .
COPY ui.R .

# expose port
EXPOSE 3838

# run app on container start
CMD ["R", "-e", "shiny::runApp(host = '0.0.0.0', port = 3838)"]
