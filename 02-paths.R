################################################################################
## Set paths for each part of the simulation
################################################################################

defaultPaths <- list(
  cachePath = cacheDir,
  modulePath = "modules",
  inputPath = "inputs",
  outputPath = file.path("outputs", studyAreaName)
)

preamblePaths <- defaultPaths
preamblePaths[["cachePath"]] <- file.path(cacheDir, "cache_preamble")

dataPrepPaths <- defaultPaths
dataPrepPaths[["cachePath"]] <- file.path(cacheDir, "cache_dataPrep")

ignitionFitPaths <- defaultPaths
ignitionFitPaths[["cachePath"]] <- file.path(cacheDir, "cache_ignitionFit")

escapeFitPaths <- defaultPaths
escapeFitPaths[["cachePath"]] <- file.path(cacheDir, "cache_escapeFit")

spreadFitPaths <- defaultPaths
spreadFitPaths[["cachePath"]] <- file.path(cacheDir, "cache_spreadFit")

## main (dynamic) simulation
dynamicPaths <-  defaultPaths
dynamicPaths$cachePath <- file.path(cacheDir, "cache_sim")





if (GCM != "historical") {
  sspNoDots <- gsub(pattern = "\\.", replacement = "", x = SSP)
  uniqueRunName <- paste(studyAreaName,
                         GCM,
                         sspNoDots, #avoid dots with the tar
                         Replicate, sep = "_")
  #will need to rethink how to set up nonLandR runs -
  if (gmcsDriver == "LandR") {
    uniqueRunName <- paste(studyAreaName,
                           GCM,
                           sspNoDots, #avoid dots with the tar
                           "noLandRCS",
                           Replicate, sep = "_")
  }
  #this approach cannot rely on nested directories, because the tarball only gets the final name
  dynamicPaths$outputPath <- file.path("outputs", "sims",
                                       studyAreaName,
                                       GCM,
                                       SSP,
                                       uniqueRunName)
} else if (gmcsDriver == "LandR") {
  landr <- ifelse(gmcsDriver == "LandR", "LandR", "LandRCS")
  uniqueRunName <- paste(studyAreaName,
                         "historical",
                         landr,
                         Replicate,
                         sep = "_")
  dynamicPaths$outputPath <- file.path("outputs", "sims",
                                       studyAreaName,
                                       uniqueRunName)

} else {
  stop("Ian you need to set up for when LandR.CS is run but historical fireSense")
}

if (simulateAM){
  hasAM <- ifelse(AMscenario, "withAM", "withNoAM")
  uniqueRunName <- paste(studyAreaName,
                         GCM,
                         sspNoDots,
                         hasAM, sep = "_")
  dynamicPaths$outputPath <- file.path("outputs", "AMsims",
                                       uniqueRunName)
}

#redundant study area so dir begins with letter
postProcessingPaths <- dynamicPaths
postProcessingPaths$outputPath <- file.path("outputs/summary figures/", studyAreaName)
postProcessingPaths$cachePath <- "cache/cache_postProcess"
