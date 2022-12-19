# DistMatProj
 DistanzMatrixProject

## ToDo
### Distanzmatrix DR

* Datensammlung und Verarbeitung
   - SRTM 1-arc-sec-global (non-filled)
      * ~~besorgen für ganzes Deutsches Reich~~ (&rarr; USGS Earthexplorer)
      * ~~alle über 50° nördliche breite resamplen für gleiches format~~ (&rarr; resample.R)
      * ~~mergen~~ (&rarr; merge.R)
      * ~~void fill~~ (&rarr; gdal_fillnodata.py: > gdal_fillnodata.py -md 110 -si 15 -of GTiff -b 1 merge.tif merge_filled_md100_si15.tiff)
      * richtiges format: Ascii Grid .asc (&rarr; translate_to_ascii_grid.R)
      * Lua-profil anpassen: input, Bounding-Box
   - OSM
      * ~~kompletter Europa datensatz besorgen~~
      * ~~zuschneiden auf Deutsches Reich / AOI~~ (&rarr; osmium: osmium extract -b 5.46,45.18,23.45,56.37 europe-latest.osm.pbf -o osm_DR.pbf)
   - Boundingbox einladen
       * ggf Robert fragen
* Erstmal kleinere AOI testen (BBox_medium_AOI)
  - Daten vorbereiten
    * ~~OSM Daten zuschneiden~~ (&rarr; osmium: > osmium extract -b 7.4177680640243899,47.9090831097560965,12.4342842378048992,52.6769672865854020 osm_DR.pbf -o osm_medium_AOI.pbf) 
    * ~~SRTM-Daten zuschneiden~~ (&rarr; clip_medium_AOI.R, input die fertige .tiff-datei für gesamtes DR)
    * ~~richtiges format: Ascii Grid .asc~~ (via translate_to_ascii_grid.R)
    * ~~ersten 6 Zeilen entfernen~~
    * ~~Lua-profil anpassen: input, Bounding-Box~~
         
 
* Matrix erstellen (Andis PC)
 
      
## Notes

* Boundingbox einladen
    -> ggf Robert fragen
* R void fill? &rarr; scheint es nicht zu geben (kein Wrapper um gdal_fillnodata.py bzw. GDALFillNoData())
* Größe DistMat abschätzen/testen (kleinere AOI)
* Speicherort und Zugriff?
    - Robert fragen
    - Github/ externer Server
    - in R links aufrufen
