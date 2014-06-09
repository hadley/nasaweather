library(dplyr)

if (!file.exists("data-raw/nasa")) {
  tmp <- tempfile(fileext = ".zip")
  download.file("http://stat-computing.org/dataexpo/2006/nasadata.zip", tmp)

  unzip(tmp, exdir = "data-raw/nasa", junkpaths = TRUE)
}


long <- seq(-113.8, -56.2, length = 24)
lat  <- seq(36.2, -21.2, length = 24)
year <- 1995:2000
month <- 1:12


# Elevation -------------------------

elev_raw <- read.table("data-raw/nasa/intlvtn.dat", header = T, na = "....")
elev_num <- as.matrix(elev_raw)

elev_cube <- tbl_cube(list(long = long, lat = lat), list(elev = elev_num))

elev <- as.data.frame(elev_cube)
save(elev, file = "data/elev.rdata")

# Other variables ---------------------

path <- dir("data-raw/nasa", full.names = TRUE)
path <- path[!grepl("\\.dat", path)]

# Load each file as matrix
raw <- lapply(path, read.table, skip = 7, na = "....")
num <- lapply(raw, function(x) as.numeric(as.matrix(x[, -(1:3), drop = FALSE])))

# Extract variables from file names
vars <- gsub("^(.*?)[0-9]+\\.txt$", "\\1", basename(path))
time <- as.numeric(gsub("^.*?([0-9]+)\\.txt$", "\\1", basename(path)))

# Order by vars and time
ord <- order(vars, time)
num <- num[ord]

# Create dimensions and metrics data structures

# In order from fastest to slowest varying
dimensions <- list(lat = lat, long = long, month = month, year = year)
n <- vapply(dimensions, length, integer(1))

metrics <- lapply(split(num, vars), function(x) array(unlist(x), dim = n))

atmos_cube <- tbl_cube(dimensions, metrics)
atmos <- as.data.frame(atmos_cube) %>%
  select(lat, long, year, month, surftemp, temp = temperature,
    pressure, ozone, cloudlow, cloudmid, cloudhigh)
save(atmos, file = "data/atmos.rdata")
