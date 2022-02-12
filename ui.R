#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

data0w <- read.csv("https://opendata.ecdc.europa.eu/covid19/nationalcasedeath/csv",
                   na.strings = "",
                   fileEncoding = "UTF-8-BOM",
                   stringsAsFactors = FALSE)
str_country <- sort(unique(data0w$country))

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Worldwide-covid19 dashboard"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            # selectInput("country",
            #             "Country:",
            #             choices = sort(c("Spain", "France", "United_States_of_America", "Germany", "United_Kingdom",
            #                         "Italy", "India", "Brazil", "Mexico", "Netherlands", "Sweden", "Russia")),
            #             selected = "Spain"
            #             ),
            # selectInput("wwvar",
            #             "International:",
            #             choices = c("rate", "cases", "deaths"),
            #             selected = "rate"
            # )
            h3("Dashboard with information about covid19."),
            h3("We download the data from https://opendata.ecdc.europa.eu/covid19/nationalcasedeath/"),
            h3("The code is hosted in https://github.com/VSablin/covid19_shiny_dashboard."),
            h3("The production version is in master.")
        ),

        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("Worldwide time series",
                                 h3("Worldwide time series of cases and deaths"),
                                 plotOutput("covidWWPlot"),
                                 h4("Choose here the scale you want (logarithmic or linear):"),
                                 selectInput("scaleww",
                                             "Scale:",
                                             choices = c("linear", "log"),
                                             selected = "linear"),
                                 h5("Note 1: The time scale of the plot is weekly."),
                                 h5("Note 2: In log scale, we represent the number of cases/deaths + 1.")),
                        tabPanel("Country time series",
                                 h3("Time series of cases and deaths for a country"),
                                 plotOutput("covidPlot"),
                                 h4("Choose here one country:"),
                                 selectInput("country",
                                             "Country:",
                                             choices = str_country),
                                             # choices = sort(c("Spain", "France", "United_States_of_America",
                                             #                  "Germany", "United_Kingdom","Belgium",
                                             #                  "Italy", "India", "Brazil", "Mexico", "Netherlands",
                                             #                  "Sweden", "Russia", "Argentina", "Chile", "Ecuador",
                                             #                  "Peru", "Colombia", "Cuba", "Venezuela", "South_Africa",
                                             #                  "Iran", "Turkey", "Pakistan", "Japan", "South_Korea",
                                             #                  "Australia", "New_Zealand", "Portugal", "Canada", "Egypt",
                                             #                  "China", "Indonesia", "Iraq", "Pakistan"))),
                                 h4("Choose here the scale you want (logarithmic or linear):"),
                                 selectInput("scalec",
                                             "Scale:",
                                             choices = c("linear", "log"),
                                             selected = "linear"),
                                 h5("Note 1: The time scale of the plot is weekly."),
                                 h5("Note 2: In log scale, we represent the number of cases/deaths + 1.")),
                        tabPanel("Worldwide rankings",
                                 h3("Worldwide ranking"),
                                 plotOutput("wwPlot"),
                                 h4("Choose here the variable you would like to plot (
                                    rate of mortality, cases, or deaths):"),
                                 selectInput("wwvar",
                                             "International:",
                                             choices = c("rate of mortality", "cases", "deaths"),
                                             selected = "rate of mortality"
                                 )
                        )
            )
        )
    )
))
