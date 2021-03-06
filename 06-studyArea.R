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
    "GCM" = GCM,
    "SSP" = SSP
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

simOutPreamble$studyArea <- sf::as_Spatial(simOutPreamble$studyArea)
simOutPreamble$studyAreaLarge <- sf::as_Spatial(simOutPreamble$studyAreaLarge)
simOutPreamble$studyAreaReporting <- sf::as_Spatial(simOutPreamble$studyAreaReporting)

