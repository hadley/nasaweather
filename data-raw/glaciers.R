library(dplyr)
library(stringr)

glaciers <- read.delim("data-raw/glaciers.txt", stringsAsFactors = FALSE)

glaciers <- glaciers %>%
  select(id = glacier_num, name = glacier_name, lat, long = lon, area = total_area,
    country) %>%
  mutate(name = str_replace_all(str_trim(name), "\\s+", " "))

save(glaciers, file = "data/glaciers.rdata")
