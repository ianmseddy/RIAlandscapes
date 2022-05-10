#these are functions used in postProcessing
# most are simply two steps of either aggregating files by study area and doing something,
#or mosaicking maps of study areas by GCM SSP Rep and gmcsDriver.
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

  biomassByEcozone <- readRDS(file = file.path(thisRun$fileLocation, "simulationOutput_year2101.rds"))

  biomassByEcozone <- as.data.table(biomassByEcozone)

  biomassByEcozone[, `:=`(
    studyArea = thisRun$studyArea,
    GCM = thisRun$GCM,
    SSP = thisRun$SSP,
    driver = thisRun$gmcsDriver,
    rep = thisRun$Replicates
  )]

  return(biomassByEcozone)
}

getSummaryBySpecies <- function(run, rt) {
  thisRun <- rt[fileLocation == run,]
  theFile <- file.path(thisRun$fileLocation, "summaryBySpecies_year2101.rds")
  BiomassBySpecies <- readRDS(file = theFile)

  BiomassBySpecies <- as.data.table(BiomassBySpecies)

  BiomassBySpecies[, `:=`(
    studyArea = thisRun$studyArea,
    GCM = thisRun$GCM,
    SSP = thisRun$SSP,
    driver = thisRun$gmcsDriver,
    rep = thisRun$Replicates
  )]

  return(BiomassBySpecies)
}


#shapefiles = named list of studyAreaReporting, for cropping
makeMeanBurnRasters <- function(rt, year = 2101, studyAreaReporting) {

  scenarios <- unique(rt[, .(studyArea, GCM, SSP)])


  outRasters <- lapply(1:nrow(scenarios), FUN = function(i, s= scenarios, r = rt, sa = studyAreaReporting) {
    scenario <- s[i, ]
    sa <- sa[[scenario$studyArea]]
    scenarioReps <- r[scenario, on = c("studyArea", "GCM", "SSP")]

    burnRasters <- file.path(scenarioReps$fileLocation, paste0("burnMap_year", year, ".rds"))
    burnMaps <- lapply(burnRasters, readRDS)
    burnMap <- raster::stack(burnMaps)
    burnMap <- raster::mean(burnMap)
    burnMap <- postProcess(burnMap, studyArea = sa)

    return(burnMap)
  })
  names(outRasters) <- paste(scenarios$studyArea, scenarios$GCM, scenarios$SSP, sep = "_")
  return(outRasters)
}

burnSumFun <- function(run, rt) {
  thisRun <- rt[fileLocation == run,]
  simList <- qs::qread(file = file.path(thisRun$fileLocation, paste0(thisRun$filename, ".qs")))
  burnSummary <- as.data.table(simList$burnSummary)
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


getStudyAreaReporting <- function(studyArea) {
  outFile <- list()
  for (i in 1:length(studyArea)) {
  biomassMaps2011 <- qs::qread(file.path("outputs", studyArea[i], paste0("biomassMaps2011_", studyArea[i], ".qs")))
  outFile[i] <- biomassMaps2011$studyAreaReporting
  }
  names(outFile) <- studyArea
  return(outFile)
}

MosaicMaps <- function(rasterList) {
 #the vectorization is NOT working. package bug?
  names(rasterList) <- str_replace_all(string = names(rasterList),pattern = "WCB_", "")
  names(rasterList) <- str_replace_all(string = names(rasterList),pattern = "SB_", "")
  names(rasterList) <- str_replace_all(string = names(rasterList),pattern = "WB_", "")

  gcmSSP <- unique(names(rasterList))
  outMaps <- lapply(gcmSSP, FUN = function(i, ras = rasterList) {
    outMap <- ras[names(ras) %in% i]
    names(outMap)[1:2] <- c("x", "y") #absurd raster issue
    outMap$fun <- "mean"
    outMap$na.rm <- TRUE
    outMap <- do.call(raster::mosaic, args = outMap)
  })
  names(outMaps) <- gcmSSP
  return(outMaps)
}

makeMeanBiomassRasters <- function(rt, year = 2101, studyAreaReporting) {

  scenarios <- unique(rt[, .(studyArea, GCM, SSP)])


  outRasters <- lapply(1:nrow(scenarios), FUN = function(i, s= scenarios, r = rt, sa = studyAreaReporting) {
    scenario <- s[i, ]
    sa <- sa[[scenario$studyArea]]
    scenarioReps <- r[scenario, on = c("studyArea", "GCM", "SSP")]

    BiomassRasters <- file.path(scenarioReps$fileLocation, paste0("simulatedBiomassMap_year", year, ".rds"))
    BiomassMaps <- lapply(BiomassRasters, readRDS)
    BiomassMap <- raster::stack(BiomassMaps)
    BiomassMap <- raster::mean(BiomassMap)
    BiomassMap <- postProcess(BiomassMap, studyArea = sa)
    BiomassMap <- BiomassMap/100 #convert to Mg/ha

    return(BiomassMap)
  })
  names(outRasters) <- paste(scenarios$studyArea, scenarios$GCM, scenarios$SSP, sep = "_")
  return(outRasters)
}

compareProjAndRef <- function(i, SAmaps, refMap, operatorFunction = function(proj, ref){proj-ref}){
  SAmaps <- SAmaps[grep(names(SAmaps), pattern = i)]
  layerNames <- names(SAmaps)
  SAmaps <- raster::stack(SAmaps)
  refMap <- refMap[[grep(names(refMap), pattern = i)]]
  # SAmaps <- raster::overlay(x = SAmaps, y = refMap, fun = function(a, b){a - b})
  SAmaps <- operatorFunction(proj = SAmaps, ref = refMap)
  names(SAmaps) <- layerNames
  return(SAmaps)
}
