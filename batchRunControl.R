library(data.table)
allRunInfo <- fread("climateRunInfo.csv")


#Rep3 - historical

runInfoGroup <- allRunInfo[GCM == "historical" & Replicates == 3]
for (i in 1:nrow(runInfoGroup)) {
  runInfo <- runInfoGroup[i,]
  source("00-global.R")
}

#Rep 3 - CNRM
runInfoGroup <- allRunInfo[Replicates == 3 & GCM == "CNRM-ESM2-1"]
for (i in 1:nrow(runInfoGroup)) {
  runInfo <- runInfoGroup[i,]
  source("00-global.R")
}
