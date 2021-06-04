# covid19_shiny_dashboard

Code to deploy my R Shiny application.

## Reproduce the code somewhere else

1. Clone the repository.
2. Install R (this has been tested with versions 3.6.2, 3.6.3, and 4.1.0).
3. Launch a fresh R session into the repository root directory.
4. Run `renv::restore()`.

Now you should be able to run the app. To make sure that everything is ok, run:

```
shiny::runApp(host = '0.0.0.0', port = 3838)
```

Then, open your favorite browser and go to `localhot:3838`. If everything is ok, you should see the Covid dashboard.

## Deployment

The application is hosted in https://eduardosb89.shinyapps.io/covid_dashboard.
To deploy it, you must open RStudio and log in as my personal user. Then, syncrhonise RStudio with shinyapps and deploy.

WIP...

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
