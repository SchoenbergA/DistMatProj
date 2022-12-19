require(gdalUtils)


dirOfScript = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(dirOfScript)

gdal_translate(src_dataset = 'merge.tif', dst_dataset = 'merge.asc', of = 'AAIGrid')

readLines('merge.asc', n=6)
