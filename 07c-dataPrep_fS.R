## NOTE: 07a-dataPrep_2001.R and 07b-dataPrep_2011.R need to be run before this script

source("05-google-ids.R")
newGoogleIDs <- gdriveSims[["fSsimDataPrep_fuelClass"]] == ""

fSdataPrepParams <- list(
  "fireSense_dataPrepFit" = list(
    ".studyAreaName" = studyAreaName,
    "fireYears" = 2001:2019, # this will be fixed to post kNN only
    "missingLCCgroup" = "nf_hf",
    "sppEquivCol" = simOutPreamble$sppEquivCol,
    "useCentroids" = TRUE,
    "forestedLCC" = c(1:6, 20),
    ".useCache" = ".inputObjects",
    "ignitionFuelClassCol" = 'ignitionFuelClass',
    'spreadFuelClassCol' = 'spreadFuelClass',
    "whichModulesToPrepare" = c("fireSense_IgnitionFit", "fireSense_EscapeFit", "fireSense_SpreadFit"),
    "usePCA" = FALSE
  )
)

flammableMap <- LandR::defineFlammable(LandCoverClassifiedMap = simOutPreamble$rstLCC2010,
                                       nonFlammClasses = c(13, 16, 17, 18, 19),
                                       mask = simOutPreamble$rasterToMatchLarge)

# simOutPreamble$rasterToMatch <- raster::mask(simOutPreamble$rasterToMatch, simOutPreamble$studyArea)
fSdataPrepObjects <- list(
  "flammableRTM" = flammableMap,
  "cohortData2001" = as.data.table(biomassMaps2001[["cohortData"]]),
  "cohortData2011" = as.data.table(biomassMaps2011[["cohortData"]]),
  "historicalClimateRasters" = simOutPreamble[["historicalClimateRasters"]],
  "nonForestedLCCGroups" = list(
    "nf_hf" = c(8, 10),#shrubland, grassland, wetland
    "nf_lf" = c(11, 12, 14, 15) #shrub-lichen-moss + cropland. 2 barren classes are nonflam
  ),
  "pixelGroupMap2001" = biomassMaps2001[["pixelGroupMap"]],
  "pixelGroupMap2011" = biomassMaps2011[["pixelGroupMap"]],
  "rasterToMatch" = simOutPreamble[["rasterToMatch"]], #this needs to be masked
  "rstLCC" = biomassMaps2001[["rstLCC"]], #this won't work
  "sppEquiv" = simOutPreamble$sppEquiv,
  "standAgeMap2001" = biomassMaps2001[["standAgeMap"]],
  "standAgeMap2011" = biomassMaps2011[["standAgeMap"]],
  "studyArea" = simOutPreamble[["studyArea"]]
)

invisible(replicate(10, gc()))

ffSsimDataPrep <- file.path(Paths$outputPath, paste0("fSsimDataPrep_fuelClass_", studyAreaName, ".qs"))
if (isTRUE(usePrerun)) {
  if (!file.exists(ffSsimDataPrep)) {
    googledrive::drive_download(file = as_id(gdriveSims[["fSsimDataPrep_fuelClass"]]), path = ffSsimDataPrep, overwrite = TRUE)
  }
  fSsimDataPrep <- loadSimList(ffSsimDataPrep)
} else {
  fSsimDataPrep <- Cache(
    simInitAndSpades,
    times =  list(start = 2011, end = 2011),
    params = fSdataPrepParams,
    objects = fSdataPrepObjects,
    paths = dataPrepPaths,
    modules = "fireSense_dataPrepFit",
    .plots = NA,
    #cloudFolderID = cloudCacheFolderID,
    userTags = c("fireSense_dataPrepFit", studyAreaName)
  )
  saveSimList(
    sim = fSsimDataPrep,
    filename = ffSsimDataPrep,
    #filebackedDir = dfSsimDataPrep,
    fileBackend = 2
  )
  #archive::archive_write_dir(archive = afSsimDataPrep, dir = dfSsimDataPrep)
  if (isTRUE(newGoogleIDs) | length(newGoogleIDs) == 0) {
    googledrive::drive_put(media = ffSsimDataPrep, path = as_id(gdriveURL), name = basename(ffSsimDataPrep), verbose = TRUE)
  } else {
    googledrive::drive_update(file = as_id(gdriveSims[["fSsimDataPrep_fuelClass"]]), media = ffSsimDataPrep)
  }
}
