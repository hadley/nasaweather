library(rgdal)
library(raster)
library(ggplot2)
library(dplyr)

if (!file.exists("data-raw/natural-earth")) {
  tmp <- tempfile(fileext = ".zip")
  download.file("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip", tmp)
  unzip(tmp, exdir = "data-raw/natural-earth")
}
clip_region <- function(x) {
  bbox <- extent(x = c(-113.8, -56.2), y = c(-21.2, 36.2))
  crop(x, bbox)
}

# Country borders --------------------------------------------------------------

borders <- readOGR("data-raw/natural-earth/", "ne_50m_admin_0_countries")
plot(borders)
cropped <- clip_region(borders)
plot(cropped)

borders <- fortify(cropped, region = "iso_a2") %>%
  select(country = id, long, lat, group) %>%
  mutate(group = as.integer(group))
save("borders", file = "data/borders.rdata")
