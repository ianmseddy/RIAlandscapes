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
    "RCP" = config::get("rcp")
  )
)

fsimOutPreamble <- file.path(Paths$outputPath, paste0("simOutPreamble_", studyAreaName, ".qs"))

simOutPreamble <- Cache(simInitAndSpades,
                        times = list(start = 0, end = 1),
                        params = preambleParams,
                        modules = c("RIAlandscapes_studyArea"),
                        objects = preambleObjects,
                        paths = preamblePaths,
                        useCache = 'overwrite',
                        useCloud = useCloudCache,
                        cloudFolderID = cloudCacheFolderID,
                        userTags = c("RIAlandscapes_studyArea", studyAreaName)
)

#no point saving the simList when the climate runs will alll be different..
