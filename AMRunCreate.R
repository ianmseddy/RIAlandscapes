# simulateAM <- c(TRUE, FALSE)
# AMscenario <- c(TRUE, FALSE)

#for non-AM sims
GCM <- c("CanESM5", "CNRM-ESM2-1", "ACCESS-ESMI1-5")
SSP <- c(245, 370)
studyArea <- c("SB")
gmcsDriver <- c("LandRCSAM")
Replicates <- c(1, 2, 3)
simulateAM <- TRUE
AMscenario <- c(TRUE, FALSE)
runInfo <- as.data.table(expand.grid(GCM, SSP, studyArea, gmcsDriver, Replicates, simulateAM, AMscenario))
names(runInfo) <- c("GCM", "SSP", "studyArea", "gmcsDriver", "Replicates", "simulateAM", "AMscenario")


write.csv(runInfo, "AMRunInfo.csv")

#for AM sims
#basically need simulateAM = TRUE, AMscenario = c(TRUE, FALSE), no historical gcm, fewer study areas

