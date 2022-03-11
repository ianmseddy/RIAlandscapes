allRunInfo <- fread("climateRunInfo.csv")


#Rep 3 - CanESM5
runInfoGroup <- allRunInfo[Replicates == 3 & GCM == "CanESM5"]
for (i in 1:nrow(runInfoGroup)) {
  runInfo <- runInfoGroup[i,]
  source("00-global.R")
}
