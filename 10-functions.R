
rcpNoDots <- function(rcp){
  nodots <- gsub(pattern = "\\.", replacement = "", x = rcp)
  return(nodots)
}


buildResultsTable <- function(studyAreaName, GCM = c("Access1", "INM-CM4", "CanESM2"), RCP = c("RCP4.5", "RCP8.5"), reps = c(1:3)) {

  dirs <- expand.grid("studyAreaName" = studyAreaName, "GCM" = GCM, RCP =  RCP, reps = reps, driver = c("noLandRCS", ""))

  dirs$filename <- paste(dirs$studyAreaName, dirs$GCM, rcpNoDots(dirs$RCP),
                         dirs$driver, dirs$reps, sep = "_")
  dirs$filename <- gsub(pattern = "__", replacement = "_", x = dirs$filename)
  dirs$fileLocation <- file.path("outputs/sims", dirs$studyAreaName, dirs$GCM, dirs$RCP, dirs$filename)
  historicalRuns <- data.frame(filename = paste0(studyAreaName, "_historical_LandR_", 1:3), reps = 1:3)
  historicalRuns$fileLocation <- paste("outputs/sims", studyAreaName = studyAreaName,
                                       historicalRuns$filename, sep = "/")
  outputFiles <- dplyr::full_join(historicalRuns, dirs)
  outputFiles <- as.data.table(outputFiles)
  outputFiles[is.na(studyAreaName), `:=`(
              studyAreaName = studyAreaName,
              GCM = "historical",
              RCP = "",
              driver = "noLandRCS")]
  outputFiles
}
