#10c biomass summary
library(ggplot2)
library(zoo)
library(rasterVis)
library(RColorBrewer)
library(stringr)
library(sf)
library(data.table)
library(nngeo) #needed for remove holes

source("10-functions.R")
source("10a-postProcessing.R")

resultsTable <- buildResultsTable(allRunInfo = allRunInfo)
studyAreas <- c("WB", "WCB", "SB")
SARs <- getStudyAreaReporting(studyAreas)

#this is to fix tiny holes in the Sub-Boreal shapezone,
#which have no effect on results but are ugly in maps
tempSAR <- lapply(SARs, st_as_sf)
SAshp <- rbind(tempSAR$WB, tempSAR$WCB, tempSAR$SB)
SAshp <- nngeo::st_remove_holes(SAshp)
rm(tempSAR)

biomassSumxEco <- Cache(FUN = lapply, resultsTable$fileLocation, getSimulationOutput, rt = resultsTable)
biomassSumxSpp <- Cache(FUN = lapply, resultsTable$fileLocation, getSummaryBySpecies, rt = resultsTable)

biomassSumxEco <- rbindlist(biomassSumxEco)
biomassSumxEco <- biomassSumxEco[!grep("9999", ecoregionGroup),]
biomassSumxEco[, ecoregionGroup := dropPadding(ecoregionGroup)]

biomassSumxSpp <- rbindlist(biomassSumxSpp)

#perhaps load ecoregionGroup table?
bSumEco <- biomassSumxEco[, .(meanBiomassMgha = sum(Biomass/100 * NofCell)/sum(NofCell)), .(studyArea, GCM, SSP, driver, rep, Year)]
bSumEco <- bSumEco[, .(meanBiomassMgha = mean(meanBiomassMgha), sdBMgha = sd(meanBiomassMgha)),
                   .(studyArea, GCM, SSP, driver, Year)]
bSumEco[GCM == 'historical', GCM := "reference"]

#Fix up the SSP label
bSumEco[, realSSP := paste0(substr(SSP, start = 1, stop = 1), " ",
                            substr(SSP, start = 2, stop = 2), ".",
                            substr(SSP, start = 3, stop = 3))]
bSumEco[, runName := paste(GCM,"SSP", realSSP, sep = " ")]
bSumEco[GCM == "reference", runName := "reference"]

withLandRCS <- bSumEco[driver != "LandR" | GCM == "reference"]
withoutLandRCS <- bSumEco[driver == "LandR" | GCM == "reference"]

######raw change in biomass ####
for (i in c("SB", "WCB", "WB")) {
  CS <- withLandRCS[studyArea == i]
  noCS <- withoutLandRCS[studyArea == i]
  All <- bSumEco[studyArea == i]
  aPlot <- ggplot(data = noCS, aes(x = Year, y = meanBiomassMgha,  col = runName)) +
    geom_path(size = 1.2, alpha = 0.6) +
    guides(color = guide_legend(override.aes = list(alpha = 1, size = 1.5))) +
     ylim(0, max(noCS$meanBiomassMgha * 1.2)) +
    scale_color_discrete(name = "GCM and SSP") +
    labs(x = "year", y = "mean forest biomass (Mg/ha)", title = paste("no climate-sensitive growth -", i))
  ggsave(file.path("outputs/summary figures", i, "meanBiomassXGCM_noCS.png"), device = "png", dpi = 300, plot = aPlot)

  bPlot <- ggplot(data = CS, aes(x = Year, y = meanBiomassMgha,  col = runName)) +
    geom_path(size = 1.2, alpha = 0.6) +
    scale_color_discrete(name = "GCM and SSP") +
    guides(color = guide_legend(override.aes = list(alpha = 1, size = 1.5))) +
    ylim(0, max(CS$meanBiomassMgha * 1.2)) +
    labs(x = "year", y = "mean forest biomass (Mg/ha)", title = paste("climate sensitive growth -", i))
  ggsave(file.path("outputs/summary figures", i, "meanBiomassXGCM_CS.png"), device = "png", dpi = 300, plot = bPlot)

  All[, `growth type` := ifelse(driver == "LandR", "climate-insensitive", "climate-sensitive")]
  cPlot <- ggplot(data = All[GCM != 'historical',], aes(x = Year, y = meanBiomassMgha, col = runName)) +
    geom_path(size = 1.2, alpha = 0.7, aes(linetype = `growth type`)) +
    guides(color = guide_legend(override.aes = list(alpha = 1, size = 1.5))) +
    scale_color_discrete(name = "GCM and SSP") +
    ylim(0, max(All$meanBiomassMgha * 1.2)) +
    labs(x = "year", y = "mean forest biomass (Mg/ha)", title = i)
  ggsave(file.path("outputs/summary figures", i, "meanBiomassxGCM_all.png"), device = "png", dpi = 300, plot = cPlot)
}

#### relative change in biomass  ####
refB <- bSumEco[runName == "reference"]
setnames(refB, old = "meanBiomassMgha", new = "refBiomass")
refB <- refB[, .(studyArea, refBiomass, Year)]
bSumEco <- refB[bSumEco, on = c("studyArea", "Year")]
bSumEco[, Bdiff := meanBiomassMgha - refBiomass]

if (FALSE) {
  for (i in c("SB", "WCB", "WB")) {
    CS <- bSumEco[studyArea == i & c(driver == "LandR.CS" | runName == "reference")]
    noCS <- bSumEco[studyArea == i & c(driver == "LandR" | runName == "reference")]
    All <- bSumEco[studyArea == i]
    aPlot <- ggplot(data = noCS, aes(x = Year, y = Bdiff,  col = runName)) +
      geom_path(size = 1.2, alpha = 0.6) +
      guides(color = guide_legend(override.aes = list(alpha = 1, size = 1.5))) +
      # ylim(0, max(noCS$Bdiff * 1.2)) +
      scale_color_discrete(name = "GCM and SSP") +
      labs(x = "year", y = "biomass relative to reference (Mg/ha)", title = paste("no climate-sensitive growth -", i))
    ggsave(file.path("outputs/summary figures", i, "meanRelBiomassXGCM_noCS.png"), device = "png", dpi = 300, plot = aPlot)

    bPlot <- ggplot(data = CS, aes(x = Year, y = Bdiff,  col = runName)) +
      geom_path(size = 1.2, alpha = 0.6) +
      scale_color_discrete(name = "GCM and SSP") +
      guides(color = guide_legend(override.aes = list(alpha = 1, size = 1.5))) +
      # ylim(min(CS$Bdiff), max(CS$Bdiff * 1.2)) +
      labs(x = "year", y = "biomass relative to reference (Mg/ha)", title = paste("climate sensitive growth -", i))
    ggsave(file.path("outputs/summary figures", i, "meanRelBiomassXGCM_CS.png"), device = "png", dpi = 300, plot = bPlot)

    All[, `growth type` := ifelse(driver == "LandR", "climate-insensitive", "climate-sensitive")]
    cPlot <- ggplot(data = All, aes(x = Year, y = Bdiff, col = runName)) +
      geom_path(size = 1.2, alpha = 0.7, aes(linetype = `growth type`)) +
      guides(color = guide_legend(override.aes = list(alpha = 1, size = 1.5))) +
      scale_color_discrete(name = "GCM and SSP") +
      # ylim(0, max(All$Bdiff * 1.2)) +
      labs(x = "year", y = "biomass relative to reference (Mg/ha)", title = i)
    ggsave(file.path("outputs/summary figures", i, "meanRelBiomassxGCM_all.png"), device = "png", dpi = 300, plot = cPlot)
  }
}

#####  biomassMaps ####
meanBiomass2100 <- Cache(makeMeanBiomassRasters, rt = resultsTable, studyAreaReporting = SARs)

referenceMaps <- meanBiomass2100[grep(names(meanBiomass2100), pattern = "historical")]
projectedMaps <- meanBiomass2100[names(meanBiomass2100) != names(referenceMaps)]

BiomassDiffMaps <- Cache(lapply, studyAreas, compareProjAndRef, SAmaps = projectedMaps,
                   refMap = referenceMaps, operatorFunction = function(proj, ref){proj - ref},
                   userTags = c("BiomassDiffMaps")) #confirm this isn't bugged out without FUN
names(BiomassDiffMaps) <- studyAreas


#percent change maps - these have not proved useful yet #
####decision made to aggregate the maps... to better reflect percentage changes withotu whacky denominators
coarseProjectedMaps <- lapply(projectedMaps, FUN = raster::aggregate, fact = 4, fun = mean, na.rm = TRUE) #1 km cells.
coarseRefMaps <- lapply(referenceMaps, FUN = raster::aggregate, fact = 4, fun = mean, na.rm = TRUE)

#this needs to be corrected for extreme values
BiomassPctChangeMaps <- lapply(studyAreas, FUN = compareProjAndRef, SAmaps = coarseProjectedMaps,
                               refMap = coarseRefMaps, operatorFunction = function(proj, ref){((proj - ref)/ref) * 100})
names(BiomassPctChangeMaps) <- studyAreas


#plotting
myTheme <- BTCTheme()
myTheme$panel.background$col = "white"

if (FALSE) {
  for (i in studyAreas) {

    studyAreaMaps <- raster::stack(BiomassDiffMaps[i])

    names(studyAreaMaps) <- stringr::str_replace(names(studyAreaMaps), pattern = paste0(i, "_"), replacement =  "")

    colBreaks <- seq(-100, 100, by = 20)
    cols <- RColorBrewer::brewer.pal(name = "Spectral", length(colBreaks) - 1)

    myRs <- rasterVis::levelplot(studyAreaMaps, scales = list(draw = FALSE), layout = c(3,2),
                                 layers = c(1,3,5,2,4,6), ylab = "change in biomass (Mg/ha)",
                                 at = colBreaks, col.regions = cols, par.settings = myTheme)

    png(file.path("outputs/summary figures", i, "BiomassChange.png"), width = 6000, height = 3000, res = 300)
    print(myRs)
    dev.off()
  }
  rm(myTheme, cols)
}

####Mosaic those maps
#must use raster:: or it will convert to numeric
BiomassDiffMapsL <-c(raster::as.list(BiomassDiffMaps$WB), raster::as.list(BiomassDiffMaps$WCB), raster::as.list(BiomassDiffMaps$SB))
names(BiomassDiffMapsL) <- unlist(lapply(BiomassDiffMapsL, FUN = names))

RIAmaps <- Cache(MosaicMaps, BiomassDiffMapsL, userTags = c("MosaicMaps", "BiomassDiffMaps"))

RIAmaps <- raster::stack(RIAmaps)
if (FALSE) {
  raster::writeRaster(RIAmaps, filename = "outputs/summary rasters/RIA_biomassChange.grd")
}

SAshp1 <- as_Spatial(SAshp)
colBreaks <- seq(-100, 100, by = 20)
cols <- RColorBrewer::brewer.pal(name = "Spectral", length(colBreaks) - 1)

myRs <- rasterVis::levelplot(RIAmaps, scales = list(draw = FALSE), layout = c(3,2),
                             layers = c(1,3,5,2,4,6), ylab = "change in biomass (Mg/ha)",
                             col.regions = cols, at = colBreaks, par.settings = myTheme,
                             maxpixels = 2e5,
                             panel = function(...){
                               panel.levelplot(...)
                               sp::sp.polygons(SAshp1, col = "black", lwd = 1)
                             }
)

png(file.path("outputs/summary figures/BiomassChange_RIA_byGCM.png"), width = 7000, height = 5000, res = 500, pointsize = )
print(myRs)
dev.off()



#TODO: turn these steps into a function that preps for plotting I guess?
# colBreaks <- seq(0, 350, by = 25)


RIA_totalB <- Cache(MosaicMaps, projectedMaps, userTags = c("MosaicMaps", "RIA_totalB"))
RIA_totalB <- raster::stack(RIA_totalB)

colBreaks <- seq(0, max(RIA_totalB[], na.rm = TRUE), by = 25)
cols <- viridis::viridis(n = length(colBreaks), direction = -1)
RColorBrewer::

myRs1 <- rasterVis::levelplot(RIA_totalB, scales = list(draw = FALSE), layout = c(3,2),
                             layers = c(1,3,5,2,4,6), ylab = "biomass (Mg/ha)",
                             col.regions = cols, at = colBreaks,
                             par.settings = myTheme,
                             panel = function(...){
                               panel.levelplot(...)
                               sp::sp.polygons(SAshp1, col = "black", lwd = 1)
                             }
)

png(file.path("outputs/summary figures/Biomass_RIA_byGCM.png"), width = 10000, height = 3000, res = 300)
print(myRs1)
dev.off()
