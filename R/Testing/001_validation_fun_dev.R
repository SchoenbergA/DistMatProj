### function to get test data

# set environment paths
wd <- "C:/Envimaster/DistMatProj_local" # local path to repository
dat <- file.path(wd,"Data")


# load package

# load data
mat <- read.csv(file.path(wd,"Distanzmatrix_medium_AOI.csv"),row.names = 1) # braucht ewig

### develop function

valiTable = function(lon_lat, dist, gid_from, gid_to){
  
  lat_from = lon_lat[gid_from,2]
  lon_from = lon_lat[gid_from,1]
  lat_to   = lon_lat[gid_to,  2]
  lon_to   = lon_lat[gid_to,  1]
  
  coord_from = paste(lat_from, lon_from)
  coord_to   = paste(lat_to,   lon_to)
  
  dist_from_to = dist[cbind(gid_from, gid_to)]
  dist_reverse = dist[cbind(gid_to, gid_from)] 
  
  return(cbind(gid_from, gid_to, coord_from, coord_to, dist_from_to, dist_reverse))
}

# get small test mat
tmat <-mat[1:10,1:10]

# access dist
tmat["31024",paste0("X","108890")] # colnames have an "X"

