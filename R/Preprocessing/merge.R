require(gdalUtils)

dirOfScript = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(dirOfScript)

files = list.files(pattern = '*\\.tif')

gdalbuildvrt(gdalfile = files, output.vrt = 'merge.vrt')

gdal_translate('merge.vrt', 'merge.tif')
