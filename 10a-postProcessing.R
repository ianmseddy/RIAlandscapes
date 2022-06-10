library(magrittr)
library(googledrive)
library(data.table)
library(reproducible)

switch(Sys.info()[["user"]],
       "ieddy" = Sys.setenv(R_CONFIG_ACTIVE = "ian"),
       Sys.setenv(R_CONFIG_ACTIVE = "test")
)

if (!exists("pkgDir")) {
  pkgDir <- file.path("packages", version$platform, paste0(version$major, ".",
                                                           strsplit(version$minor, "[.]")[[1]][1]))

  if (!dir.exists(pkgDir)) {
    dir.create(pkgDir, recursive = TRUE)
  }
  .libPaths(pkgDir)
}

allRunInfo <- fread("ClimateRunInfo.csv")
runInfo <- allRunInfo[1,]
source("01-init.R")
source("02-paths.R")

source("05-google-ids.R")
source("10-functions.R")
#true post-processing: I'm not sure yet if we will want to crop all GIS outputs.

options("reproducible.cachePath" = "cache/cache_postProcess")

#clean up
rm(preamblePaths, spreadFitPaths, ignitionFitPaths, escapeFitPaths, dataPrepPaths)
rm(messagingNumCharsModule,firstRunSpreadFit, reproducibleAlgorithm, useMemoise,
   usePlot, useRequire, userInputPaths, AMscenario, simulateAM, codeChecks, fuelClasses)
rm(uniqueRunName, dynamicPaths)

#fire - fire stats are unlikely to be affected by buffer, but maps need to be cropped
#generate some mean cumulative burn maps by GCM, SSP

if (FALSE){
  runFiles <- buildResultsTable(allRunInfo = data.table::fread("ClimateRunInfo.csv"))
  for (i in 1:nrow(runFiles)) {
    fileLoc <- runFiles[i, ]$fileLocation
    runFile <- runFiles[i, ]$filename
    gUrl <- gdriveResults[[runFile]]
    if (!dir.exists(fileLoc)) {
      checkPath(fileLoc, create = TRUE)
      googledrive::drive_download(file = as_id(gUrl), path = paste0(fileLoc, ".tar.gz"))
      utils::untar(tarfile = paste0(fileLoc, ".tar.gz"))
      unlink(paste0(fileLoc, ".tar.gz"))
    }
    rm(fileLoc, runFile, i)
  }
}
