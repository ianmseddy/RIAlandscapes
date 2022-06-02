#11b comparison of AM

#This code is all exploratory, and should be reviewed for things like labelling mistakes.
#ultimately we will want to track planted cohorts specifically, according to their age from planting,
#not their cohortData age, which is binned.


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


#first, let's compare planted vs. unplanted biomass
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


#### Assess impact of AM specifically #####
#start by looking at cohorts aged 40-50 (planted following BEC update in 2050)
#correct age  classes, some end in 2 because of the way ages are rounded in Biomass_core -
#a cohort planted in 2011, at age 2, ages out of being binned - if binning happens in 2021 (2 + 9 > successionTimeStep)


#only pixels planted after 2020 (80 years old or younger) matter - older than 80 are identical between AM scenarios
cd2101_withPlanted <- cd2101_withPlanted[age <= 80]
#comparing the distribution is not very informative. Comparing the difference in mean by ecoregion might be?


BECkey <- fread("inputs/BECkey.csv")
#need ecoregionMap to make the table joining ecoregionGroup with BEC variant
#this object could be saved? AM modules should really output it...or put it in a package.

ecoregionRst <- qs::qread("outputs/SB/biomassMaps2011_SB.qs")
ecoregionRst <- ecoregionRst$ecoregionMap
ecoregionKey <- as.data.table(ecoregionRst@data@attributes[[1]])
setnames(ecoregionKey, 'ID', 'ecoregionMapCode')
pLength <- max(nchar(as.character(ecoregionKey$ecoregion)))
BECkey[, ID := as.factor(paddedFloatToChar(ID, padL = pLength))]
BECkey <- BECkey[ecoregionKey, on = c("ID" = "ecoregion")]
BEC_LandR_key <- BECkey[, .(ZONE, VAR, zsv, ecoregionGroup)]

cd2101_withPlanted <- BEC_LandR_key[cd2101_withPlanted, on = c("ecoregionGroup")]
#since maxB is so influential, we have to look at ecoregionGroups, not BECs.
#for now, focus on coniferous forest
#37 variants in SB (that have trees that are planted in 2100)
#growthPred only reflects a random climate year from 2090-2100 - it is not informative

#I think we can get rid of pixels age 11 or younger - they are mainly age 0 from the last dispersal
cd2101_withPlanted <- cd2101_withPlanted[age > 11]

cd2101_sum <- cd2101_withPlanted[, .(B = sum(B), aNPPAct = sum(aNPPAct),
                                     growthPred = mean(growthPred),
                                     .N, HTp_pred = mean(HTp_pred)), #this does mean we lose species-level HTp_pred info
                                     .(ZONE, zsv, pixelIndex, ageClass, zsv,
                                           planted, GCM, SSP, AMscenario, Replicate)]

cd2101_sum[, totalB := sum(B), .(Replicate, SSP, AMscenario, pixelIndex)]
cd2101_sum[, propB := sum(B), .(Replicate, SSP, AMscenario, pixelIndex, planted)]
cd2101_sum[, propB := propB / totalB]

#this is to confirm ingress is essentially irrelevant at a median 1.5% of biomass
summary(cd2101_sum[planted == TRUE,]$propB)
#let's look at age ages 20, 50, and 80 (representing 2020, 2050, and 2080 proj BECs)

#1) need to track ecoregionGroup separately. For now focus on coniferous landcover only
#2) This should use the student's t test to test for difference in population mean between AM and non-AM for each EG
#3) this has not been implemented yet - hence the tempCD designation
#4) I've completely ignored species becasue it involves sub-pixelGroup comparisons

tempCD2101_sum <- copy(cd2101_sum)
tempCD2101_sum <- tempCD2101_sum[planted == TRUE, .(B = sum(B), aNPP = sum(aNPPAct)),
                                 .(pixelIndex, Replicate, AMscenario, ecoregionGroup, zsv, ZONE, SSP, ageClass)]
tempCD2101_sum[, N := .N, .(AMscenario, zsv, ZONE, SSP, ageClass)]
tempCD2101_sum <- tempCD2101_sum[N > 1000]
tempCD2101_sum <- tempCD2101_sum[, .(B = mean(B)/100, aNPP = mean(aNPP), N = mean(N)), .(AMscenario, zsv, ZONE, SSP, ageClass)]
tempCD2101_sum30 <- tempCD2101_sum[ageClass == 30]

tempCD2101_temp <- dcast(tempCD2101_sum30, formula = zsv + ZONE + SSP ~ AMscenario, value.var = c("B", "aNPP", "N"))
tempCD2101_temp[, Bdiff := B_TRUE - B_FALSE]
tempCD2101_temp[, aNPPdiff := aNPP_TRUE - aNPP_FALSE]
tempCD2101_temp[, c("BdiffPct", "ANPPdiffPct") :=
             list(Bdiff/B_FALSE * 100,
                  aNPPdiff/aNPP_FALSE * 100)]
tempCD2101_temp <- BEC_LandR_key[meanByEG30, on = c("ecoregionGroup")]
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

