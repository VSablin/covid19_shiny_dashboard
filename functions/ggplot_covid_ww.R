ggplot_covid_ww <- function(df,y_label,var_y,str_country,scale = "log"){
  if (str_country == "WW") {
    df_filtered <- df
  } else {
    df_filtered <- dplyr::filter(df,country == str_country)
  }
  p <- ggplot(df_filtered,aes(x = year_week, y = {{var_y}})) +
    geom_line() +
    # xlim(min(df_filtered$year_week),max(df_filtered$year_week)) +
    labs(y = y_label, x = "Date") +
    theme_bw()
  if (scale == "log") {
    bs <- c(1, 10, 100, 1000, 10000, 100000, 1000000, 10000000)
    p <- ggplot(df_filtered,aes(x = year_week, y = 1 + {{var_y}})) +
      geom_line() +
      labs(y = y_label, x = "Date") +
      theme_bw() +
      scale_y_continuous(trans = "log", breaks = bs, labels = bs)
  }
  return(p)
}