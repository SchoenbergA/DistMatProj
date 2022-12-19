require(gdalUtils)


dirOfScript = dirname(rstudioapi::getSourceEditorContext()$path)

setwd(dirOfScript)

gdalwarp(srcfile = 'merge_filled_md110_si15.tiff', 
         dstfile = 'medium_AOI_SRTM.tiff',
         cutline = 'BBox_medium_AOI.kml', 
         crop_to_cutline = T)
