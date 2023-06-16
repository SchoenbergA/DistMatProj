### Clip DR Places and get coordinates

## set environment
wd <- "C:/Envimaster/DistMatProj"
dat<- file.path(wd,"DR")

# load packages
require(rgdal)
require(raster)
require(mapview)

# load data
wen <- readOGR(file.path(dat,"Wenker_places_wgs.shp"))
mask <- readOGR(file.path(dat,"DR_mask.shp"))

# clip
DR_clip <-crop(wen,mask)

mapview(DR_clip)

# add geometry to df
geo <- raster::geom(DR_clip)

# write UTM geometry
DR_clip$X <- geo[,2]
DR_clip$Y <- geo[,3]

df <- as.data.frame(DR_clip)

head(df)

write.csv(df,file.path(dat,"Wenker_places_wgs_DR.csv"))
