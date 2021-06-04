plots_country <- function(dataw, str_country = "Spain", scale = "log"){

  if (str_country != "WW") {
    if (!(str_country %in% dataw$country)) {
      stop("Your input is not a country/WW")
    }
  }

  dataw_cases <- filter(dataw,
                        indicator == "cases")
  dataw_deaths <- filter(dataw,
                         indicator == "deaths")
    
  pc <- ggplot_covid_ww(dataw_cases, "Cases", weekly_count, str_country, scale)
  
  pd <- ggplot_covid_ww(dataw_deaths, "Deaths", weekly_count, str_country, scale)
  p_arrange <- ggarrange(pc,pd,
                         ncol = 2,nrow = 1)
  
  title <- ifelse(str_country == "WW", "World", str_country)
  p_out <- annotate_figure(p_arrange,
                  top = text_grob(title,
                                  color = "black",
                                  face = "bold",
                                  size = 14))
  return(p_out)
}