require(gdalUtils)
require(raster)
require(stringr)
require(parallel)


dirOfScript = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(dirOfScript)

files = list.files(path = './not_resampled', pattern = '*\\.tif')


# if all files are in same folder, this selects just the one that need resampling
x = files
x = sapply(x, function(x) strsplit(x, '_', fixed=T))
x = sapply(x, '[[', 1)
x = sapply(x, str_remove, fixed('n'))
x = as.numeric(x)
files = files[which(x >= 50)]


numCores = detectCores()
cl <- makeCluster(numCores)
clusterEvalQ(cl, require(gdalUtils))



parSapply(cl, files, FUN = function(x) {
  sp = strsplit(x, split = '.', fixed = T)
  sp = unlist(sp)
  dst = paste(sp, collapse = '_resampled.')
  x = paste0('./not_resampled/', x)
  gdalwarp(x, tr=c(0.0002777777777777777775, -0.0002777777777777777775), r = 'cubic', dstfile = dst)
})

dem1 = raster('n45_e012_1arc_v3.tif')
dem2 = raster('n45_e012_1arc_v3_resampled.tif')
dem1
dem2
