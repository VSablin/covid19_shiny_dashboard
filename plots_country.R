plots_country <- function(dataw = dataw, country = "Spain", scale = "log"){

  if (country != "WW") {
    if (!(country %in% dataw$countriesAndTerritories)) {
      stop("Your input is not a country/WW")
    }
  }
  
  pc <- ggplot_covid_ww(dataw,"Cases", cases, country, scale)
  
  pd <- ggplot_covid_ww(dataw,"Deaths", deaths, country, scale)
  p_arrange <- ggarrange(pc,pd,
                         ncol = 2,nrow = 1)
  
  title <- ifelse(country == "WW", "World", country)
  p_out <- annotate_figure(p_arrange,
                  top = text_grob(title,
                                  color = "black",
                                  face = "bold",
                                  size = 14))
  return(p_out)
}