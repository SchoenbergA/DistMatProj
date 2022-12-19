library(osrm)
library(tidyverse)
library(plotly)

# Set osrm-server to localhost
options(osrm.server = "http://127.0.0.1:5000/")

path = getwd()
setwd = path

# Takes two vectors "from", "to" of same length containing GIDS and returns a Table 
# GID_FROM | GID_TO | FROM_COORDINATES | TO_COORDINATES | DURATION FROM->TO | DURATION TO->FROM 
# For this, a table GID | LAT | LON that contains the given GIDS and corresponding coordinates must be 
# stored in global variable ’locations’ and a distancematrix containing the given GIDS and durations 
# must be stored in global variable ’distMatrix’ (row- and column-names are the gids, entries corresponding durations).
checkdm <- function(locations, distMatrix, from, to) {
  
    fromTo <- vector()
    reverse <- vector()
    fromCoordinates <- vector() 
    toCoordinates <- vector()
    gidFrom <- vector()
    gidTo <- vector()
    
    for( f in 1:length(from)) {
        fromTo[f] <- distMatrix[from[f], to[f]]
        reverse[f] <- distMatrix[to[f], from[f]]
        fromCoordinates[f] <- paste0(unique(locations[locations$GID == from[f], 2]),", ", unique(locations[locations$GID == from[f], 3]))
        toCoordinates[f] <- paste0(unique(locations[locations$GID == to[f], 2]), ", ", unique(locations[locations$GID == to[f], 3]))
        gidFrom[f] <- unique(locations[locations$GID == from[f], 1])
        gidTo[f] <- unique(locations[locations$GID == to[f], 1])
    }
    df <- cbind(gidFrom, gidTo, fromCoordinates, toCoordinates, fromTo, reverse)
    return(df)
}


# Im folgenden 2 Tests in verschiedenem Terrain (Flachland, Gelände) in GID_LON_LAT.csv 
# und ein "Langstreckentest" in GID_LON_LAT.csv´
# -------------------------------------------------------------------------------------------------------
# Read Test data 
locations = read.csv('Tests_GID_LON_LAT/GID_LON_LAT_CLIPPED.csv')

locations[,1] = NULL

head(locations)

test <- locations


# query table
dists = osrmTable(loc = locations)


?osrmTable

# dists$duration is distmatrix
distMatrix = dists$durations
# head(distMatrix)

# Write distmatrix for tests
# write.csv(distMatrix, '~/MyAllemanVar/Distanzmatrix/DistancMatrix_AOI/testData/distMatrix_dummy.csv')

# permute columns from GID|LON|LAT to GID|LAT|LON for checkmd
locations <- locations[,c(1,3,2)]


# Flachland-Tests in GID_LON_LAT
from <- c('24992','24992','24992','24992','24992','24992','24992','24992','24992') 
to <- c('535445', '34744','36457','24960','27452','24972','26102','29993','23689')
tmp = checkdm(from, to)
head(tmp)
#write.csv(tmp, "Flachland_tests.csv")


# Gelände-Tests in GID_LON_LAT
from1 <- c('131314', '131314', '131314', '131314', '131314', '131314', '131314', '131314', '131314') 
to1 <- c('128289','128482', '131713', '535436', '132085', '132039', '129256', '131765', '544454')
tmp = checkdm(from1, to1)
head(tmp)
#write.csv(tmp, "Gelände_tests.csv")


# Langstrecken-Test: Größte länge im ausschnitt GID_LON_LAT_CLIPPED 
from = c('23441',  '128677', '34804',  '31592',  '36045',  '34969',  '23689', '34976',  '128677', '132403')
to   = c('133738', '31846',  '129256', '127416', '132913', '132961', '24333', '128194', '133738', '31846')
tmp = checkdm(from, to)
#write.csv(tmp, "large_distance_tests_in_GID_LON_LAT_CLIPPED.csv")
# -------------------------------------------------------------------------------------------------------







# Im folgenden 2 Tests in Alpinem Gelände in Alpine_test_range.csv
# -------------------------------------------------------------------------------------------------------
# (1) Alpine-Tests in Alpine_test_range
AlpTest = read.csv('Tests_ALPINE_TEST_RANGE/Alpine_test_range.csv')
AlpTest = AlpTest[c('gid', 'Y', 'X')]
#head(AlpTest)

# rename columns for checkdm
AlpTest = AlpTest %>% 
  rename(
    GID = gid,
    LAT = Y,
    LON = X
  )

head(AlpTest)

# permute columns for OSRM
tmp = AlpTest[c('GID', 'LON', 'LAT')]
head(tmp)
# query table 
dists = osrmTable(loc = tmp)
distMatrix = dists$durations
# head(distMatrix)

from <- c('273', '273', '273', '273', '273', '273', '273', '273', '273') 
to <- c('9082', '18048', '15788', '15194', '18633', '20640', '20576', '14698', '18062')
locations = AlpTest
# permute columns from GID|LON|LAT to GID|LAT|LON for checkmd
locations <- locations[,c(1,3,2)]
tmp = checkdm(from, to)
# write.csv(tmp, "Alpine_tests.csv")



# (2) Alpine_test_range revisited random (Tests 2.0)
from = c('20576', '17288' , '10502', '2196',  '626688', '5335', '9381',  '6190',  '84307', '21012')
to   = c('84307', '546086', '19735', '14698', '87672',  '6830', '18062', '17288', '1434',  '10502')
locations = AlpTest
# permute columns from GID|LON|LAT to GID|LAT|LON for checkmd
locations <- locations[,c(1,3,2)]
tmp = checkdm(from, to)
# View(tmp)
# write.csv(tmp, "Alpine_tests_revisited.csv")
# -------------------------------------------------------------------------------------------------------


# Langstrecken-Test: Größte länge im ausschnitt GID_LON_LAT_CLIPPED 
from = c('23441',  '128677', '34804',  '31592',  '36045',  '34969',  '23689', '34976',  '128677', '132403')
to   = c('133738', '31846',  '129256', '127416', '132913', '132961', '24333', '128194', '133738', '31846')
tmp = checkdm(from, to)
#write.csv(tmp, "large_distance_tests_in_GID_LON_LAT_CLIPPED.csv")



# Visualisierung:
# Die folgenden Tabellen sind die oben erstellten, ergänzt um die entsprechende 
# dauer laut google (per hand eingetragen)
Flachland = read.csv("./validierung/Flachland_tests.csv")
#head(Flachland)
fig <- plot_ly(data = Flachland, x = ~fromTo, y = ~fromTo_google)
fig

Gelände = read.csv("./validierung/Gelände_tests.csv")
#head(Gelände)
fig <- plot_ly(data = Gelände, x = ~fromTo, y = ~fromTo_google)
fig

Alpine = read.csv("./validierung/Alpine_tests.csv")
#head(Alpine)
fig <- plot_ly(data = Alpine, x = ~fromTo, y = ~fromTo_google)
fig

AlpineRevisited = read.csv("./validierung/Alpine_tests_revisited.csv")
#head(AlpineRevisited)
fig <- plot_ly(data = AlpineRevisited, x = ~reverse, y = ~reverse_google)
fig


LargeDist = read.csv("./validierung/large_distance_tests_in_GID_LON_LAT_CLIPPED.csv")
head(LargeDist)
fig <- plot_ly(data = LargeDist, x = ~fromTo, y = ~fromTo_google)
fig


plot(LargeDist$fromTo_google ~ LargeDist$fromTo)
abline(lm(LargeDist$fromTo_google ~ LargeDist$fromTo))


# Add Spalte mit typ/bezeichner des Tests
Flachland$type = "Flachland"
Gelände$type = "Gelände"
Alpine$type = "Alpine"

# alle Testdaten zusammengefügt
tests = rbind(Flachland,Gelände,Alpine)
#write.csv(tests, "./validierung/Tests.csv")

fig <- plot_ly(data = tests, x = ~fromTo, y = ~fromTo_google)
fig
fig <- plot_ly(data = flachland, x = ~reverse, y = ~reverse_google)
fig




