library(dplyr)
library(lubridate)

storms <- read.csv("data-raw/stormtracks.csv", stringsAsFactors = FALSE)
names(storms) <- tolower(names(storms))

storms <- storms %>%
  select(storms, name:hour, lat = latitude, long = longitude, pressure:seasday) %>%
  tbl_df()

save(storms, file = "data/storms.rdata")
