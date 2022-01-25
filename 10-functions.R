
rcpNoDots <- function(rcp){
  nodots <- gsub(pattern = "\\.", replacement = "", x = rcp)
  return(nodots)
}


buildResultsTable <- function(studyAreaName, GCM = c("Access1", "INM-CM4", "CanESM2"), RCP = c("RCP4.5", "RCP8.5"), reps = c(1:3)) {

  dirs <- expand.grid("studyAreaName" = studyAreaName, "GCM" = GCM, RCP =  RCP, reps = reps, driver = c("noLandRCS", ""))

  dirs$filename <- paste(dirs$studyAreaName, dirs$GCM, rcpNoDots(dirs$RCP),
                         dirs$driver, dirs$reps, sep = "_")
  dirs$filename <- gsub(pattern = "__", replacement = "_", x = dirs$filename)
  dirs$fileLocation <- file.path("outputs/sims", dirs$studyAreaName, dirs$GCM, dirs$RCP, dirs$filename)
  historicalRuns <- data.frame(filename = paste0(studyAreaName, "_historical_LandR_", 1:3), reps = 1:3)
  historicalRuns$fileLocation <- paste("outputs/sims", studyAreaName = studyAreaName,
                                       historicalRuns$filename, sep = "/")
  outputFiles <- dplyr::full_join(historicalRuns, dirs)
  outputFiles <- as.data.table(outputFiles)
  outputFiles[is.na(studyAreaName), `:=`(
              studyAreaName = studyAreaName,
              GCM = "historical",
              RCP = "",
              driver = "noLandRCS")]
  outputFiles
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
    RCP = thisRun$RCP,
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
    RCP = thisRun$RCP,
    driver = thisRun$driver,
    rep = thisRun$rep
  )]

  return(BiomassBySpecies)
}

getMeanRasterByRun <- function(resultsTable, year, rasterName){
 RunsNoRep <- unique(resultsTable[, .(GCM, RCP, driver)])
 outRasters <- lapply(1:nrow(RunsNoRep), FUN = function(i, rT = resultsTable, rnr = RunsNoRep,
                                                        y = year, Name = rasterName){
   rnr <- rnr[i, ]
   fileLocation <- rT[rnr, on = c("GCM", "RCP", "driver")]$fileLocation
   fileLocation <- file.path(fileLocation, paste0(Name, "_year", y, ".rds"))
   rasters <- lapply(fileLocation, readRDS)
   rasters <- raster::stack(rasters)
   outRaster <- raster::calc(rasters, mean)
   return(outRaster)
 })

  names(outRasters) <- paste(RunsNoRep$GCM, RunsNoRep$RCP, RunsNoRep$driver, sep = "_")
  return(outRasters)
}
