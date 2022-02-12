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
library(tsibble)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    str_funcs <- list.files("functions")
    for (str_fun in str_funcs) {
      source(paste0("functions/", str_fun))
    }

    data0w <- read.csv("https://opendata.ecdc.europa.eu/covid19/nationalcasedeath/csv",
    na.strings = "",
    fileEncoding = "UTF-8-BOM",
    stringsAsFactors = FALSE)

    if (!all(get_names() %in% names(data0w))) {
      stop("The names of the data frame are ", names(data0w), "whereas they were supposed to be", get_names(), "Stop.")
    }
    
    dataw <- data0w %>%
      select(year_week,
             indicator,
             weekly_count,
             cumulative_count,
             country) %>%
      mutate(year_week = yearweek(gsub(pattern = "-",
                                       replacement = " W",
                                       x = year_week)))
    
    output$covidPlot <- renderPlot({
        # generate plots_country
        if (input$scalec == "log") {
          scale <- "log"
        } else if (input$scalec == "linear") {
          scale <- "identity"
        }
        plots_country(dataw, input$country, scale = scale)
    })
    
    data_int <- dataw %>%
      select(year_week,
             indicator,
             weekly_count,
             country) %>%
      filter(indicator == "cases") %>%
      select(-indicator) %>%
      rename(cases = weekly_count)

    data_int$deaths <-
      filter(dataw, indicator == "deaths")$weekly_count
    
    data_int <- group_by(data_int, country) %>%
      summarise(cases = sum(cases, na.rm = TRUE),
                deaths = sum(deaths, na.rm = TRUE))
    
    data_int <- data_int %>%
      filter(!(country %in% c("Africa (total)",
                              "America (total)",
                              "Europe (total)",
                              "EU/EEA (total)",
                              "Asia (total)")))
    
    data_int <- mutate(data_int, rate = deaths/cases)
    
    data_int <- filter(data_int, deaths >  mean(data_int$deaths))
    
    data_int <- data_int[order(data_int$cases),]
    
    pc_int <- ggplot(data = data_int,
                     aes(x = factor(country,
                                 levels = country),
                         y = cases)) +
      geom_bar(stat = "identity") +
      theme(axis.text.x = element_text(angle = 90,
                                       hjust = 1,
                                       vjust = 0.5),
            panel.background = element_rect(fill = "white", colour = "grey50")) +
      xlab("Country") +
      ylab("Cases")
    
    data_int <- data_int[order(data_int$deaths),]
    
    pd_int <- ggplot(data=data_int, aes(x = factor(country,levels = country),
                                        y = deaths)) +
        geom_bar(stat = "identity") +
      theme(axis.text.x = element_text(angle = 90,
                                       hjust = 1,
                                       vjust = 0.5),
            panel.background = element_rect(fill = "white", colour = "grey50")) +
      xlab("Country") +
      ylab("Deaths")
    
    data_int <- data_int[order(data_int$rate),]
    
    prate_int <- ggplot(data = data_int, aes(x = factor(country,
                                                        levels = country),
                                             y = rate)) +
      geom_bar(stat = "identity") +
      theme(axis.text.x = element_text(angle = 90,
                                       hjust = 1,
                                       vjust = 0.5),
            panel.background = element_rect(fill = "white", colour = "grey50")) +
      xlab("Country") +
      ylab("Rate (Deaths/Cases)")

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
    
    dataall <- dplyr::group_by(dataw, year_week, indicator) %>%
      summarise(weekly_count = sum(weekly_count, na.rm = TRUE))

    output$covidWWPlot <- renderPlot({
        if (input$scaleww == "log") {
          scale <- "log"
        } else if (input$scaleww == "linear") {
          scale <- "identity"
        }
        plots_country(dataall, "WW", scale = scale)
    })
    
    
    

})
