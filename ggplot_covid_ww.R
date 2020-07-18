ggplot_covid_ww <- function(df,y_label,var_y,country,scale = "log"){
  if (country == "WW") {
    df_filtered <- df
  } else {
    df_filtered <- filter(df,countriesAndTerritories == country)
  }
  # if (scale == "log") {
  bs <- c(1, 10, 100, 1000, 10000, 100000, 1000000, 10000000)
  # } else if (scale == "identity") {
  #  bs <- seq(0, 100000, 500)
  # }
  p <- ggplot(df_filtered,aes(x = dateRep, y = 1+{{var_y}})) +
    geom_line() +
    scale_y_continuous(trans = scale, breaks = bs, labels = bs) +
    xlim(min(df_filtered$dateRep),max(df_filtered$dateRep)) +
    labs(y = y_label, x = "Date")
    return(p)
}