# covid19_shiny_dashboard

Code to deploy my R Shiny application.

## Deployment

The application is hosted in https://eduardosb89.shinyapps.io/covid_dashboard.
To deploy it, you must open RStudio and log in as my personal user. Then, syncrhonise RStudio with shinyapps and deploy.

## Data input

We read the data from https://opendata.ecdc.europa.eu/covid19/

## License

To see the information regarding the license of the repository, go to LICENSE.

## Containerisation

Even if the application is deployed with shinyapps, a Dockerfile is included to containerise the dashboard. Assuming you have docker in your machine, you must first run:

```
sudo docker build -t covid_dashboard .
```

and then run the shell script of the repository:

```
sudo .\launch_docker_image.sh
```
If the script is not executable, run first:
```
chmod +x launch_docker_image.sh
```
