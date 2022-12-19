library(osrm)
library(tidyverse)

path = dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(path)


# lon_lat:  Table the rownames are GIDS, the first two columns contain the 
# --------- corresponding longitude and latitude, respectively. 
# dist:     A distancematrix for the locations from lon_lat (at least for the ones in gid_from, gid_to)
# --------- where row- and columnnames are gids and entries the corresponding distances/durations.
# gid_from: A vector of gids. (each of which must be contained in lon_lat)
# gid_to:   As gid_from.
#
# Returns a Table
# GID_FROM | GID_TO | FROM_COORDINATES | TO_COORDINATES | DURATION FROM->TO | DURATION TO->FROM 

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



# Test: 
options(osrm.server = "http://127.0.0.1:5000/")

locations = read.csv('Tests_GID_LON_LAT/GID_LON_LAT_CLIPPED.csv')
locations = head(locations, 8)

rownames(locations) = locations[,1]
locations[,1] = NULL

dists = osrmTable(loc = locations)
dists = dists$durations

f = rownames(head(locations))
t = rownames(tail(locations))

valiTable(locations, dists, f, t)

