do.call(setPaths, preamblePaths)

source("05-google-ids.R")
newGoogleIDs <- gdriveSims[["simOutPreamble"]] == ""

preambleObjects <- list()

preambleParams <- list(
  "RIAlandscapes_studyArea" = list( ## TODO: use your module name
    ".useCache" = TRUE,
    "historicalFireYears" = 1991:2019,
    "projectedFireYears" = 2011:2100,
    "studyAreaName" = studyAreaName,
    "GCM" = config::get("gcm"),
    "SSP" = config::get("ssp")
  )
)

fsimOutPreamble <- file.path(Paths$outputPath, paste0("simOutPreamble_", studyAreaName, ".qs"))

#it will constantly save into the cache, which is adding 2 GB everytime
simOutPreamble <- Cache(simInitAndSpades,
                        times = list(start = 0, end = 1),
                        params = preambleParams,
                        modules = c("RIAlandscapes_studyArea"),
                        objects = preambleObjects,
                        paths = preamblePaths,
                        useCloud = useCloudCache,
                        cloudFolderID = cloudCacheFolderID,
                        userTags = c("RIAlandscapes_studyArea", studyAreaName)
)

#no point saving the simList when the climate runs will alll be different..
if (!compareCRS(simOutPreamble$studyArea, simOutPreamble$rasterToMatch)){
  simOutPreamble$studyArea <- sf::st_transform(simOutPreamble$studyArea, crs = crs(simOutPreamble$rasterToMatch))
  simOutPreamble$studyAreaReporting <- sf::st_transform(simOutPreamble$studyAreaReporting, crs = crs(simOutPreamble$rasterToMatch))
  simOutPreamble$studyAreaLarge <- sf::st_transform(simOutPreamble$studyAreaLarge, crs = crs(simOutPreamble$rasterToMatch))
}

simOutPreamble$studyArea <- sf::as_Spatial(simOutPreamble$studyArea)
simOutPreamble$studyAreaReporting <- sf::as_Spatial(simOutPreamble$studyAreaReporting)
simOutPreamble$studyAreaLarge <- sf::as_Spatial(simOutPreamble$studyAreaLarge)

