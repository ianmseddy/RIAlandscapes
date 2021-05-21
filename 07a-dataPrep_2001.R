#this script will run Biomass_borealDataPrep + Biomass_speciesData twice, to generate some objects for fitting
do.call(setPaths, dataPrepPaths)

source("05-google-ids.R")
newGoogleIDs <- gdriveSims[["biomassMaps2001"]] == ""

dataPrep <- list(
  subsetDataBiomassModel = 50,
  pixelGroupAgeClass = 10,
  successionTimeStep = 10,
  useCache = TRUE
)

RIASppUpdate <- function(sT) {
  sT[species == "Abie_las", longevity := 300]
  sT[species == "Betu_pap", longevity := 150]
  sT[, shadetolerance := as.numeric(shadetolerance)]
  sT[species == 'Pice_eng', shadetolerance := 2.5]
  sT[species == 'Pice_mar', shadetolerance := 2.5]
  return(sT)
}


dataPrepParams2001 <- list(
  Biomass_borealDataPrep = list(
    "biomassModel" = quote(lme4::lmer(B ~ logAge * speciesCode + cover * speciesCode +
                                     (logAge + cover | ecoregionGroup))),
    "exportModels" = "all",
    "forestedLCCClasses" = c(1:6, 99),
    "LCCClassesToReplaceNN" =  c(99), #due to a bug, you need a dummy class, or at least did...
    "pixelGroupAgeClass" = dataPrep$pixelGroupAgeClass,
    "speciesUpdateFunction" = list(
      quote(LandR::speciesTableUpdate(sim$species, sim$speciesTable, sim$sppEquiv, P(sim)$sppEquivCol)),
      quote(LandR::updateSpeciesTable(sim$species, sim$speciesParams)),
      quote(RIASppUpdate(sT = sim$species))
    ),
    "pixelGroupBiomassClass" = 500, #this is 5 Mg/ha
    "sppEquivCol" = simOutPreamble$sppEquivCol,
    "subsetDataBiomassModel" = dataPrep$subsetDataBiomassModel,
    "useCloudCacheForStats" = useCloudCache,
    ".studyAreaName" = paste0(studyAreaName, 2001),
    ".useCache" = c(".inputObjects", "init")
  ),
  Biomass_speciesData = list(
    "sppEquivCol" = simOutPreamble$sppEquivCol,
    ".studyAreaName" = paste0(studyAreaName, 2001)
  ),
  Biomass_speciesParameters = list(
    "sppEquivCol" = simOutPreamble$sppEquivCol,
    " useHeight" = FALSE,
    "GAMMknots" = list(
      "Abie_las" = 3,
      "Betu_pap" = 3,
      "Pice_eng" = 4,
      "Pice_gla" = 3,
      "Pice_mar" = 4,
      "Pinu_con" = 4,
      "Popu_tre" = 4
    ),
    constrainGrowthCurve = list(
      "Abie_las" = c(0.3, .7),
      "Betu_pap" = c(0, 0.3),
      "Pice_eng" = c(0.3, .7),
      "Pice_gla" = c(0.3, .7),
      "Pice_mar" = c(0.4, 1),
      "Pinu_con" = c(0.3, .7),
      "Popu_tre" = c(0.4, 1)
    ),
    constrainMortalityShape = list(
      "Abie_las" = c(15, 25),
      "Betu_pap" = c(15, 20),
      "Pice_eng" = c(15, 25),
      "Pice_gla" = c(15, 25),
      "Pice_mar" = c(15, 25),
      "Pinu_con" = c(15, 25),
      "Popu_tre" = c(20, 25)
    ),
    quantileAgeSubset = list(
      "Abie_las" = 95, #N = 250 ''
      "Betu_pap" = 95, #N = 96
      "Pice_eng" = 95, #N = 130
      "Pice_gla" = 95, #N = 1849
      "Pice_mar" = 95, #N = 785
      "Pinu_con" = 97, # N = 3172
      "Popu_tre" = 99 # N = 1997
    ))
)

dataPrepOutputs2001 <- data.frame(
  objectName = c("cohortData",
                 "pixelGroupMap",
                 "speciesLayers",
                 "standAgeMap",
                 "rawBiomassMap"),
  saveTime = 2001,
  file = paste0(studyAreaName, "_",
                c("cohortData2001_fireSense.rds",
                  "pixelGroupMap2001_fireSense.rds",
                  "speciesLayers2001_fireSense.rds",
                  "standAgeMap2001_borealDataPrep.rds",
                  "rawBiomassMap2001_borealDataPrep.rds"))
)

dataPrepObjects <- list("ecoregionRst" = simOutPreamble$ecoregionRst,
                        "rasterToMatch" = simOutPreamble$rasterToMatch,
                        "rasterToMatchLarge" = simOutPreamble$rasterToMatchLarge,
                        "rstLCC" = simOutPreamble$rstLCC2010,
                        "sppColorVect" = simOutPreamble$sppColorVect,
                        "sppEquiv" = simOutPreamble$sppEquiv,
                        "studyArea" = simOutPreamble$studyArea,
                        "studyAreaLarge" = simOutPreamble$studyAreaLarge,
                        "studyAreaReporting" = simOutPreamble$studyAreaReporting)

fbiomassMaps2001 <- file.path(Paths$outputPath, paste0("biomassMaps2001_", studyAreaName, ".qs"))
if (isTRUE(usePrerun)) {
  if (!file.exists(fbiomassMaps2001)) {
    googledrive::drive_download(file = as_id(gdriveSims[["biomassMaps2001"]]), path = fbiomassMaps2001)
  }
  biomassMaps2001 <- loadSimList(fbiomassMaps2001)
} else {
  biomassMaps2001 <- Cache(
    simInitAndSpades,
    times = list(start = 2001, end = 2001),
    params = dataPrepParams2001,
    modules = list("PSP_Clean", "Biomass_speciesData",
                   "Biomass_borealDataPrep", "Biomass_speciesParameters"), ## TODO: separate to use different caches
    objects = dataPrepObjects,
    paths = getPaths(),
    loadOrder = c("PSP_Clean", "Biomass_speciesData",
                     "Biomass_borealDataPrep", "Biomass_speciesParameters"),
    outputs = dataPrepOutputs2001,
    .plots = NA,
    useCloud = useCloudCache,
    cloudFolderID = cloudCacheFolderID,
    userTags = c("dataPrep2001", studyAreaName)
  )
  saveSimList(
    sim = biomassMaps2001,
    filename = fbiomassMaps2001,
    # filebackedDir = dbiomassMaps2001,
    fileBackend = 2
  )
  if (isTRUE(newGoogleIDs)) {
    googledrive::drive_put(media = fbiomassMaps2001, path = gdriveURL, name = basename(fbiomassMaps2001), verbose = TRUE)
  } else {
    googledrive::drive_update(file = as_id(gdriveSims[["biomassMaps2001"]]), media = fbiomassMaps2001)
  }
}
