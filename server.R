#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)
library(dplyr)
library(ggplot2)
library(utils)
library(ggpubr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    source('ggplot_covid_ww.R')
    source('plots_country.R')
    
    data0w <- read.csv("https://opendata.ecdc.europa.eu/covid19/casedistribution/csv", na.strings = "", fileEncoding = "UTF-8-BOM")
    
    dataw <- select(data0w,dateRep,cases,deaths,countriesAndTerritories)
    dataw$dateRep <- as.Date(dataw$dateRep,"%d/%m/%Y")
    
    dataw <- group_by(dataw,dateRep,countriesAndTerritories)
    
    dataw <- summarise(dataw,cases = sum(cases,na.rm = T), deaths = sum(deaths,na.rm = T))
    
    output$covidPlot <- renderPlot({
        # generate plots_country
        if (input$scalec == "log") {
          scale <- "log"
        } else if (input$scalec == "linear") {
          scale <- "identity"
        }
        plots_country(dataw, input$country, scale = scale)
    })
    
    data_int <- group_by(dataw,countriesAndTerritories) %>%
        summarise(cases = sum(cases,na.rm = T), deaths = sum(deaths,na.rm = T))
    
    data_int <- mutate(data_int,rate = deaths/cases)
    
    data_int <- filter(data_int,deaths >  mean(data_int$deaths))
    
    data_int <- data_int[order(data_int$cases),]
    
    pc_int <- ggplot(data = data_int, aes(x=factor(countriesAndTerritories,levels = countriesAndTerritories), y = cases)) +
        geom_bar(stat = "identity") +
        theme(axis.text.x = element_text(angle = 90,hjust = 1,vjust = 0.5)) + 
        xlab("Country")
    
    data_int <- data_int[order(data_int$deaths),]
    
    pd_int <- ggplot(data=data_int, aes(x=factor(countriesAndTerritories,levels = countriesAndTerritories), y = deaths)) +
        geom_bar(stat = "identity") +
        theme(axis.text.x = element_text(angle = 90,hjust = 1,vjust = 0.5)) + 
        xlab("Country")
    
    data_int <- data_int[order(data_int$rate),]
    
    prate_int <- ggplot(data = data_int, aes(x = factor(countriesAndTerritories,levels = countriesAndTerritories), y = rate)) +
        geom_bar(stat = "identity") +
        theme(axis.text.x = element_text(angle = 90,hjust = 1,vjust = 0.5)) + 
        xlab("Country")

    output$wwPlot <- renderPlot({

        # generate somw ww plot
        if (input$wwvar == "rate of mortality") {
            show(prate_int)
        } else if (input$wwvar == "cases") {
            show(pc_int)
        } else if (input$wwvar == "deaths") {
            show(pd_int)
        }
    })
    
    dataall <- group_by(dataw,dateRep) %>% summarise(cases = sum(cases,na.rm = T), deaths = sum(deaths,na.rm = T))

    output$covidWWPlot <- renderPlot({
        if (input$scaleww == "log") {
          scale <- "log"
        } else if (input$scaleww == "linear") {
          scale <- "identity"
        }
        plots_country(dataall, "WW", scale = scale)
    })
    
    
    

})
