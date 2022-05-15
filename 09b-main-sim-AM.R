do.call(setPaths, dynamicPaths)

times <- list(start = 2011, end = 2101)
#fix some postProcessing issues
names(simOutPreamble$projectedATAstack) <- paste0("ATA", 2011:2100)
names(simOutPreamble$projectedCMIstack) <- paste0("CMI", 2011:2100)
names(simOutPreamble$projectedClimateLayers$MDC) <- paste0("year", 2011:2100)

####prep####
thlb <- prepInputs(url = "https://drive.google.com/file/d/1nmoTUX29gQtFUzZC0ZaROri7XFxrR6_5/view?usp=sharing",
                   studyArea = simOutPreamble$studyArea,
                   rasterToMatch = simOutPreamble$rasterToMatch,
                   destinationPath = dynamicPaths$inputPath)
tempDT <- data.table(thlb = getValues(thlb), pixelIndex = getValues(simOutPreamble$rasterToMatch))
tempDT[!is.na(pixelIndex), newTHLB := 0]
tempDT[thlb >= 0.8, newTHLB := 1]
thlb <- setValues(thlb, tempDT$newTHLB)
####modules####
dynamicModules <- list(
  "simpleHarvest",
  "gmcsDataPrep",
  "LandR_reforestation",
  "assistedMigrationBC",
  "fireSense_dataPrepPredict",
  "fireSense",
  "fireSense_IgnitionPredict",
  "fireSense_EscapePredict",
  "fireSense_SpreadPredict",
  "Biomass_core",
  "Biomass_regeneration")

####objects####
dynamicObjects <- list(
  ATAstack = simOutPreamble[["projectedATAstack"]],
  biomassMap = biomassMaps2011$biomassMap,
  cceArgs = list(quote(CMI),
                 quote(ATA),
                 quote(CMInormal),
                 quote(mcsModel),
                 quote(gcsModel),
                 quote(transferTable),
                 quote(ecoregionMap),
                 quote(currentBEC),
                 quote(BECkey)),
  CMIstack = simOutPreamble[["projectedCMIstack"]],
  CMInormal = simOutPreamble[["CMInormal"]],
  cohortData = as.data.table(biomassMaps2011$cohortData),
  climateComponentsTouse = fSsimDataPrep[["climateComponentsToUse"]],
  ecoregionRst = biomassMaps2011[["ecoregionRst"]],
  ecoregion = as.data.table(biomassMaps2011[["ecoregion"]]),
  ecoregionMap = biomassMaps2011[["ecoregionMap"]],
  flammableRTM = fSsimDataPrep[["flammableRTM"]],
  fireSense_IgnitionFitted = ignitionOut[["fireSense_IgnitionFitted"]],
  fireSense_EscapeFitted = escapeOut[["fireSense_EscapeFitted"]],
  fireSense_SpreadFitted = spreadOut[["fireSense_SpreadFitted"]],
  covMinMax_spread = as.data.table(spreadOut[["covMinMax_spread"]]),
  covMinMax_ignition = as.data.table(ignitionOut[["covMinMax_ignition"]]),
  nonForest_timeSinceDisturbance = fSsimDataPrep[["nonForest_timeSinceDisturbance2011"]],
  nonForestedLCCGroups = fSsimDataPrep$nonForestedLCCGroups,
  minRelativeB = as.data.table(biomassMaps2011[["minRelativeB"]]), ## biomassMaps2011 needs bugfix to qs
  pixelGroupMap = biomassMaps2011$pixelGroupMap,
  projectedClimateLayers = simOutPreamble[["projectedClimateLayers"]],
  rasterToMatch = simOutPreamble$rasterToMatch,
  rstLCC = biomassMaps2011$rstLCC,
  species = as.data.table(biomassMaps2011[["species"]]),
  speciesLayers = biomassMaps2011[["speciesLayers"]],
  speciesEcoregion = as.data.table(biomassMaps2011$speciesEcoregion),
  sppColorVect = LandR::sppColors(sppEquiv = simOutPreamble$sppEquiv,
                                  sppEquivCol = simOutPreamble$sppEquivCol,
                                  palette = 'Pastel1'),
  sppEquiv = as.data.table(fSsimDataPrep[["sppEquiv"]]), ## biomassMaps2011 needs bugfix to qs
  studyArea = simOutPreamble$studyArea,
  studyAreaPSP = simOutPreamble[["studyAreaPSP"]],
  studyAreaReporting = simOutPreamble[["studyAreaReporting"]],
  sufficientLight = as.data.frame(biomassMaps2011[["sufficientLight"]]), ## biomassMaps2011 needs bugfix to qs
  thlb = thlb,
  vegComponentsToUse = fSsimDataPrep[["vegComponentsToUse"]]
)

####params ####
cohortCols <- c("pixelGroup", "speciesCode", "age", "Provenance", "planted")
dynamicParams <- list(
  assistedMigrationBC = list(
    cohortDefinitionCols = cohortCols,
    doAssistedMigration = AMscenario,
    sppEquivCol = fSsimDataPrep@params$fireSense_dataPrepFit$sppEquivCol
  ),
  Biomass_borealDataPrep = dataPrepParams2011$Biomass_borealDataPrep,
  Biomass_core = list(
    'sppEquivCol' = fSsimDataPrep@params$fireSense_dataPrepFit$sppEquivCol,
    'vegLeadingProportion' = 0, #apparently sppColorVect has no mixed color
    'sppEquivCol' = "RIA",
    .useCache = FALSE,
    gmcsGrowthLimits = c(33, 150),
    gmcsMortLimits = c(100, 100),
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
    "ignitionFuelClassCol" = "ignitionFuelClass",
    "spreadFuelClassCol" = "spreadFuelClass",
    "whichModulesToPrepare" = c("fireSense_IgnitionPredict",
                                "fireSense_EscapePredict",
                                "fireSense_SpreadPredict"),
    "missingLCCgroup" = fSsimDataPrep@params$fireSense_dataPrepFit$missingLCCgroup
  ),
  fireSense_IgnitionPredict = list(),
  fireSense_SpreadPredict = list("coefTouse" = "meanCoef"),
  fireSense = list(
    "whichModulesToPrepare" = c("fireSense_IgnitionPredict", "fireSense_EscapePredict", "fireSense_SpreadPredict"),
    ".plotInterval" = NA,
    ".plotInitialTime" = NA
  ),
  gmcsDataPrep = list(
    useHeight = TRUE,
    useCache = c(".Init", ".inputObjects")
  ),
  LandR_reforestation = list(
    cohortDefinitionCols = cohortCols,
    trackPlanting = TRUE,
    initialB = 20
  ),
  simpleHarvest = list(
    minAgesToHarvest = 70
  )
)
#####outputObjs####
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


#####simulation
times <- list(start = 2011, end = 2101)

options("LandR.assertions" = TRUE) #the testing of sumB alone adds 30 seconds every year.

fsim <- file.path(Paths$outputPath, paste0(uniqueRunName, ".qs"))
dynamicObjects$cohortData$planted <- FALSE #init assertCohortData fails without this column - must change assertion
dynamicObjects$cohortData$planted <- NA #init assertCohortData fails without this column - must change assertion
dynamicObjects$cohortData$Provenance <- NA #init assertCohortData in Biomass_core fails without this column
mainSim <- simInitAndSpades(
  times = times,
  modules = dynamicModules,
  loadOrder = unlist(dynamicModules), #make sure AM and LandR_reforestation are first
  objects = dynamicObjects,
  outputs = dynamicOutputs,
  params = dynamicParams,
  paths = dynamicPaths
)

mainSim$CMIstack <- NULL
mainSim$ATAstack <- NULL
mainSim$projectedClimateLayers <- NULL


####save####
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
       subtitle = paste(GCM, GCM))

gEscapes <- ggplot(data = dat, aes(x = year, y = nFires, col = stat)) +
  geom_point() +
  # geom_smooth() +
  ylim(0, max(dat$nFires) * 1.2) +
  labs(y = "number of escaped fires",
       title = studyAreaName,
       subtitle = paste(GCM, GCM))

gBurns <- ggplot(data = dat, aes(x = year, y = sumBurn, col = stat)) +
  geom_point() +
  # geom_smooth() +
  ylim(0, max(dat$sumBurn) * 1.1) +
  labs(y = "cumulative annual burn (ha)",
       title = paste(studyAreaName, "rep", Rep),
       subtitle = paste(GCM, GCM))


ggsave(plot = gIgnitions, filename = file.path(outputPath(mainSim), "figures", "simulated_Ignitions.png"))
ggsave(plot = gEscapes, filename = file.path(outputPath(mainSim), "figures", "simulated_Escapes.png"))
ggsave(plot = gBurns, filename = file.path(outputPath(mainSim), "figures", "simulated_burnArea.png"))

compMDC <- fireSenseUtils::compareMDC(historicalMDC = fSsimDataPrep$historicalClimateRasters$MDC,
                                      projectedMDC = simOutPreamble$projectedClimateLayers$MDC,
                                      flammableRTM = mainSim$flammableRTM)
ggsave(compMDC, filename = file.path(outputPath(mainSim), "figures", "MDCcomparison.png"))

#archive::archive_write_dir(archive = afSsimDataPrep, dir = dfSsimDataPrep)
resultsDir <- dynamicPaths$outputPath
utils::tar(tarfile = paste0(resultsDir, ".tar.gz"), resultsDir, compression = "gzip")
gdrivePath <- paste0("results/", uniqueRunName)

retry(quote(drive_upload(media = paste0(resultsDir, ".tar.gz"),
                         path = (gdriveSims[["results"]]), name = uniqueRunName,
                         overwrite = TRUE)),
      retries = 5, exponentialDecayBase = 2)

temp <- data.table("name" = uniqueRunName,
                   "path" = dat[name == uniqueRunName,]$id,
                   "haBurned" = round(sum(mainSim$burnSummary$areaBurnedHa), digits = 0),
                   "meanBiomass" = round(mean(mainSim$simulatedBiomassMap[], na.rm = TRUE)/100, digits = 2))
write.csv(temp, file.path(outputPath(mainSim), "quickStats.csv"))

#this needs to happen
#better track what's been run, for my sanity - will still ahve to merge across machines
allRunInfo2 <- fread("AMRunInfo.csv")

allRunInfo2[GCM == runInfo$GCM &
              SSP == runInfo$SSP &
              gmcsDriver == runInfo$gmcsDriver &
              studyArea == runInfo$studyArea &
              Replicates == runInfo$Replicates &
              AMscenario == runInfo$AMscenario &
              simulateAM == runInfo$simulateAM,
            complete := TRUE]
write.csv(allRunInfo2, "AMRunInfo.csv", row.names = FALSE)

rm(dat)
amc::.gc()

