do.call(setPaths, dynamicPaths)

newStudyArea <- prepInputs(url = 'https://drive.google.com/file/d/1LAXjmuaCt0xOWP-Nmll3xfRqCq-NbJP-/view?usp=sharing',
                           destinationPath = dynamicPaths$inputPath) %>%
  spTransform(., CRSobj = crs(simOutPreamble$studyAreaReporting))
studyArea <- postProcess(newStudyArea, studyArea = simOutPreamble$studyAreaReporting)

#clean up some problems
names(simOutPreamble$ATAstack) <- paste0("ATA", 2011:2100)
names(simOutPreamble$CMIstack) <- paste0("CMI", 2011:2100)
names(simOutPreamble$projectedClimateLayers$MDC) <- paste0("year", 2011:2100)

times <- list(start = 2011, end = 2101)

#for now - there is a problem with dpf and spread
rasterToMatch <- postProcess(simOutPreamble$rasterToMatch, studyArea = studyArea)

thlb <- prepInputs(url = "https://drive.google.com/file/d/1nmoTUX29gQtFUzZC0ZaROri7XFxrR6_5/view?usp=sharing",
                   studyArea = studyArea,
                   rasterToMatch = rasterToMatch,
                   destinationPath = dynamicPaths$inputPath)
mainObjects <- list(
  "ecoregionRst" = simOutPreamble$ecoregionRst,
  "flammableRTM" = fSsimDataPrep$flammableRTM,
  "rstLCC" = fSsimDataPrep$rstLCC,
  "speciesLayers" = biomassMaps2011$speciesLayers,
  "biomassMap" = biomassMaps2011$biomassMap,
  "standAgeMap" = biomassMaps2011$standAgeMap,
  "nonForest_timeSinceDisturbance2011" = fSsimDataPrep$nonForest_timeSinceDisturbance2011
)
mainObjects <- lapply(mainObjects, postProcess, studyArea = studyArea, rasterToMatch = rasterToMatch)

dynamicModules <- list(
  "LandR_reforestation",
  "assistedMigrationBC",
  "simpleHarvest",
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
  cceArgs = list(quote(CMI),
                 quote(ATA),
                 quote(CMInormal),
                 quote(mcsModel),
                 quote(gcsModel),
                 quote(transferTable),
                 quote(ecoregionMap),
                 quote(currentBEC),
                 quote(BECkey)),
  ATAstack = simOutPreamble[["ATAstack"]],
  CMIstack = simOutPreamble[["CMIstack"]],
  CMInormal = simOutPreamble[["CMInormal"]],
  PSPmeasure = as.data.table(biomassMaps2011[["PSPmeasure"]]),
  PSPplot = as.data.table(biomassMaps2011[["PSPplot"]]),
  PSPgis = biomassMaps2011[["PSPgis"]],
  biomassMap = mainObjects$biomassMap,
  climateComponentsTouse = fSsimDataPrep[["climateComponentsToUse"]],
  ecoregionRst = mainObjects[["ecoregionRst"]],
  flammableRTM = mainObjects[["flammableRTM"]],
  fireSense_IgnitionFitted = ignitionOut[["fireSense_IgnitionFitted"]],
  fireSense_EscapeFitted = escapeOut[["fireSense_EscapeFitted"]],
  fireSense_SpreadFitted = spreadOut[["fireSense_SpreadFitted"]],
  covMinMax_spread = as.data.table(spreadOut[["covMinMax_spread"]]),
  covMinMax_ignition = as.data.table(ignitionOut[["covMinMax_ignition"]]),
  nonForest_timeSinceDisturbance = mainObjects[["nonForest_timeSinceDisturbance2011"]],
  nonForestedLCCGroups = fSsimDataPrep$nonForestedLCCGroups,
  minRelativeB = as.data.table(biomassMaps2011[["minRelativeB"]]), ## biomassMaps2011 needs bugfix to qs
  PCAveg = fSsimDataPrep[["PCAveg"]],
  projectedClimateLayers = simOutPreamble[["projectedClimateLayers"]],
  rasterToMatch = rasterToMatch,
  rstLCC = mainObjects$rstLCC,
  species = as.data.table(biomassMaps2011[["species"]]),
  speciesLayers = mainObjects[["speciesLayers"]], ## TODO: does Biomass_core actually need this?
  sppColorVect = LandR::sppColors(sppEquiv = simOutPreamble$sppEquiv,
                                  sppEquivCol = simOutPreamble$sppEquivCol,
                                  palette = 'Pastel1'),
  sppEquiv = as.data.table(fSsimDataPrep[["sppEquiv"]]), ## biomassMaps2011 needs bugfix to qs
  studyArea = studyArea,
  sufficientLight = as.data.frame(biomassMaps2011[["sufficientLight"]]), ## biomassMaps2011 needs bugfix to qs
  thlb = thlb,
  vegComponentsToUse = fSsimDataPrep[["vegComponentsToUse"]]
)
cohortCols <- c("pixelGroup", "speciesCode", "age", "Provenance", "planted")

dynamicParams <- list(
  assistedMigrationBC = list(
    doAssistedMigration = TRUE,
    trackPlanting = TRUE,
    trackPlantedCohorts = FALSE,
    sppEquivCol = fSsimDataPrep@params$fireSense_dataPrepFit$sppEquivCol
  ),
  Biomass_core = list(
    'sppEquivCol' = fSsimDataPrep@params$fireSense_dataPrepFit$sppEquivCol,
    'vegLeadingProportion' = 0, #apparently sppColorVect has no mixed color
    'sppEquivCol' = "RIA",
    gmcsGrowthLimits = c(33, 150),
    gmcsMortLimits = c(33, 300),
    plotOverstory = FALSE,
    growthAndMortalityDrivers = "LandRCSAM",
    cohortDefinitionCols = cohortCols,
    keepClimateCols = TRUE,
    minCohortBiomass = 5,
    .plotInitialTime = NA,
    .plotInterval = 10
  ),
  Biomass_regeneration = list(
    "fireInitialTime" = times$start + 1, #regeneration is scheduled earlier, so it starts in 2012
    cohortDefinitionCols = cohortCols
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
  ),
  LandR_reforestation = list(
    cohortDefinitionCols = cohortCols,
    trackPlanting = TRUE
  ),
  simpleHarvest = list(
    minAgesToHarvest = 70
  )
)

outputObjs = c('cohortData',
               'pixelGroupMap',
               'burnMap',
               'simulatedBiomassMap')

saveTimes <- rep(seq(times$start, times$end, 10))
dynamicOutputs = data.frame(objectName = rep(outputObjs, times = length(saveTimes)),
                     saveTime = rep(saveTimes, each = length(outputObjs)),
                     eventPriority = 10)
#contains info on leading spp, only need once
dynamicOutputs <- rbind(dynamicOutputs, data.frame(objectName = c('summaryBySpecies'),
                                                   saveTime = times$end, eventPriority = 10))

#contains results by ecoregion (not that important with no BECs..)
dynamicOutputs <- rbind(dynamicOutputs, data.frame(objectName = 'simulationOutput',
                                                   saveTime = times$end, eventPriority = 10))


times <- list(start = 2011, end = 2101)

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
utils::tar(tarfile = paste0(resultsDir, ".tar.gz"), resultsDir, compression = "gzip")
gdrivePath <- paste0("results/", uniqueRunName)

retry(quote(drive_upload(media = paste0(resultsDir, ".tar.gz"),
                         path = (gdriveSims[["results"]]), name = uniqueRunName,
                         overwrite = TRUE)),
      retries = 5, exponentialDecayBase = 2)
