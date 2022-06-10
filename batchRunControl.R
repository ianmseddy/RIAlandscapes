library(data.table)
setDTthreads(2)
allRunInfo <- fread("climateRunInfo.csv")

#Rep3 - historical

# runInfoGroup <- allRunInfo[GCM == "CanESM5" & SSP == "245" & c((Replicates == 1  & AMscenario == TRUE) |
#                              c(Replicates == 3 & AMscenario == FALSE))]
runInfoGroup <- allRunInfo[studyArea == "SB" & gmcsDriver == "LandR.CS" & SSP == 370 & GCM == "CanESM5"]
for (i in 1:nrow(runInfoGroup)) {
  runInfo <- runInfoGroup[i,]
  source("00-global.R")
}

