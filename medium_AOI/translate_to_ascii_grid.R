require(gdalUtils)


dirOfScript = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(dirOfScript)

gdal_translate(src_dataset = 'medium_AOI_SRTM.tiff', 
               dst_dataset = 'medium_AOI_SRTM.asc', 
               of = 'AAIGrid')

first6lines = readLines('medium_AOI_SRTM.asc', n=6)

fileConn<-file("first6lines_info.txt")
writeLines(first6lines, fileConn)
close(fileConn)

# deletion of first 6 lines of 'medium_AOI_SRTM.asc' done via 
# sed -i '1,6d' medium_AOI_SRTM.asc