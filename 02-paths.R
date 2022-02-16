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





if (config::get("gcm") != "historical") {
  sspNoDots <- gsub(pattern = "\\.", replacement = "", x = config::get("ssp"))
  uniqueRunName <- paste(config::get("studyarea"),
                         config::get("gcm"),
                         sspNoDots, #avoid dots with the tar
                         config::get("replicate"), sep = "_")
  #will need to rethink how to set up nonLandR runs -
  if (config::get('gmcsdriver') == "LandR") {
    uniqueRunName <- paste(config::get("studyarea"),
                           config::get("gcm"),
                           sspNoDots, #avoid dots with the tar
                           "noLandRCS",
                           config::get("replicate"), sep = "_")
  }
  if (simulateAM){
    hasAM <- ifelse(AMscenario, "withAM", "withNoAM")
    uniqueRunName <- paste(config::get("studyarea"),
                           config::get("gcm"),
                           sspNoDots,
                           hasAM, sep = "_")
  }
  #this approach cannot rely on nested directories, because the tarball only gets the final name
  dynamicPaths$outputPath <- file.path("outputs", "sims",
                                       config::get("studyarea"),
                                       config::get("gcm"),
                                       config::get("ssp"),
                                       uniqueRunName)
} else if (config::get("gmcsdriver") == "LandR") {
  landr <- ifelse(config::get("gmcsdriver") == "LandR", "LandR", "LandRCS")
  uniqueRunName <- paste(config::get("studyarea"),
                         "historical",
                         landr,
                         config::get("replicate"),
                         sep = "_")
  dynamicPaths$outputPath <- file.path("outputs", "sims",
                                       config::get("studyarea"),
                                       uniqueRunName)

} else {
  stop("Ian you need to set up for when LandR.CS is run but historical fireSense")
}
#redundant study area so dir begins with letter
postProcessingPaths <- dynamicPaths
postProcessingPaths$outputPath <- file.path("outputs/summary figures/", studyAreaName)
postProcessingPaths$cachePath <- "cache/cache_postProcess"
