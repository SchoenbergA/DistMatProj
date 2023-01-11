require(osrm)
library(httr)    
set_config(use_proxy(url="10.3.100.207",port=8080))

dirOfScript = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(dirOfScript)

options(osrm.server = "http://127.0.0.1:5000/")


wenkerAOI = read.csv("Wenker_places_medium_AOI.csv")
wenkerAOI = wenkerAOI[c('X', 'Y', 'gid')]

length(wenkerAOI$gid)
length(unique(wenkerAOI$gid))

f = wenkerAOI[duplicated(wenkerAOI$gid),'gid']
wenkerAOI[wenkerAOI$gid %in% f, 'gid']

wenkerAOI = wenkerAOI[!duplicated(wenkerAOI$gid),]

rownames(wenkerAOI) = wenkerAOI$gid
wenkerAOI['gid'] = NULL
colnames(wenkerAOI) = c('lon', 'lat')

distances = osrmTable(loc = wenkerAOI)
distances = distances$durations

dim(distances) 

i = 1
wenkerAOI
wenkerAOI[i,]
osrmTable(src = wenkerAOI, dst = wenkerAOI[i,])

n = NROW(wenkerAOI)

akk = c()
for(i in 1:n){
  row_i = osrmTable(src = wenkerAOI, dst = wenkerAOI[i,])
  akk = cbind(akk, row_i)
}

osrmTable(wenkerAOI[1:n,], wenkerAOI[2,])
