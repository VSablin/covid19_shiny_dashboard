# covid19_shiny_dashboard

Code to deploy my R Shiny application.

## Reproduce the code somewhere else

1. Clone the repository.
2. Install R (this has been tested with versions 3.6.2, 3.6.3, and 4.1.2).
3. Launch a fresh R session into the repository root directory.
4. Run `renv::restore()` (we guarantee this to work for R 4.1.2; otherwise, probably you will have to remove the file renv.lock and run `install.packages(renv)` and `renv::init()`).

Now you should be able to run the app. To make sure that everything is ok, run:

```
shiny::runApp(host = '0.0.0.0', port = 3838)
```

Then, open your favorite browser and go to `localhot:3838`. If everything is ok, you should see the Covid dashboard.

## Deployment

The application is hosted in https://eduardosb89.shinyapps.io/covid_dashboard.
To deploy it, there are several options enlisted in the following:

### Manual deployment from RStudio

Open the .Rproj file with RStudio. Then, click on publish to server (blue icon in the upper-right corner of the script window of RStudio). You must choose shinyapps and log in with my personal user (Eduardo Sánchez Burillo). The rest is straightforward.

### Deployment from script

Create a file called `.Renviron` in the root directory of the repository. It must have the following structure:
```
SHINY_ACC_NAME=
TOKEN=
SECRET=
APP_NAME=
```
with the proper values for all the variables.

Then, run the script `deploy.R`, localised in the root directory of the repository too.

### Deployment from Docker

This is pretty much equivalent to the previous point, since it is the same, but run in a Docker image. Make sure you have created the `.Renviron` file with the proper structure (see Deployment from script). Then, create the Docker image corresponding to `deploy.Dockerfile`:

```
docker build -t deploy_covid_dashboard -f deploy.Dockerfile .
```

Assuming everything was ok, run the image:

```
docker run --env-file .Renviron deploy_covid_dashboard
```

### Deployment with CI/CD

The deployment is automatised as a workflow of GitHub. It is encoded in .github/workflows/deploy_app.yml: A configuration file to update the app.
* It acts just if the code is pushed to master.
* It runs on Ubuntu 20.04.
* It builds the docker image corresponding to deploy.Dockerfile (see Deployment from Docker).
* It executes the Docker image, reading the environment variables (see Deployment from script) encoded as GitHub secrets.

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
