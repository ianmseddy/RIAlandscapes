#10b-fireSummary
library(ggplot2)
library(zoo)

resultsTable <- buildResultsTable(allRunInfo = allRunInfo)
resultsTable <- resultsTable[!studyArea == "WB"]

#get rid of NA
burnSummaries <- Cache(lapply, resultsTable$fileLocation, burnSumFun, rt = resultsTable)
burnSummaries <- rbindlist(burnSummaries)
burnSummaries[, SSP := as.character(SSP)]
burnSummaries[is.na(SSP), SSP := ""]

burnSummaries[, runName := as.factor(paste(GCM, SSP, sep = " "))]
burnSum <- burnSummaries[, .(AAB = sum(areaBurnedHa), Nfires = .N), .(studyArea, year, runName, rep)]
burnSum[, rollMeanAAB := frollmean(AAB, n = 10, fill = NA, align = 'right'), .(studyArea, runName, rep)]
burnSum[, rollMeanFires := frollmean(Nfires, n = 10, fill = NA, align = 'right'), .(studyArea, runName, rep)]
burnSum <- burnSum[, .(MAABx10 = mean(rollMeanAAB), nFiresx10 = mean(rollMeanFires)), .(studyArea, runName, year)]

#will need to split into wide
#calculate the rolling mean and standard deviation of burn area and fires
burnSum <- burnSum[!is.na(nFiresx10)]
for (i in unique(burnSum$studyArea)) {
  burnSumSA <- burnSum[studyArea == i]
  gPlot <- ggplot(data = burnSumSA, aes(x = year, y = MAABx10/100, col = runName)) +
    geom_line(size = 1.3, alpha = 0.7) +
    # geom_line(size = 2, alpha = 0.5) +
    labs(x = "year", y = "rolling 10-year mean annual area burned (km2)", title = unique(burnSumSA$studyArea)) +
    scale_color_discrete("GCM and SSP") +
    theme_bw()
  ggsave(file.path("outputs/summary figures", i, "rollingMAAB.png"))
  gPlot <- ggplot(data = burnSumSA, aes(x = year, y = nFiresx10, col = runName)) +
    geom_line(size = 1.3, alpha = 0.7) +
    ylim(0, max(burnSumSA$nFiresx10) * 1.1) +
    labs(x = "year", y = "rolling 10-year mean annual fires", title = unique(burnSumSA$studyArea)) +
    scale_color_discrete("GCM and SSP") +
    theme_bw()
  ggsave(file.path("outputs/summary figures", i, "rollingNoFires.png"))
}


#### spatial fire results ####
#average the 2100 burn maps of each scenario

makeMeanBurnRasters <-


