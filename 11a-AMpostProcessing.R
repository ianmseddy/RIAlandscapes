#this script is for post-processing + analysis of the AM output.
#The AM project was only run for the Sub-Boreal study region (the only one wholly inside BC)
library(data.table)
library(Require)
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

allRunInfo <- fread("AMRunInfo.csv")
allRunInfo[, AMname := ifelse(AMscenario, "withAM", "withNoAM")]
allRunInfo[, runName := paste("SB", allRunInfo$GCM, allRunInfo$SSP, allRunInfo$AMname, allRunInfo$Replicate, sep = "_")]
allRunInfo[, fileLocation := file.path("outputs/AMsims", runName)]
# allRunInfo <- allRunInfo[GCM == "CNRM-ESM2-1"] #for now

#this is needed to set up some paths and options, but most of it can be removed
runInfo <- allRunInfo[1]
source("01-init.R")
source("02-paths.R")
source("03-packages.R")
source("04-options.R")
#clean up
rm(preamblePaths, spreadFitPaths, ignitionFitPaths, escapeFitPaths, dataPrepPaths)
rm(messagingNumCharsModule,firstRunSpreadFit, reproducibleAlgorithm, useMemoise,
   usePlot, useRequire, userInputPaths, AMscenario, simulateAM, codeChecks, fuelClasses)
rm(uniqueRunName, dynamicPaths, SSP, usePrerun, newGoogleIDs, maxMemory, cloudCacheFolderID,
   cacheFormat, cacheDBconn, Replicate)

source("05-google-ids.R")
source("10-functions.R")


if (FALSE) {
  #get data  - rebuild the nested directory layout across machines
  gdriveResults <- gdriveResults[grep("AM", names(gdriveResults))]

  #runFile aws filename
  for (i in 1:nrow(allRunInfo)) {
    toSearch <- allRunInfo[i,]$fileLocation
    gUrl <- gdriveResults[[allRunInfo[i,]$runName]]
    if (!is.null(gUrl)){
      if (!dir.exists(toSearch)) {
        checkPath(toSearch, create = TRUE)
        googledrive::drive_download(file = as_id(gUrl), path = paste0(toSearch, ".tar.gz"))
        utils::untar(tarfile = paste0(toSearch, ".tar.gz"))
        unlink(paste0(toSearch, ".tar.gz"))
      }
    }
  }
  rm(gUrl, toSearch)
}
