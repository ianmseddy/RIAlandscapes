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
  sT[species == "Abie_las", longevity := 250]
  sT[species == "Betu_pap", longevity := 150]
  sT[, shadetolerance := as.numeric(shadetolerance)]
  sT[species == 'Pice_eng', shadetolerance := 2.5]
  sT[species == 'Pice_mar', shadetolerance := 2.5]
  sT[species == "Pice_mar", longevity := 225]
  sT[species == "Pice_gla", longevity := 300]
  sT[species == "Pinu_con", longevity := 300]
  sT[species == "Pice_eng", longevity := 350]
  return(sT)
}

if (!file.exists(file.path(dataPrepPaths$inputPath, "cohortDataFactorial_medium.rds"))){
  factCDcohort <- Cache(prepInputs,url = "https://drive.google.com/file/d/1NH7OpAnWtLyO8JVnhwdMJakOyapBnuBH/view?usp=sharing",
                        destinationPath = dataPrepPaths$inputPath, targetFile = "cohortDataFactorial_medium.rds",
                        fun = 'readRDS')
  factCDSpp <- Cache(prepInputs, url = "https://drive.google.com/file/d/1NH7OpAnWtLyO8JVnhwdMJakOyapBnuBH/view?usp=sharing",
                     targetFIle = "speciesTableFactorial_medium.rds",
                     destinationPath = dataPrepPaths$inputPath, fun = 'readRDS')
} else {
  factCDcohort <- readRDS(file.path(dataPrepPaths$inputPath, "cohortDataFactorial_medium.rds"))
  factCDSpp <- readRDS(file.path(dataPrepPaths$inputPath, "speciesTableFactorial_medium.rds"))
  # b2d737504b264f49
  # 978f2d1b32375d27 clear these cacheIDs from dataPrep if you need space
}


dataPrepParams2001 <- list(
  Biomass_borealDataPrep = list(
    "biomassModel" = quote(lme4::lmer(B ~ logAge * speciesCode + cover * speciesCode +
                                     (logAge + cover | ecoregionGroup))),
    "dataYear" = 2001,
    "exportModels" = "all",
    "forestedLCCClasses" = c(1:6, 20),
    "LCCClassesToReplaceNN" = numeric(0),
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
    "dataYear" = 2001,
    "sppEquivCol" = simOutPreamble$sppEquivCol,
    ".studyAreaName" = paste0(studyAreaName, 2001)
  ),
  Biomass_speciesParameters = list(
    "sppEquivCol" = simOutPreamble$sppEquivCol,
    " useHeight" = TRUE,
    speciesFittingApproach = "focal",
    constrainMortalityShape = list(
      "Abie_las" = c(20, 25),
      "Betu_pap" = c(20, 25),
      "Pice_eng" = c(20, 25),
      "Pice_gla" = c(20, 25),
      "Pice_mar" = c(20, 25),
      "Pinu_con" = c(20, 25),
      "Popu_tre" = c(20, 25)
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
                        "cohortDataFactorial" = factCDcohort,
                        "speciesTableFactorial" = factCDSpp,
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
    googledrive::drive_download(file = as_id(gdriveSims[["biomassMaps2001"]]), path = fbiomassMaps2001, overwrite = TRUE)
  }
  biomassMaps2001 <- loadSimList(fbiomassMaps2001)
} else {
  biomassMaps2001 <- Cache(
    simInitAndSpades,
    times = list(start = 2001, end = 2001),
    params = dataPrepParams2001,
    modules = list("Biomass_speciesData", "Biomass_borealDataPrep", "Biomass_speciesParameters"), ## TODO: separate to use different caches
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
  if (isTRUE(newGoogleIDs) | length(newGoogleIDs) == 0) {
    googledrive::drive_put(media = fbiomassMaps2001, path = gdriveURL, name = basename(fbiomassMaps2001), verbose = TRUE)
  } else {
    googledrive::drive_update(file = as_id(gdriveSims[["biomassMaps2001"]]), media = fbiomassMaps2001)
  }
}
