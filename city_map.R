####---- LOAD LIBRARIES ----####

library(osmplotr)
library(tidyverse)
library(osmdata)
library(sf)
library(ggmap)
library(lubridate)

####---- GLOBAL VARIABLES ----####

city <- "AARHUS"

####--- GET CITY AND DATA ----####

# A bounding box of selected city

bbox <- osmdata::getbb(city)


# get list containing coordinates

coor <- osmdata::getbb(city) %>%
  opq()

# convert coordinates list to df, add city an year column and export to .csv  
df_coor <- 
  data.frame(t(sapply(coor,c))) %>%
  subset(
    select = c(
      "bbox"
    )
  ) %>%
  separate('bbox', paste("coor", 1:4, sep="_"), sep=",", extra="drop") %>%
  rename(
    `y_min` = `coor_1`,
    `x_min` = `coor_2`,
    `y_max` = `coor_3`,
    `x_max` = `coor_4`
  ) %>%
  mutate(
    `y_min` = round(as.numeric(`y_min`), 4),
    `x_min` = round(as.numeric(`x_min`), 4),
    `y_max` = round(as.numeric(`y_max`), 4),
    `x_max` = round(as.numeric(`x_max`), 4),
  ) %>%
  mutate(
    `y_avg` = round((y_min + y_max) / 2, 4),
    `x_avg` = round((x_min + x_max) / 2, 4),
    `city` = city,
    `year` = year(Sys.Date())
  )
  
write_csv(df_coor, 'Data/Processed/city_data.csv')

####--- CREATE PLOT OBJECTS AND PLOT ----####

# get highways by type

#dat_highway_prim <- extract_osm_objects(key = "highway", value = "primary", bbox = bbox)
#Sys.sleep(10)
#dat_highway_sec <- extract_osm_objects(key = "highway", value = "secondary", bbox = bbox)
#Sys.sleep(10)
#dat_highway_tert <- extract_osm_objects(key = "highway", value = "tertiary", bbox = bbox)
#Sys.sleep(10)
#dat_highway_res <- extract_osm_objects(key = "highway", value = "residential", bbox = bbox)

# get all highways

dat_highway <- extract_osm_objects(key = "highway", bbox = bbox)

# now create the map

map <- osm_basemap(bbox = bbox, bg = NA)

# in case of using individual layers with different styling
#map <- add_osm_objects(map, dat_highway_res, col = "#084596", size = 0.2)
#map <- add_osm_objects(map, dat_highway_tert, col = "#084596", size = 0.2)
#map <- add_osm_objects(map, dat_highway_sec, col = "#084596", size = 0.2)
#map <- add_osm_objects(map, dat_highway_prim, col = "#084596", size = 0.4)
#map <- add_axes(map, colour = "black", pos = c(0, 0.03), alpha = 0.4, fontsize = 3)

map <- add_osm_objects(map, dat_highway, col = "#084596", size = 0.2)

map

# save as png with transparent background

png('/Outputs/Aarhus.png', width=2000 , height=2400, units="px", bg = "transparent")
print(map)
dev.off()