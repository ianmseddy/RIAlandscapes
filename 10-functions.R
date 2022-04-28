
SSPNoDots <- function(SSP) {
  nodots <- gsub(pattern = "\\.", replacement = "", x = SSP)
  return(nodots)
}

buildResultsTable <- function(allRunInfo) {

  outTable <- data.table::copy(allRunInfo)
  outTable[GCM != "historical" & gmcsDriver == "LandR.CS", filename := paste(studyArea, GCM, SSP, Replicates, sep = "_")]
  outTable[GCM != "historical" & gmcsDriver == "LandR", filename := paste(studyArea, GCM, SSP, "noLandRCS", Replicates, sep = "_")]
  outTable[GCM != "historical", fileLocation := file.path("outputs/sims", studyArea, GCM, SSP, filename)]
  outTable[GCM == "historical", filename := paste(studyArea, GCM, gmcsDriver, Replicates, sep = "_")]
  outTable[GCM == "historical", fileLocation := file.path("outputs/sims", studyArea, filename)]

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


makeMeanBurnRasters <- function(rt, year = 2101) {

  scenarios <- unique(rt[, .(studyArea, GCM, SSP)])

  outRasters <- lapply(scenarios, FUN = function(i) {
    scenario <- scenarios[i,]
    scenario <- resultsTable[scenario, on = c("studyArea", "GCM", "SSP")]
    burnRasters <- file.path(scenario$fileLocation, "burnMap_year2101.rds")
    burnMaps <- lapply(burnRasters, readRDS)
    burnMap <- stack(burnMaps)
    burnMap <- raster::mean(burnMap)
  })
  names(outRasters) <- paste0(scenarios$studyArea, scenarios$GCM, scenarios$SSP, collapse = "_")
  return(outRasters)
}

burnSumFun <- function(run, rt) {
  thisRun <- rt[fileLocation == run,]
  simList <- qs::qread(file = file.path(thisRun$fileLocation, paste0(thisRun$filename, ".qs")))
  burnSummary <- as.data.table(simList$burnSummary)
  # burnSummary[, decade := round(year/10) * 10]
  # burnSummaryDecade <- burnSummary[, .(burnSum = sum(areaBurnedHa),
  #                                      mfs = mean(areaBurnedHa),
  #                                      sdMFS = sd(areaBurnedHa),
  #                                      Nfires = .N), .(decade)]
  burnSummary[, `:=`(
    studyArea = thisRun$studyArea,
    GCM = thisRun$GCM,
    SSP = thisRun$SSP,
    driver = thisRun$gmcsDriver,
    rep = thisRun$Replicates
  )]

  rm(simList)
  return(burnSummary)
}


