if (!exists("pkgDir")) {
  pkgDir <- file.path("packages", version$platform, paste0(version$major, ".",
                                                           strsplit(version$minor, "[.]")[[1]][1]))

  if (!dir.exists(pkgDir)) {
    dir.create(pkgDir, recursive = TRUE)
  }
  .libPaths(pkgDir)
}
library(reproducible)
library(raster)
library(ggplot2)
library(data.table)
options("reproducible.useTerra" = TRUE)


projectedClim <- list.files("modules/RIAlandscapes_studyArea/data/climate/future/", pattern = "MDC", full.names = TRUE)
historicalClim <- raster::stack("modules/RIAlandscapes_studyArea/data/wholeRIA_histMDC91-19.tif") #this is actually 2001-2019...
LCC <- list(WCB = raster("modules/RIAlandscapes_studyArea/data/WCB_LCC2010.tif"),
            WB = raster("modules/RIAlandscapes_studyArea/data/WB_LCC2010.tif"),
            SB = raster("modules/RIAlandscapes_studyArea/data/SB_LCC2010.tif"))
flammableRTM <- lapply(LCC, FUN = LandR::defineFlammable, nonFlammClasses = c(13, 16, 17, 18, 19))
names(flammableRTM) <- names(LCC)




studyAreas <- c("SB", "WB", "WCB")
for (i in studyAreas) {
  SAClim <- projectedClim[grep(projectedClim, pattern = i)]
  SA_flamRTM = flammableRTM[[i]]
  histClim <- postProcessTerra(historicalClim, to = SA_flamRTM)
  out <- lapply(SAClim, FUN = function(climName,
                                       histMDC = histClim,
                                       flamRTM = SA_flamRTM, I = i) {

    projMDC <- raster::stack(climName)
    climName <- stringr::str_remove(climName, pattern = "modules/RIAlandscapes_studyArea/data/climate/future//MDC_future_")
    climName <- stringr::str_remove(climName, pattern = ".tif")
    outPlot <- fireSenseUtils::compareMDC(historicalMDC = histMDC,
                                          projectedMDC = projMDC,
                                          flammableRTM = flamRTM)
    ggsave(filename = file.path("outputs/climate figures/", I, paste0(climName, ".png")),
           device = "png",
           plot = outPlot)
    return(outPlot)
  })
  out
}

projectedClim <- list.files("modules/RIAlandscapes_studyArea/data/climate/future/", pattern = "CMI", full.names = TRUE)

for (i in studyAreas) {
  SAClim <- projectedClim[grep(projectedClim, pattern = i)]
  SA_flamRTM = flammableRTM[[i]]
  histClim <- postProcessTerra(historicalClim, to = SA_flamRTM)
  flamPixels <- data.table(flam = getValues(SA_flamRTM), pixelID = 1:ncell(SA_flamRTM))
  flamPixels <- flamPixels[flam == 1]

  out <- lapply(SAClim, FUN = function(climName, FlamPixels = flamPixels, I = i) {

    projCMI <- raster::stack(climName)
    climName <- stringr::str_remove(climName, pattern = "modules/RIAlandscapes_studyArea/data/climate/future//CMI_future_")
    climName <- stringr::str_remove(climName, pattern = ".tif")
    pixelID <- 1:ncell(projCMI)
    projCMI <- as.data.table(getValues(projCMI))
    yearCols <- paste0("X", 2011:2100)
    colnames(projCMI) <- yearCols
    projCMI[, pixelID := pixelID]
    projCMI <- projCMI[pixelID %in% FlamPixels$pixelID]
    projCMI[, pixelID := NULL]
    projCMI <- melt.data.table(data = projCMI,  variable.name = "year", value.name = "CMI")
    projCMI[, year := as.numeric(stringr::str_remove(year, "X"))]
    projCMI <- projCMI[, .(CMI = mean(CMI, na.rm = TRUE)), .(year)]

    outPlot <- ggplot(data = projCMI, aes(x = year, y = CMI)) +
      geom_line() +
      geom_smooth() +
      ylab ("mean CMI")

    ggsave(filename = file.path("outputs/climate figures/", I, paste0(climName, "_CMI.png")),
           device = "png",
           plot = outPlot)
    return(outPlot)

  })
}



projectedClim <- list.files("modules/RIAlandscapes_studyArea/data/climate/future/", pattern = "ATA", full.names = TRUE)

for (i in studyAreas) {
  SAClim <- projectedClim[grep(projectedClim, pattern = i)]
  SA_flamRTM = flammableRTM[[i]]
  histClim <- postProcessTerra(historicalClim, to = SA_flamRTM)
  flamPixels <- data.table(flam = getValues(SA_flamRTM), pixelID = 1:ncell(SA_flamRTM))
  flamPixels <- flamPixels[flam == 1]

  out <- lapply(SAClim, FUN = function(climName, FlamPixels = flamPixels, I = i) {

    projATA <- raster::stack(climName)
    climName <- stringr::str_remove(climName, pattern = "modules/RIAlandscapes_studyArea/data/climate/future//ATA_future_")
    climName <- stringr::str_remove(climName, pattern = ".tif")
    pixelID <- 1:ncell(projATA)
    projATA <- as.data.table(getValues(projATA))
    yearCols <- paste0("X", 2011:2100)
    colnames(projATA) <- yearCols
    projATA[, pixelID := pixelID]
    projATA <- projATA[pixelID %in% FlamPixels$pixelID]
    projATA[, pixelID := NULL]
    projATA <- melt.data.table(data = projATA,  variable.name = "year", value.name = "ATA")
    projATA[, year := as.numeric(stringr::str_remove(year, "X"))]
    projATA <- projATA[, .(ATA = mean(ATA, na.rm = TRUE)), .(year)]

    outPlot <- ggplot(data = projATA, aes(x = year, y = ATA)) +
      geom_line() +
      geom_smooth() +
      ylab ("mean ATA")

    ggsave(filename = file.path("outputs/climate figures/", I, paste0(climName, "_ATA.png")),
           device = "png",
           plot = outPlot)
    return(outPlot)

  })
}

