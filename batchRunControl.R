library(data.table)
allRunInfo <- fread("AMRunInfo.csv")


#Rep3 - historical

runInfoGroup <- allRunInfo[GCM == "CNRM-ESM2-1" & SSP == "245" & simulateAM == TRUE]
for (i in 1:nrow(runInfoGroup)) {
  runInfo <- runInfoGroup[i,]

  source("00-global.R")
}

