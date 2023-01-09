### Wenker GID issues

## set environment
wd <- "C:/Envimaster/DistMatProj"
dat<- file.path(wd,"Data_GID")

# load packages
require(rgdal)
require(LinguGeo)

# load data
wen <- readOGR(file.path(dat,"Wenker_places_wgs.shp"))

# conert shp to dataframe
df <- as.data.frame(wen)
head(df)
# reduce df
df <- df[,c(6,7,2,3,5)]
head(df)

# check GID
sort(table(df$gid),decreasing = T)[1:20]

length(which(sort(table(df$gid),decreasing = T)>1)) # 2607
length(which(sort(table(df$gid),decreasing = T)>3)) # 151
length(which(sort(table(df$gid),decreasing = T)>10))# 3

# merge multi places
df_mp <- LinguGeo::mergeMultiPlaces(df,1,2,col_ls = 1:ncol(df),class_col_ls = 3)

nrow(df)
nrow(df_mp)

### check unique places GID

# check for multiple places with same GID
sort(table(df_mp$gid),decreasing = T)
length(which(sort(table(df_mp$gid),decreasing = T)>1))

# check for diffenret GIDs for same places

# check by nchar
sort(table(nchar(df_mp$gid)),decreasing = T)
length(which(nchar(df_mp$gid)>7)) # 13

# check by occuriance of "," in GID
nrow(df_mp[grep(",",df_mp$gid),]) # 13

### check places with mutliple GIDs
df_mp[grep(",",df_mp$gid),]


### check if mutliple GIDs occure elsewhere

sub <-df_mp[grep(",",df_mp$gid),]

for(i in 1:nrow(sub)){
  cat(paste0("GID ",strsplit(sub$gid[i],", ")[[1]][1]))
  print(any(df_mp$gid==strsplit(sub$gid[i],", ")[[1]][1]  ) )
  cat(paste0("GID ",strsplit(sub$gid[i],", ")[[1]][2]))
  print(any(df_mp$gid==strsplit(sub$gid[i],", ")[[1]][2]  ) )
}

################################################################################
 
