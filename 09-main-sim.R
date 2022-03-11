do.call(setPaths, dynamicPaths)

#no point saving the simList when the climate runs will alll be different..
if (!compareCRS(simOutPreamble$studyArea, simOutPreamble$rasterToMatch)){
  simOutPreamble$studyArea <- sf::st_transform(simOutPreamble$studyArea, crs = crs(simOutPreamble$rasterToMatch))
  simOutPreamble$studyAreaReporting <- sf::st_transform(simOutPreamble$studyAreaReporting, crs = crs(simOutPreamble$rasterToMatch))
  simOutPreamble$studyAreaLarge <- sf::st_transform(simOutPreamble$studyAreaLarge, crs = crs(simOutPreamble$rasterToMatch))
}

if ("sf" %in% class(simOutPreamble$studyAreaPSP)){
  simOutPreamble$studyAreaPSP <- st_zm(simOutPreamble$studyAreaPSP)
  simOutPreamble$studyAreaPSP <- sf::as_Spatial(simOutPreamble$studyAreaPSP)
}
if ("sf" %in% class(simOutPreamble$studyArea)){
  simOutPreamble$studyArea <- sf::as_Spatial(simOutPreamble$studyArea)
  simOutPreamble$studyAreaReporting <- sf::as_Spatial(simOutPreamble$studyAreaReporting)
  simOutPreamble$studyAreaLarge <- sf::as_Spatial(simOutPreamble$studyAreaLarge)
}

#clean up some problems
if (GCM != "historical") {
  names(simOutPreamble$projectedATAstack) <- paste0("ATA", 2011:2100)
  names(simOutPreamble$projectedCMIstack) <- paste0("CMI", 2011:2100)
  names(simOutPreamble$projectedClimateLayers$MDC) <- paste0("year", 2011:2100)
}
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

if (is.null(simOutPreamble$sppColorVect)){
  sppColorVect <-brewer.pal(name = 'Paired', n = length(unique(simOutPreamble$sppEquiv$RIA)) + 1)
  sppNames <- unique(simOutPreamble$sppEquiv$RIA)
  names(sppColorVect) <- c(sppNames, "mixed")
} else {
  sppColorVect <- simOutPreamble$sppColorVect
}


#if using "historical" fire data, the random sampling is cached - so resample the years
if (GCM == "historical") {
  projectedMDCyears <- sample(names(simOutPreamble$historicalClimateRasters$MDC),
                              size = 90, replace = TRUE)
  projectedMDC <- lapply(projectedMDCyears, FUN = function(x){
    simOutPreamble$historicalClimateRasters$MDC[[x]]
  })
  names(projectedMDC) <- paste0("year", 2011:2100)
  simOutPreamble$projectedClimateLayers <- list("MDC" = stack(projectedMDC))
  rm(projectedMDC)
}

dynamicObjects <- list(
  studyAreaPSP = simOutPreamble[["studyAreaPSP"]],
  ATAstack = simOutPreamble[["projectedATAstack"]],
  CMIstack = simOutPreamble[["projectedCMIstack"]],
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
  pixelGroupMap = biomassMaps2011[["pixelGroupMap"]],
  projectedClimateLayers = simOutPreamble[["projectedClimateLayers"]],
  rasterToMatch = biomassMaps2011[["rasterToMatch"]],
  rasterToMatchLarge = biomassMaps2011[["rasterToMatchLarge"]],
  species = as.data.table(biomassMaps2011[["species"]]),
  speciesEcoregion = as.data.table(biomassMaps2011[["speciesEcoregion"]]), ## biomassMaps2011 needs bugfix to qs
  speciesLayers = biomassMaps2011[["speciesLayers"]], ## TODO: does Biomass_core actually need this?
  sppColorVect = sppColorVect,
  sppEquiv = as.data.table(fSsimDataPrep[["sppEquiv"]]), ## #use fSsimdataPrep in case fuelClass changes
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
    .studyAreaName = studyAreaName,
    gmcsGrowthLimits = c(33, 150),
    gmcsMortLimits = c(100, 100),
    plotOverstory = FALSE,
    growthAndMortalityDrivers = gmcsDriver,
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
    "ignitionFuelClassCol" = "ignitionFuelClass",
    "sppEquivCol" = simOutPreamble$sppEquivCol,
    "spreadFuelClassCol" = "spreadFuelClass",
    "whichModulesToPrepare" = c("fireSense_IgnitionPredict",
                                "fireSense_EscapePredict",
                                "fireSense_SpreadPredict"),
    "missingLCCgroup" = fSsimDataPrep@params$fireSense_dataPrepFit$missingLCCgroup
  ),
  fireSense_IgnitionPredict = list(),
  fireSense_SpreadPredict = list(
    "coefToUse" = "meanCoef" #for WCB - mean cof is quite a bit different for deciduous.
  ),
  fireSense = list(
    "whichModulesToPrepare" = c("fireSense_IgnitionPredict", "fireSense_EscapePredict", "fireSense_SpreadPredict"),
    ".plotInterval" = NA,
    ".plotInitialTime" = NA
  ),
  gmcsDataPrep = list(
    useHeight = TRUE,
    useCache = c("Init", ".inputObjects")
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
dynamicOutputs <- rbind(dynamicOutputs, data.frame(objectName = c('summaryBySpecies'), saveTime = times$end, eventPriority = 10))
#contains results by ecoregion (not that important with no BECs..)
dynamicOutputs <- rbind(dynamicOutputs, data.frame(objectName = 'simulationOutput', saveTime = times$end, eventPriority = 10))




## TODO: delete unused objects, including previous simLists to free up memory
fsim <- file.path(Paths$outputPath, paste0(uniqueRunName, ".qs"))
if (GCM != simOutPreamble@params$RIAlandscapes_studyArea$GCM |
    SSP != simOutPreamble@params$RIAlandscapes_studyArea$SSP) {
  stop("mismatched gcms")
}

#a simple check
LandR::assertCohortData(cohortData = dynamicObjects$cohortData,
                        pixelGroupMap = dynamicObjects$pixelGroupMap,
                        doAssertion = TRUE)

if (gmcsDriver == "LandR"){
  dynamicModules <- dynamicModules[dynamicModules != "gmcsDataPrep"]
}

#safety
if (simulateAM == TRUE | AMscenario == TRUE) {
  stop("please run 09b-main.sim for AM")
}

mainSim <- simInitAndSpades(
  times = times,
  modules = dynamicModules,
  objects = dynamicObjects,
  outputs = dynamicOutputs,
  params = dynamicParams,
  paths = dynamicPaths
)

mainSim$CMIstack <- NULL
mainSim$ATAstack <- NULL
mainSim$projectedClimateLayers <- NULL

saveSimList(
  sim = mainSim,
  filename = fsim,
  #filebackedDir = dfSsimDataPrep,
  fileBackend = 2
)
#archive::archive_write_dir(archive = afSsimDataPrep, dir = dfSsimDataPrep)
#some post-run analysis
historicalBurns <- do.call(what = rbind, args = fSsimDataPrep$firePolys)
historicalBurns <- as.data.table(historicalBurns@data)

#restrict to escapes only, but sum poly_ha for burns
historicalBurns <- historicalBurns[SIZE_HA > 6.25, .(sumBurn = sum(as.numeric(POLY_HA)), nFires = .N), .(YEAR)]
setnames(historicalBurns, "YEAR", "year")
historicalBurns[, stat := 'observed']
projectedEscapes <- mainSim$burnSummary[areaBurnedHa > 6.25, .(nFires = .N), .(year)]
projectedBurns <- mainSim$burnSummary[, .(sumBurn = sum(areaBurnedHa)), .(year)]
projectedBurns <- projectedBurns[projectedEscapes, on = c("year")]
projectedBurns[, stat := "projected"]
dat <- rbind(projectedBurns, historicalBurns)

trueHistoricalIgs <- as.data.table(fSsimDataPrep$ignitionFirePoints) %>%
  .[, .N, .(YEAR)] %>%
  setnames(., "YEAR", "year") %>%
  .[, stat := "observed"] %>%
  .[, year := as.numeric(year)]
projectedIgs <- mainSim$burnSummary[, .N, .(year)] %>%
  .[, stat := "projected"]
dat2 <- rbind(trueHistoricalIgs, projectedIgs)

gIgnitions <- ggplot(data = dat2, aes(x = year, y = N, col = stat)) +
  geom_point() +
  # geom_smooth() +
  ylim(0, max(dat2$N) * 1.2) +
  labs(y = "number of ignitions",
       title = studyAreaName,
       subtitle = paste(GCM, SSP))

gEscapes <- ggplot(data = dat, aes(x = year, y = nFires, col = stat)) +
  geom_point() +
  # geom_smooth() +
  ylim(0, max(dat$nFires) * 1.2) +
  labs(y = "number of escaped fires",
       title = studyAreaName,
       subtitle = paste(GCM, SSP))

gBurns <- ggplot(data = dat, aes(x = year, y = sumBurn, col = stat)) +
  geom_point() +
  # geom_smooth() +
  ylim(0, max(dat$sumBurn) * 1.1) +
  labs(y = "cumulative annual burn (ha)",
       title = paste(studyAreaName, "rep", Replicate),
       subtitle = paste(GCM, SSP))


ggsave(plot = gIgnitions, filename = file.path(outputPath(mainSim), "figures", "simulated_Ignitions.png"))
ggsave(plot = gEscapes, filename = file.path(outputPath(mainSim), "figures", "simulated_Escapes.png"))
ggsave(plot = gBurns, filename = file.path(outputPath(mainSim), "figures", "simulated_burnArea.png"))

compMDC <- fireSenseUtils::compareMDC(historicalMDC = fSsimDataPrep$historicalClimateRasters$MDC,
                                      projectedMDC = simOutPreamble$projectedClimateLayers$MDC,
                                      flammableRTM = mainSim$flammableRTM)
ggsave(compMDC, filename = file.path(outputPath(mainSim), "figures", "MDCcomparison.png"))

resultsDir <- dynamicPaths$outputPath
#archive::archive_write_dir(archive = paste0(resultsDir, ".tar.gz"), dir = resultsDir) ## doesn't work
utils::tar(tarfile = paste0(resultsDir, ".tar.gz"), resultsDir, compression = "gzip")
gdrivePath <- paste0("results/", uniqueRunName)

retry(quote(drive_upload(media = paste0(resultsDir, ".tar.gz"),
                         path = as_id(gdriveSims[["results"]]),
                         name = uniqueRunName,
                         overwrite = TRUE)),
      retries = 5, exponentialDecayBase = 2)

# retry(quote(drive_upload(paste0(resultsDir, ".tar.gz"), path =  as_id(gdriveSims[["results"]]), overwrite = TRUE)),
#       retries = 5, exponentialDecayBase = 2)

SpaDES.project::notify_slack(runName = runName, channel = config::get("slackchannel"))

temp <- data.table("meanBiomass" = round(mean(mainSim$simulatedBiomassMap[], na.rm = TRUE)/100, digits = 2),
                   "haBurned" = sum(mainSim$burnSummary$areaBurnedHa))
write.csv(temp, file.path(outputPath(temp), "quickStats.csv"))
