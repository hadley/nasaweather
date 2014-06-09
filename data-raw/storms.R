library(dplyr)
library(lubridate)

storms <- read.csv("data-raw/stormtracks.csv", stringsAsFactors = FALSE)
names(storms) <- tolower(names(storms))

storms <- select(storms, name:hour, lat = latitude, long = longitude, pressure:seasday)

save(storms, file = "data/storms.rdata")
