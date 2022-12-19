require(gdalUtils)


dirOfScript = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(dirOfScript)

gdal_translate(src_dataset = 'merge_filled_md110_si15.tiff', 
               dst_dataset = 'merge_filled_md110_si15.asc', 
               of = 'AAIGrid')

first6lines = readLines('merge_filled_md110_si15.asc', n=6)


fileConn = file("first6lines_grid_info.txt")
writeLines(first6lines, fileConn)
close(fileConn)

# deletion of first 6 lines of 'merge_filled_md110_si15.asc' done via 
# sed -i '1,6d' merge_filled_md110_si15.asc

