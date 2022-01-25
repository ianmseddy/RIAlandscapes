library(ggplot2)
library(zoo)
library(raster)
library(reproducible)
library(magrittr)
source("10-functions.R")
source("10a-postProcessing.R")

resultsTable <- buildResultsTable(studyAreaName = "SB")

biomassSumxEco <- Cache(FUN = lapply, resultsTable$fileLocation, getSimulationOutput, rt = resultsTable)
biomassSumxSpp <- Cache(FUN = lapply, resultsTable$fileLocation, getSummaryBySpecies, rt = resultsTable)

biomassSumxEco <- rbindlist(biomassSumxEco)
biomassSumxEco <- biomassSumxEco[!grep("9999", ecoregionGroup),]
biomassSumxEco[, ecoregionGroup := dropPadding(ecoregionGroup)]

biomassSumxSpp <- rbindlist(biomassSumxSpp)

#perhaps load ecoregionGroup table?
bSumEco <- biomassSumxEco[, .(meanBiomassMgha = sum(Biomass/100 * NofCell)/sum(NofCell)), .(GCM, RCP, driver, rep, Year)]
bSumEco <- bSumEco[, .(meanBiomassMgha = mean(meanBiomassMgha), sdBMgha = sd(meanBiomassMgha)), .(GCM, RCP, driver, Year)]


bSumEco[, runName := paste(GCM, RCP, sep = " ")]
withLandRCS <- bSumEco[driver == "" | runName == "historical ",]
withoutLandRCS <- bSumEco[driver == "noLandRCS" | runName == "historical"]

ggplot(data = withoutLandRCS, aes(x = Year, y = meanBiomassMgha,  col = runName)) +
  geom_path(size = 1.5) +
  geom_ribbon(aes(fill = runName, ymin = meanBiomassMgha - sdBMgha, ymax = meanBiomassMgha+sdBMgha, alpha = 0.5), show.legend = FALSE) +
  scale_color_discrete(name = "GCM and RCP") +
  labs(x = "year", y = "mean landscape biomass", title = paste("climate insensitive simulations -", studyAreaName))


ggplot(data = withLandRCS, aes(x = Year, y = meanBiomassMgha,  col = runName)) +
  geom_path(size = 1.5) +
  geom_ribbon(aes(fill = runName, ymin = meanBiomassMgha - sdBMgha, ymax = meanBiomassMgha+sdBMgha, alpha = 0.5), show.legend = FALSE) +
  scale_color_discrete(name = "GCM and RCP") +
  labs(x = "year", y = "mean landscape biomass", title = paste("climate sensitive simulations -", studyAreaName))


bSumEco[, growthType := ifelse(driver == "noLandRCS", "climate-insensitive", "climate-sensitive")]

ggplot(data = bSumEco[GCM != 'historical',], aes(x = Year, y = meanBiomassMgha,  col = GCM, linetype = RCP)) +
  geom_path(size = 1.2) +
  ylim(50, 130) +
  scale_color_discrete(name = "GCM") +
  scale_linetype_discrete(name = "RCP") +
  labs(x = "year", y = "mean forest biomass (Mg/ha)", title = "Sub-Boreal study area") +
  facet_wrap(facets = ~growthType, ncol = 2)

#####
# biomassMaps
baseMap <- qs::qread(file.path("outputs", studyAreaName, paste0("biomassMaps2011_", studyAreaName, ".qs"))) %>%
  .$biomassMap

simulatedB2100 <- Cache(getMeanRasterByRun, resultsTable = resultsTable, rasterName = "simulatedBiomassMap", year = 2101)
#maybe don't do this?
simulatedB2100 <- raster::stack(simulatedB2100)
simulatedB2100 <- simulatedB2100/100
names(simulatedB2100) <- rcpNoDots(names(simulatedB2100))
names(simulatedB2100) <- gsub(names(simulatedB2100), pattern = "_$", replacement = "")
lapply(names(simulatedB2100), FUN = function(ras, rs = simulatedB2100, outputPath = postProcessingPaths$outputPath){
  towrite <- rs[[ras]]
  writeRaster(towrite, datatype = "INT2U", filename = file.path(outputPath, paste0(ras, "_meanBiomass2100.tif")))
})

lapply(simulatedB2100, filename = paste0("outputs/summary figures/", studyAreaName, "biomass2101.tif"),
                   datatype = "INT2U", overwrite = TRUE)
