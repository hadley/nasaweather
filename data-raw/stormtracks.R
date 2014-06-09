library(dplyr)
library(lubridate)

stormtracks <- read.csv("data-raw/stormtracks.csv", stringsAsFactors = FALSE)
names(stormtracks) <- tolower(names(stormtracks))

save(stormtracks, file = "data/stormtracks.rdata")
