do.call(setPaths, dynamicPaths)
# runName <- paste0(config::get("studyarea"), config::get("replicate"))

#clean up some problems
names(simOutPreamble$ATAstack) <- paste0("ATA", 2011:2100)
names(simOutPreamble$CMIstack) <- paste0("CMI", 2011:2100)
names(simOutPreamble$projectedClimateLayers$MDC) <- paste0("year", 2011:2100)

times <- list(start = 2011, end = 2101)

dynamicModules <- list(
  "gmcsDataPrep",
  "fireSense_dataPrepPredict",
  "fireSense",
  "fireSense_IgnitionPredict",
  "fireSense_EscapePredict",
  "fireSense_SpreadPredict",
  "Biomass_core",
  "Biomass_regeneration")

dynamicObjects <- list(
  studyAreaPSP = simOutPreamble[["studyAreaPSP"]],
  ATAstack = simOutPreamble[["ATAstack"]],
  CMIstack = simOutPreamble[["CMIstack"]],
  CMInormal = simOutPreamble[["CMInormal"]],
  PSPmeasure = as.data.table(biomassMaps2011[["PSPmeasure"]]),
  PSPplot = as.data.table(biomassMaps2011[["PSPplot"]]),
  PSPgis = biomassMaps2011[["PSPgis"]],
  biomassMap = biomassMaps2011$biomassMap,
  climateComponentsTouse = fSsimDataPrep[["climateComponentsToUse"]],
  cohortData = as.data.table(fSsimDataPrep[["cohortData2011"]]),
  ecoregion = as.data.table(biomassMaps2011[["ecoregion"]]),
  ecoregionMap = biomassMaps2011[["ecoregionMap"]],
  flammableRTM = fSsimDataPrep[["flammableRTM"]],
  fireSense_IgnitionFitted = ignitionOut[["fireSense_IgnitionFitted"]],
  fireSense_EscapeFitted = escapeOut[["fireSense_EscapeFitted"]],
  fireSense_SpreadFitted = spreadOut[["fireSense_SpreadFitted"]],
  covMinMax_spread = as.data.table(spreadOut[["covMinMax_spread"]]),
  covMinMax_ignition = as.data.table(ignitionOut[["covMinMax_ignition"]]),
  landcoverDT = as.data.table(fSsimDataPrep[["landcoverDT"]]),
  nonForest_timeSinceDisturbance = fSsimDataPrep[["nonForest_timeSinceDisturbance2011"]],
  minRelativeB = as.data.table(biomassMaps2011[["minRelativeB"]]), ## biomassMaps2011 needs bugfix to qs
  PCAveg = fSsimDataPrep[["PCAveg"]],
  pixelGroupMap = fSsimDataPrep[["pixelGroupMap2011"]],
  projectedClimateLayers = simOutPreamble[["projectedClimateLayers"]],
  rasterToMatch = biomassMaps2011[["rasterToMatch"]],
  rasterToMatchLarge = biomassMaps2011[["rasterToMatchLarge"]],
  species = as.data.table(biomassMaps2011[["species"]]),
  speciesEcoregion = as.data.table(biomassMaps2011[["speciesEcoregion"]]), ## biomassMaps2011 needs bugfix to qs
  speciesLayers = biomassMaps2011[["speciesLayers"]], ## TODO: does Biomass_core actually need this?
  sppColorVect = simOutPreamble[["sppColors"]],
  sppEquiv = as.data.table(fSsimDataPrep[["sppEquiv"]]), ## biomassMaps2011 needs bugfix to qs
  studyArea = biomassMaps2011[["studyArea"]],
  studyAreaLarge = biomassMaps2011[["studyAreaLarge"]],
  studyAreaReporting = biomassMaps2011[["studyArea"]],
  sufficientLight = as.data.frame(biomassMaps2011[["sufficientLight"]]), ## biomassMaps2011 needs bugfix to qs
  terrainDT = as.data.table(fSsimDataPrep[["terrainDT"]]),
  vegComponentsToUse = fSsimDataPrep[["vegComponentsToUse"]]
)

dynamicParams <- list(
  Biomass_core = list(
    'sppEquivCol' = fSsimDataPrep@params$fireSense_dataPrepFit$sppEquivCol,
    'vegLeadingProportion' = 0, #apparently sppColorVect has no mixed color
    'sppEquivCol' = "RIA",
    gmcsGrowthLimits = c(33, 150),
    gmcsMortLimits = c(33, 300),
    plotOverstory = FALSE,
    growthAndMortalityDrivers = config::get('gmcsdriver'),
    keepClimateCols = TRUE,
    minCohortBiomass = 5,
    .plotInitialTime = NA,
    .plotInterval = 10
  ),
  Biomass_regeneration = list(
    "fireInitialTime" = times$start + 1 #regeneration is scheduled earlier, so it starts in 2012
  ),
  fireSense_dataPrepPredict = list(
    "fireTimeStep" = 1,
    "sppEquivCol" = simOutPreamble$sppEquivCol,
    "whichModulesToPrepare" = c("fireSense_IgnitionPredict",
                                "fireSense_EscapePredict",
                                "fireSense_SpreadPredict"),
    "missingLCCgroup" = fSsimDataPrep@params$fireSense_dataPrepFit$missingLCCgroup
  ),
  fireSense_ignitionPredict = list(),
  fireSense = list(
    "whichModulesToPrepare" = c("fireSense_IgnitionPredict", "fireSense_EscapePredict", "fireSense_SpreadPredict"),
    ".plotInterval" = NA,
    ".plotInitialTime" = NA,
    "plotIgnitions" = FALSE
  ),
  gmcsDataPrep = list(
    useHeight = TRUE
  )
)

outputObjs = c('cohortData',
               'pixelGroupMap',
               'burnMap')
saveTimes <- rep(seq(times$start, times$end, 10))
dynamicOutputs = data.frame(objectName = rep(outputObjs, times = length(saveTimes)),
                     saveTime = rep(saveTimes, each = length(outputObjs)),
                     eventPriority = 10)
#contains info on leading spp, only need once
dynamicOutputs <- rbind(dynamicOutputs, data.frame(objectName = c('summaryBySpecies'), saveTime = times$end, eventPriority = 10))
#contains results by ecoregion (not that important with no BECs..)
dynamicOutputs <- rbind(dynamicOutputs, data.frame(objectName = 'simulationOutput', saveTime = times$end, eventPriority = 10))




## TODO: delete unused objects, including previous simLists to free up memory

fsim <- file.path(Paths$outputPath, paste0(uniqueRunName, ".qs"))
mainSim <- simInitAndSpades(
  times = times,
  modules = dynamicModules,
  objects = dynamicObjects,
  outputs = dynamicOutputs,
  params = dynamicParams,
  paths = dynamicPaths
)

saveSimList(
  sim = mainSim,
  filename = fsim,
  #filebackedDir = dfSsimDataPrep,
  fileBackend = 2
)
#archive::archive_write_dir(archive = afSsimDataPrep, dir = dfSsimDataPrep)

resultsDir <- dynamicPaths$outputPath
#archive::archive_write_dir(archive = paste0(resultsDir, ".tar.gz"), dir = resultsDir) ## doesn't work
utils::tar(tarfile = paste0(resultsDir, ".tar.gz"), resultsDir, compression = "gzip")
gdrivePath <- paste0("results/", uniqueRunName)

retry(quote(drive_upload(media = paste0(resultsDir, ".tar.gz"),
                         path = (gdriveSims[["results"]]), name = uniqueRunName,
                         overwrite = TRUE)),
      retries = 5, exponentialDecayBase = 2)

# retry(quote(drive_upload(paste0(resultsDir, ".tar.gz"), path =  as_id(gdriveSims[["results"]]), overwrite = TRUE)),
#       retries = 5, exponentialDecayBase = 2)

SpaDES.project::notify_slack(runName = runName, channel = config::get("slackchannel"))
