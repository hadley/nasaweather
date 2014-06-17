library(dplyr)
library(lubridate)

storms <- read.csv("data-raw/stormtracks.csv", stringsAsFactors = FALSE)
names(storms) <- tolower(names(storms))

breaks <- c(0, 33, 63, 82, 95, 112, 136, 155)
cats <- c(-1, 0, 1, 2, 3, 4, 5)

storms <- storms %>%
  select(name:hour, lat = latitude, long = longitude, pressure:seasday) %>%
  mutate(category = as.numeric(as.character(cut(wind, breaks = breaks,
    labels = cats, include.lowest = TRUE)))) %>%
  tbl_df()

save(storms, file = "data/storms.rdata")
