
SSPNoDots <- function(SSP){
  nodots <- gsub(pattern = "\\.", replacement = "", x = SSP)
  return(nodots)
}

buildResultsTable <- function(allRunInfo) {

  outTable <- data.table::copy(allRunInfo)
  outTable[GCM != "historical" & gmcsDriver == "LandR.CS", filename := paste(studyArea, GCM, SSP, Replicates, sep = "_")]
  outTable[GCM != "historical" & gmcsDriver == "LandR", filename := paste(studyArea, GCM, SSP, "noLandRCS", Replicates, sep = "_")]
  outTable[GCM != "historical", fileLocation := file.path("outputs/sims", studyAreaName, GCM, SSP, filename)]
  outTable[GCM == "historical", filename := paste(studyArea, GCM, gmcsDriver, Replicates, sep = "_")]
  outTable[GCM == "historical", fileLocation := file.path("outputs/sims", studyAreaName, filename)]

  return(outTable)
}


dropPadding <- function(ecoregionGroup) {
  ecoregionGroup <- gsub(pattern = "_0", x = ecoregionGroup, replacement = "_")

}

getSimulationOutput <- function(run, rt) {
  thisRun <- rt[fileLocation == run,]

  if (file.exists(file.path(thisRun$fileLocation, "simulationOutput_year2101.rds"))){
    biomassByEcozone <- readRDS(file = file.path(thisRun$fileLocation, "simulationOutput_year2101.rds"))
  } else {
    simList <- qs::qread(file = file.path(thisRun$fileLocation, paste0(thisRun$filename, ".qs")))
    biomassByEcozone <- simList$simulationOutput
    if (is.null(biomassByEcozone)) {
      stop("missing ", run) }
    rm(simList)
  }
  biomassByEcozone <- as.data.table(biomassByEcozone)

  biomassByEcozone[, `:=`(
    GCM = thisRun$GCM,
    SSP = thisRun$SSP,
    driver = thisRun$driver,
    rep = thisRun$rep
  )]

  return(biomassByEcozone)
}

getSummaryBySpecies <- function(run, rt) {
  thisRun <- rt[fileLocation == run,]
  theFile <- file.path(thisRun$fileLocation, "summaryBySpecies_year2101.rds")
  if (file.exists(theFile)) {
    BiomassBySpecies <- readRDS(file = theFile)
  } else {
    simList <- qs::qread(file = file.path(thisRun$fileLocation, paste0(thisRun$filename, ".qs")))
    BiomassBySpecies <- simList$summaryBySpecies
    if (is.null(BiomassBySpecies)) {
      stop("missing ", run) }
    rm(simList)
  }
  BiomassBySpecies <- as.data.table(BiomassBySpecies)

  BiomassBySpecies[, `:=`(
    GCM = thisRun$GCM,
    SSP = thisRun$SSP,
    driver = thisRun$driver,
    rep = thisRun$rep
  )]

  return(BiomassBySpecies)
}

getMeanRasterByRun <- function(resultsTable, year, rasterName){
 RunsNoRep <- unique(resultsTable[, .(GCM, SSP, driver)])
 outRasters <- lapply(1:nrow(RunsNoRep), FUN = function(i, rT = resultsTable, rnr = RunsNoRep,
                                                        y = year, Name = rasterName){
   rnr <- rnr[i, ]
   fileLocation <- rT[rnr, on = c("GCM", "SSP", "driver")]$fileLocation
   fileLocation <- file.path(fileLocation, paste0(Name, "_year", y, ".rds"))
   rasters <- lapply(fileLocation, readRDS)
   rasters <- raster::stack(rasters)
   outRaster <- raster::calc(rasters, mean)
   return(outRaster)
 })

  names(outRasters) <- paste(RunsNoRep$GCM, RunsNoRep$SSP, RunsNoRep$driver, sep = "_")
  return(outRasters)
}
