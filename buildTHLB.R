#build THLB
library(sf)
thlb <- list.files("C:/Ian/Data/BC/THLB/", pattern = "thlb$")
rasterToMatch <- raster("C:/ian/Git/RIAlandscapes/inputs/standAgeMap_BC2001.tif")
thlb <- lapply(thlb, FUN = function(x, rtm = rasterToMatch){
  x <- file.path("C:/Ian/Data/BC/THLB", x, paste0(x, ".gdb"))
  tsa <- st_read(x)
  tsa <- st_transform(tsa, crs = crs(rtm))
  tsaRas <- fasterize(tsa, field = "thlb_fact", raster = rtm)
  return(tsaRas)
})

thlb$fun <- max
thlbRas <- do.call(merge, thlb)
raster::plot(thlbRas)
writeRaster(thlbRas, "C:/Ian/Data/BC/thlbRaster_RIA.tif")
