library(magrittr)
library(googledrive)
library(data.table)


switch(Sys.info()[["user"]],
       "ieddy" = Sys.setenv(R_CONFIG_ACTIVE = "ian"),
       Sys.setenv(R_CONFIG_ACTIVE = "test")
)
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
#generate some mean cumulative burn maps by GCM, RCP
StudyAreas <- c("WB", "SB", "WCB")
GCMs <- c("CanESM2", "INM-CM4", "Access1")
RCP <- c("RCP4.5", "RCP8.5")

#get data  - rebuild the nested directory layout across machines
gdriveStudyArea <- grep(names(gdriveResults), pattern = studyAreaName) %>%
  gdriveResults[.]

dirs <- expand.grid("studyAreaname" = studyAreaName, "GCM" =  GCMs, "RCP" =  RCP, reps = 1:3, driver = c("noLandRCS", ""))

#
dirs$filename <- paste(dirs$studyAreaname, dirs$GCM, rcpNoDots(dirs$RCP),
                       dirs$driver, dirs$reps, sep = "_")
dirs$filename <- gsub(pattern = "__", replacement = "_", x = dirs$filename)
dirs$fileLocation <- file.path("outputs/sims", dirs$studyAreaname, dirs$GCM, dirs$RCP, dirs$filename)
historicalRuns <- data.frame(filename = paste0(studyAreaName, "_historical_LandR_", 1:3), reps = 1:3)
historicalRuns$fileLocation <- paste("outputs/sims", studyAreaName, historicalRuns$filename, sep = "/")
outputFiles <- dplyr::full_join(historicalRuns, dirs)
outputFiles <- as.data.table(outputFiles)
outputFiles[is.na(studyAreaName), studyAreaname := studyAreaName]

if (FALSE){
  for (runFile in outputFiles$filename) {
    toSearch <- outputFiles[filename == runFile]$fileLocation
    gUrl <- gdriveStudyArea[[runFile]]
    if (!dir.exists(toSearch)) {
      checkPath(toSearch, create = TRUE)
      googledrive::drive_download(file = as_id(gUrl), path = paste0(toSearch, ".tar.gz"))
      utils::untar(tarfile = paste0(toSearch, ".tar.gz"))
      unlink(paste0(toSearch, ".tar.gz"))
    }
  }
}
