library(data.table)
allRunInfo <- fread("AMRunInfo.csv")


#Rep3 - historical

runInfoGroup <- allRunInfo[GCM == "CanESM5" & SSP == "245" & simulateAM == TRUE & AMscenario == TRUE & Replicates == 1]
for (i in 1:nrow(runInfoGroup)) {
  runInfo <- runInfoGroup[i,]

  #avoid NA SSP in file path
  if (GCM == "historical"){
    runInfo$SSP <- ""
  }

  source("00-global.R")
}

#Rep 3 - CNRM
runInfoGroup <- allRunInfo[Replicates == 3 & GCM == "CNRM-ESM2-1"]
for (i in 1:nrow(runInfoGroup)) {
  runInfo <- runInfoGroup[i,]
  source("00-global.R")
}
