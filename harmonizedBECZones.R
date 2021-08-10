# creating the RIA ecoregion raster
library(reproducible)
library(raster)


#BC Subzones
BCecoregionRstUrl <- 'https://drive.google.com/file/d/1R38CXviHP72pbMq7hqV5CfT-jdJFZuWL/view?usp=sharing'
#Yukon BEC zones, from
# https://map-data.service.yukon.ca/GeoYukon/Biophysical/Bioclimate_Zones_and_Subzones/Bioclimate_zones_and_subzones.zip
YukonecoregionRstUrl <- "https://drive.google.com/file/d/1Dce0_rSBkxKjNM9q7-Zsg0JFidYu6cKP/view?usp=sharing"

dPath <- "modules/RIAlandscapes_studyArea/data"
BCbecs <- prepInputs(url = BCecoregionRstUrl,
                     destinationPath = dPath)
Yukonbecs <- prepInputs(url = YukonecoregionRstUrl,
                        destinationPath = dPath)

Yukonbecs <- setValues(Yukonbecs, getValues(Yukonbecs) + 1000)

Yukonbecs <- raster::extend(Yukonbecs, BCbecs)
origin(Yukonbecs) <- origin(BCbecs)

#this is hosted on googledrive
RIAzones <- raster::mosaic(Yukonbecs, BCbecs, fun = 'min')
writeRaster(RIAzones, "C:/Ian/data/RIA/RIA_BC_YK_BECSubzones.tif")

