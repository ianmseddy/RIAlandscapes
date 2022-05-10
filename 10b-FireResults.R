#10b-fireSummary
library(ggplot2)
library(zoo)
library(rasterVis)
library(RColorBrewer)
library(stringr)
library(sf)
library(data.table)
library(nngeo) #needed for remove holes
source("10-functions.R")
resultsTable <- buildResultsTable(allRunInfo = allRunInfo)
resultsTable[is.na(SSP), SSP := ""]
resultsTable[GCM == "historical", GCM := "reference"]

studyAreas <- c("WB", "WCB", "SB")
SARs <- getStudyAreaReporting(studyAreas)

tempSAR <- lapply(SARs, st_as_sf)
SAshp <- rbind(tempSAR$WB, tempSAR$WCB, tempSAR$SB)
SAshp <- nngeo::st_remove_holes(SAshp)

rm(tempSAR)
#get rid of NA
burnSummaries <- Cache(lapply, resultsTable$fileLocation, burnSumFun, rt = resultsTable)
burnSummaries <- rbindlist(burnSummaries)
burnSummaries[, SSP := as.character(SSP)]

#Fix up the SSP label
burnSummaries[, realSSP := paste0(substr(SSP, start = 1, stop = 1), " ",
                            substr(SSP, start = 2, stop = 2), ".",
                            substr(SSP, start = 3, stop = 3))]

burnSummaries[, runName := as.factor(paste(GCM, "SSP", realSSP, sep = " "))]
burnSum <- burnSummaries[, .(AAB = sum(areaBurnedHa), Nfires = .N), .(studyArea, year, runName, rep, GCM)]
burnSum[GCM == "reference", runName := "reference"]

meanAAB <- burnSum[, .(meanAAB = mean(AAB)), .(studyArea, runName)]
refAAB <- meanAAB[runName == "reference", .(studyArea, meanAAB)]

setnames(refAAB, "meanAAB", "refAAB")
meanAAB <- refAAB[meanAAB, on = c("studyArea")]
meanAAB[, changeAAB := round(c(meanAAB - refAAB)/(refAAB) * 100, digits = 1)]
setkey(meanAAB, studyArea, runName)
meanAAB <- meanAAB[!runName == "reference"]
firePlot <- ggplot(data = meanAAB, aes(y = changeAAB, x= runName)) +
  geom_bar(position = position_dodge(), stat = 'identity') +
  ylab("change in mean annual area burned (%)") +
  xlab ("GCM and SSP") +
  facet_wrap(nrow = 3, facets = ~studyArea) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
ggsave(firePlot, filename = "outputs/summary figures/changeInAAB.png", device = 'png', dpi = 300)
# burnSum[, rollMeanAAB := frollmean(AAB, n = 10, fill = NA, align = 'right'), .(studyArea, runName, rep, GCM)]
# burnSum[, rollMeanFires := frollmean(Nfires, n = 10, fill = NA, align = 'right'), .(studyArea, runName, rep, GCM)]

#will need to split into wide
#calculate the rolling mean and standard deviation of burn area and fires
for (i in unique(burnSum$studyArea)) {
  burnSumSA <- burnSum[studyArea == i]
  gPlot <- ggplot(data = burnSumSA, aes(x = year, y = AAB/100, col = runName)) +
    geom_line(size = 0.5, alpha = 0.5) +
    geom_smooth(alpha = 0.1, se = FALSE, size = 1.1) +
    labs(x = "year", y = "annual area burned (km2)", title = unique(burnSumSA$studyArea)) +
    scale_color_discrete("GCM and SSP") +
    theme_bw()
  ggsave(file.path("outputs/summary figures", i, paste0(i, "_MAABxYearxGCM.png")))
  gPlot <- ggplot(data = burnSumSA, aes(x = year, y = Nfires, col = runName)) +
    geom_line(size = 0.5, alpha = 0.5) +
    geom_smooth(alpha = 0.1, se = FALSE) +
    ylim(0, max(burnSumSA$Nfires) * 1.1) +
    labs(x = "year", y = "annual fire count", title = unique(burnSumSA$studyArea)) +
    scale_color_discrete("GCM and SSP") +
    theme_bw()
  ggsave(file.path("outputs/summary figures", i, paste0(i, "_NFiresxYearXGCM.png")))
}


#### spatial fire results ####
#average the 2100 burn maps of each scenari
cumulativeBurnMaps <- Cache(makeMeanBurnRasters, resultsTable, studyAreaReporting = SARs,
                            userTags = c("makeMeanBurnRasters"))
#use levelplot from rasterVis
referenceMaps <- cumulativeBurnMaps[grep(names(cumulativeBurnMaps), pattern = "reference")]
projectedMaps <- cumulativeBurnMaps[names(cumulativeBurnMaps) != names(referenceMaps)]
myTheme <- BTCTheme()
myTheme$panel.background$col = "grey"
cols <- viridis::plasma(n = 18)


if (FALSE) {
  for (i in studyAreas) {
  studyAreaMaps <- raster::stack(projectedMaps[grep(names(projectedMaps), pattern = i)])
  names(studyAreaMaps) <- stringr::str_replace(names(studyAreaMaps), pattern = paste0(i, "_"), replacement =  "")

  studyAreaMaps[studyAreaMaps == 0] <- NA
  myRs <- rasterVis::levelplot(studyAreaMaps, scales = list(draw = FALSE), layout = c(3,2),
                               layers = c(1,3,5,2,4,6), ylab = "mean cumulative burn",
                               col.regions = cols, par.settings = myTheme)
  png(file.path("outputs/summary figures", i, "cumulativeBurnMap.png"), width = 6000, height = 3000, res = 300)
  print(myRs)
  dev.off()
  }
  rm(myTheme, cols)
}

####Mosaic those maps
RIAmaps <- Cache(MosaicMaps, projectedMaps, userTags = c("MosaicMaps"))
RIAmaps <- raster::stack(RIAmaps)
if (FALSE) {
  raster::writeRaster(RIAmaps, filename = "outputs/summary rasters/RIA_cumulativeBurnMap.grd")
}
temp <- RIAmaps
temp[temp[] == 0] <- NA
SAshp1 <- as_Spatial(SAshp)

myRs <- rasterVis::levelplot(temp, scales = list(draw = FALSE), layout = c(3,2),
                             layers = c(1,3,5,2,4,6), ylab = "mean cumulative burn",
                             col.regions = cols, par.settings = myTheme,
                             panel = function(...){
                               panel.levelplot(...)
                               sp::sp.polygons(SAshp1, col = "white", lwd = 1)
                             }
)

png(file.path("outputs/summary figures/cumulativeBurnMap_RIA_byGCM.png"), width = 6000, height = 3000, res = 300)
print(myRs)
dev.off()


RIAreference <- MosaicMaps(referenceMaps)
RIAreference <- raster::stack(RIAreference)
RIAreference[RIAreference[] == 0] <- NA
out <- levelplot(RIAreference, scales = list(draw = FALSE),
          ylab = "mean cumulative burn",
          col.regions = cols, par.settings = myTheme,
          panel = function(...){
            panel.levelplot(...)
            sp::sp.polygons(SAshp1, col = "white", lwd = 1)
          }
)

png(file.path("outputs/summary figures/cumulativeBurnMap_RIA_Reference.png"), width = 6000, height = 3000, res = 300)
print(out)
dev.off()

