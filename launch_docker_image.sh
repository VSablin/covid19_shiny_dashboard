#!/bin/bash

sudo docker run --rm -p 3838:3838 covid_dashboard:latest &

sleep 5

xdg-open http://127.0.0.1:3838
