# simulateAM <- c(TRUE, FALSE)
# AMscenario <- c(TRUE, FALSE)

#for non-AM sims
GCM <- c("CanESM5", "CNRM-ESM2-1", "ACCESS-ESMI1-5")
SSP <- c(245, 370)
studyArea <- c("SB", "WCB", "WB")
gmcsDriver <- c("LandR", "LandR.CS")
Replicates <- c(1, 2, 3)
runInfo <- as.data.table(expand.grid(GCM, SSP, studyArea, gmcsDriver, Replicates))
names(runInfo) <- c("GCM", "SSP", "studyArea", "gmcsDriver", "Replicates")

historical <- as.data.table(expand.grid("historical","", studyArea,"LandR",Replicates))
names(historical) <- names(runInfo)
climateRuns <- rbind(runInfo, historical)
climateRuns$simulateAM <- FALSE
climateRuns$AMscenario <- FALSE
write.csv(climateRuns, "climateRunInfo.csv")

#for AM sims
#basically need simulateAM = TRUE, AMscenario = c(TRUE, FALSE), no historical gcm, fewer study areas

