#11b comparison of AM
library(ggplot2)
#This code is all exploratory, and should be reviewed for things like labelling mistakes.
#ultimately we will want to track planted cohorts specifically, according to their age from planting,
#not their cohortData age, which is binned
#(but not consistently, if cohort is from year of dispersal, initial age 2 + 9 sim years > successionTimestep,
#which means it is not binned)


#need ecoregionMap to make the table joining ecoregionGroup with BEC variant
#this object could be saved? AM modules should really output it...or put it in a package.
BECkey <- fread("inputs/BECkey.csv")
ecoregionRst <- qs::qread("outputs/SB/biomassMaps2011_SB.qs")
ecoregionRst <- ecoregionRst$ecoregionMap
ecoregionKey <- as.data.table(ecoregionRst@data@attributes[[1]])
setnames(ecoregionKey, 'ID', 'ecoregionMapCode')
pLength <- max(nchar(as.character(ecoregionKey$ecoregion)))
BECkey[, ID := as.factor(paddedFloatToChar(ID, padL = pLength))]
BECkey <- BECkey[ecoregionKey, on = c("ID" = "ecoregion")]
BECkey[, LCC := as.numeric(stringr::str_replace(ecoregionGroup, pattern = "[:digit:]*_", replacement = ""))]
BEC_LandR_key <- BECkey[, .(ZONE, VAR, zsv, ecoregionGroup, LCC)]
rm(ecoregionRst, ecoregionKey, pLength, BECkey)


####get cohortData Objects - convert to cohortDataLong, for simplicity
setkey(allRunInfo, SSP)
allRunInfo <- allRunInfo[dir.exists(fileLocation)]

cd2101 <- lapply(allRunInfo$fileLocation, FUN = function(x){
  readRDS(file.path(x, "cohortData_year2101.rds"))
})

pg2101 <- lapply(allRunInfo$fileLocation, FUN = function(x){
  readRDS(file.path(x, "pixelGroupMap_year2101.rds"))
})

#cdLong because mean N is 1.2, but it is more common in unplanted
cd2101Long <- Map(f = LandR::addPixels2CohortData,
              cohortData = cd2101,
              pixelGroupMap = pg2101)
rm(cd2101) #it is 10 GB and will only get larger....

#first, compare planted vs. unplanted biomass?
#this will be annoying to resign every function, but I don't have to have enormous cohortData lists..
names(cd2101Long) <- allRunInfo$runName


#need to separate by ages...
#anything younger than 20 and older than 80 will have limited to no impact from AM
#(limited for age < 20 because AM + CS is phased in from 0-20)
#(no impact for age > 80 because AM and no-AM scenarios are identical from 2011-2020)
#for non-planted trees, age classes will range up to 300+
# but we only care about age class of planted trees

#similar functions needed to be repeated, not sure how to functionalize this...

#####Assess overlall impact on landscape #####

cd2101_withPlanted <- lapply(1:nrow(allRunInfo), FUN = function(i, dt = allRunInfo, cdList = cd2101Long){
  dt <- copy(dt[i,])
  cd <- cdList[[dt$runName]]
  cd[, mortPred := NULL] #get rid of any columns that aren't important
  cd[, ageClass := round(age/10) * 10]
  cd[, hasPlanted := any(planted), .(pixelGroup)]
  cd <- cd[hasPlanted == TRUE,]
  cd[, hasPlanted := NULL]
  cd[, c("GCM", "SSP", "AMscenario", "Replicate") :=
       list(dt$GCM, dt$SSP, dt$AMscenario, dt$Replicate)]
  return(cd)
})

cd2101_withPlanted <- rbindlist(cd2101_withPlanted)
#for now
cd2101_withPlanted <- cd2101_withPlanted[GCM == "CNRM-ESM2-1"]
rm(cd2101Long)
cd2101_withPlanted <- BEC_LandR_key[cd2101_withPlanted, on = c("ecoregionGroup")]

#because pixelIndex is no longer unique
uniquePGcols <- c("pixelIndex", "GCM", "SSP", "AMscenario", "Replicate")

#to remove 90 year old planted pixelGroups (these are uninteresting as they have no difference between AM)
cd2101_withPlanted[, maxAge := max(ageClass), by = uniquePGcols]
cd2101_withPlanted <- cd2101_withPlanted[maxAge < 90 & ageClass > 10] #there is no reason to examine 10 year olds.
#cuts about 27% of data

#### Assess impact of AM specifically #####
#start by looking at cohorts aged 40-50 (planted following BEC update in 2050)
#correct age  classes, some end in 2 because of the way ages are rounded in Biomass_core -
#a cohort planted in 2011, at age 2, ages out of being binned - if binning happens in 2021 (2 + 9 > successionTimeStep)


#only pixels planted after 2020 (80 years old or younger) matter - older than 80 are identical between AM scenarios
# cd2101_withPlanted <- cd2101_withPlanted[age <= 80] #this does not remove the ingress in those pixels...
# this result on the whole landscape was qutie underwhelming.

#because pixelGroups are no longer unique in the table


#there must be a way to weight the biomass of a planted pixel by the proportion of the planted total
#this would allow species-level comparisons of pixelGroups with differing numbers of planted cohorts
#but this needs more thought and discussion

#we could pull out pure cohorts to begin with.
cd2101_withPlanted[, nPlanted := sum(planted, na.rm = TRUE), by = uniquePGcols]
cd2101_withPlanted <- cd2101_withPlanted[nPlanted != 0, ]#TODO: this is because age filtering left ingress pgs in...
cd2101_withPlanted[planted == TRUE, sumPlantedB := sum(B), by = uniquePGcols]
cd2101_withPlanted[planted == TRUE, propPlantedB := B/sumPlantedB]

singlePlanted <- cd2101_withPlanted[planted == TRUE & nPlanted == 1]
singlePlanted50 <- singlePlanted[ageClass == 50] #50 is relevant due to projection timestep 2050
#it's possible 60 is more relevant? This is why we need the extra year of planting.
#2050 is when the provenance table is updated, so if a cohort is planted in 2048, rounds to 11 2051, it is now 61.
#but cohorts planted after 2050 should be (2050-2060 round to 11 in 2061) + 40 years of sims = 50 age class,
#40-50 in real years
singlePlanted30 <- singlePlanted[ageClass == 30] #30 is relevant due to proejction timestep 2080 -


#since maxB is so influential, we have to look at ecoregionGroups, not BECs.
#for now, focus on coniferous forest
#37 variants in SB (that have trees that are planted in 2100)
#growthPred only reflects a random climate year from 2090-2100 - it is not informative

#####analyzing whole pixels - no species####
cd2101_sum <- cd2101_withPlanted[, .(B = sum(B), aNPPAct = sum(aNPPAct),
                                     growthPred = mean(growthPred),
                                     .N, HTp_pred = mean(HTp_pred)),
                                 .(ZONE, zsv, LCC, pixelIndex, ageClass,
                                   planted, GCM, SSP, AMscenario, Replicate)]
#do not include provenance as a 'by' column - or pixels will be split

cd2101_sum[, totalB := sum(B), by = uniquePGcols]
cd2101_sum[, plantedB := sum(B), by = c("planted", uniquePGcols)]
cd2101_sum[, propB := plantedB / totalB]
hist(cd2101_sum[planted == TRUE]$propB)
cd2101_sum[, c("propB", "plantedB", "totalB") := NULL]
#this is to confirm ingress is essentially irrelevant at a median 1.5% of biomass


#1) need to track ecoregionGroup separately. For now focus on coniferous landcover only
#2) This should use the student's t test to test for difference in population mean between AM and non-AM for each EG
#3) this has not been implemented yet - hence the tempCD designation
#4) I've completely ignored species becasue it involves sub-pixelGroup comparisons



tempCD2101_sum <- copy(cd2101_sum)
#filters out 70% of the data, which is 2% of the biomass... shocking.
#further evidence that maxB needs to be adjusted by climate
tempCD2101_sum <- tempCD2101_sum[planted == TRUE,]
#must control for age..
compareGroups <- function(dt, covaryingCols = c("GCM", "SSP", "zsv"), dependentVar = "B", minSample = 500) {
  uniqueGroups <- unique(dt[, .SD, .SDcol = covaryingCols])
  #alternatively, lapply, and return the whole t test object?
  testOutput <- lapply(1:nrow(uniqueGroups), FUN = function(i) {
    currentGroup <- uniqueGroups[i,]
    currentDT <- dt[currentGroup, on = covaryingCols]
    AMtrue <- currentDT[AMscenario == TRUE,]
    AMfalse <- currentDT[AMscenario == FALSE,]
    #use welch t test - allows unequal sample size + variance. test is for identical means
    if (nrow(AMtrue) > 50 & nrow(AMfalse) > 50){
      tTest <- t.test(AMtrue[[dependentVar]],
                      AMfalse[[dependentVar]], alternative = "greater")
      currentGroup[, c("test.statistic", "p.value", "AMconfint", "noAMconfint",
                       "AMmean", "noAMmean", "stErr", "N") :=
                     list(tTest$statistic, tTest$p.value, tTest$conf.int[1], tTest$conf.int[2],
                          tTest$estimate[1], tTest$estimate[2], tTest$stderr,
                          sum(nrow(AMtrue), nrow(AMfalse)))]

    }
    return(currentGroup)
  })
  testOutput <- rbindlist(testOutput, fill = TRUE)
  testOutput[, meanDiffRaw := AMmean - noAMmean]
  testOutput[, meanDiffPct := meanDiffRaw/noAMmean * 100]
  testOutput[, stErrPct := stErr/noAMmean * 100] #does this make sense?
  return(testOutput)
}

#Biomass
ageSubset <- 50
SSPsubset <- 370
outputA <- compareGroups(tempCD2101_sum[ageClass == ageSubset & LCC == 1,],
                           dependentVar = "B", minSample = 100)
outputA[, labelName := paste0(zsv, " (n = ", N, ")")]
Aplot <- ggplot(outputA[SSP == SSPsubset & !is.na(AMmean)], aes(x = labelName,  y = meanDiffPct)) +
  geom_bar(stat = 'identity') +
  geom_errorbar(aes(ymin = meanDiffPct - stErrPct,
                    ymax = meanDiffPct + stErrPct),
                width = .2, position = position_dodge(.9)) +
  labs(x = "BEC variant", y = "mean difference in biomass from AM (%)",
       title = paste0("age class ", ageSubset, " - CNRM-ESM2-1 SSP ", SSPsubset)) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
ggsave(plot = Aplot,
       filename = paste0("outputs/summary figures/AM/Bdiff_age",ageSubset, "_SSP", SSPsubset, ".png"),
       device = "png")
#aNPP
outputB <- compareGroups(tempCD2101_sum[ageClass == ageSubset & LCC == 1,],
                          dependentVar = "aNPPAct", minSample = 100)
outputB[, labelName := paste0(zsv, " (n = ", N, ")")]
Bplot <- ggplot(outputB[SSP == 370 & !is.na(AMmean)], aes(x = labelName,  y = meanDiffPct)) +
  geom_bar(stat = 'identity') +
  geom_errorbar(aes(ymin = meanDiffPct - stErrPct,
                    ymax = meanDiffPct + stErrPct),
                width = .2, position = position_dodge(.9)) +
  labs(x = "BEC variant", y = "mean difference in aNPP from AM (%)",
       title = paste0("age class ", ageSubset, " - CNRM-ESM2-1 SSP ", SSPsubset)) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
ggsave(plot = Bplot,
       filename = paste0("outputs/summary figures/AM/aNPPdiff_age",ageSubset, "_SSP", SSPsubset, ".png"),
      device = "png")



outputC <- compareGroups(tempCD2101_sum[ageClass == ageSubset & LCC == 1,],
                           dependentVar = "HTp_pred", minSample = 100)
outputC[, labelName := paste0(zsv, " (n = ", N, ")")]
Cplot <- ggplot(outputC[SSP == 370 & !is.na(AMmean)], aes(x = labelName,  y = meanDiffPct)) +
  geom_bar(stat = 'identity') +
  geom_errorbar(aes(ymin = meanDiffPct - stErrPct,
                    ymax = meanDiffPct + stErrPct),
                width = .2, position = position_dodge(.9)) +
  labs(x = "BEC variant", y = "mean difference in genetic modifier from AM (%)",
       title = paste0("age class ", ageSubset, " - CNRM-ESM2-1 SSP ", SSPsubset)) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
ggsave(plot = Cplot,
       filename = paste0("outputs/summary figures/AM/HTPdiff_age",ageSubset, "_SSP", SSPsubset, ".png"),
      device = "png")


#the clumsy old method
# tempCD2101_sum <- tempCD2101_sum[planted == TRUE, .(B = sum(B), aNPP = sum(aNPPAct)),
#                                  .(pixelIndex, Replicate, AMscenario, ecoregionGroup, zsv, ZONE, SSP, ageClass)]
# tempCD2101_sum[, N := .N, .(AMscenario, zsv, ZONE, SSP, ageClass)]
# tempCD2101_sum <- tempCD2101_sum[N > 1000]
# tempCD2101_sum <- tempCD2101_sum[, .(B = mean(B)/100, aNPP = mean(aNPP), N = mean(N)), .(AMscenario, zsv, ZONE, SSP, ageClass)]
# tempCD2101_sum30 <- tempCD2101_sum[ageClass == 30]
#
# tempCD2101_temp <- dcast(tempCD2101_sum30, formula = zsv + ZONE + SSP ~ AMscenario, value.var = c("B", "aNPP", "N"))
# tempCD2101_temp[, Bdiff := B_TRUE - B_FALSE]
# tempCD2101_temp[, aNPPdiff := aNPP_TRUE - aNPP_FALSE]
# tempCD2101_temp[, c("BdiffPct", "ANPPdiffPct") :=
#                   list(Bdiff/B_FALSE * 100,
#                        aNPPdiff/aNPP_FALSE * 100)]

meanByEG30 <- tempCD2101_temp

ggplot(data = meanByEG30[SSP == 370], aes(y = BdiffPct, x = zsv)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  labs(y = "difference in age 30 B under AM (%)", x = "BEC variant (min 1000 pixels)")

ggplot(data = meanByEG30[SSP == 370], aes(y = ANPPdiffPct, x = zsv)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  labs(y = "difference in age 30 ANPP under AM (%)", x = "BEC variant (min 1000 pixels)")

ggplot(data = meanByEG30[LCC == "01"], aes(y = HTpDiffPct, x = zsv)) +
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  labs(y = "difference in age 30 gen. modifier under AM (%)", x = "BEC variant (min 1000 pixels)")

##### analyzing pure pine stands (well, planted purely with pine) ####
# this represents 90% of the pure stands and the only species with sufficient data by BECs
singlePlanted50[, N := .N, .(speciesCode, ZONE, ecoregionGroup, zsv, AMscenario, SSP, GCM, LCC)]

#calculate the means across pixels - this is a lazy back-of-napkin analysis
td50sum <- singlePlanted50[N > 100, .(B = mean(B)/100, aNPPAct = mean(aNPPAct)/100,
                                 HTp_pred = mean(HTp_pred)),
                      .(speciesCode, ZONE, ecoregionGroup, LCC, zsv, N, AMscenario, SSP, GCM)]

#cast the data.table
td50sum <- dcast(data = td50sum,
                 formula = ZONE + zsv + ecoregionGroup + LCC + SSP + GCM + speciesCode ~ AMscenario,
                 value.var = c("HTp_pred", "B", "aNPPAct"))

td50sum[, groupsToCompare := .N, .(LCC, zsv, ecoregionGroup, speciesCode, SSP, GCM)]


td50sum[, c("Bdiff", "aNPPdiff", "HTPdiff") :=
          list(c(B_TRUE - B_FALSE)/B_FALSE * 100,
               c(aNPPAct_TRUE - aNPPAct_FALSE)/aNPPAct_FALSE * 100,
               c(HTp_pred_TRUE - HTp_pred_FALSE)/HTp_pred_FALSE * 100)]

ggplot(data  = td50sum[speciesCode == "Pinu_con" & SSP == 370 & LCC == 1 & !is.na(Bdiff)],
       aes(y = Bdiff, x = zsv)) +
  geom_bar(position = 'dodge', stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  labs(x = "BEC variant", y = "Pine biomass difference from AM (%)")

ggplot(data  = td50sum[speciesCode == "Pice_gla" & SSP == 370 & LCC == 1 & !is.na(Bdiff)],
       aes(y = Bdiff, x = zsv)) +
  geom_bar(position = 'dodge', stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  labs(x = "BEC variant", y = "Pine biomass difference from AM (%)")


