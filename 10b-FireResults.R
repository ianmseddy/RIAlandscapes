#10b-fireSummary
library(ggplot2)
library(zoo)

resultsTable <- buildResultsTable(studyAreaName = "SB")

burnSumFun <- function(run, rt) {
  thisRun <- rt[fileLocation == run,]
  simList <- qs::qread(file = file.path(thisRun$fileLocation, paste0(thisRun$filename, ".qs")))
  burnSummary <- as.data.table(simList$burnSummary)
  # burnSummary[, decade := round(year/10) * 10]
  # burnSummaryDecade <- burnSummary[, .(burnSum = sum(areaBurnedHa),
  #                                      mfs = mean(areaBurnedHa),
  #                                      sdMFS = sd(areaBurnedHa),
  #                                      Nfires = .N), .(decade)]
  burnSummary[, `:=`(
    GCM = thisRun$GCM,
    SSP = thisRun$SSP,
    driver = thisRun$driver,
    rep = thisRun$rep
  )]

  rm(simList)
  return(burnSummary)
}
burnSummaries <- Cache(lapply, resultsTable$fileLocation, burnSumFun, rt = resultsTable)

burnSummaries <- rbindlist(burnSummaries)
burnSummaries[, runName := as.factor(paste(GCM, SSP, sep = " "))]
burnSum <- burnSummaries[, .(AAB = sum(areaBurnedHa), Nfires = .N), .(year, runName, rep)]
burnSum[, rollMeanAAB := frollmean(AAB, n = 10, fill = NA, align = 'right'), .(runName, rep)]
burnSum[, rollMeanFires := frollmean(Nfires, n = 10, fill = NA, align = 'right'), .(runName, rep)]
burnSum <- burnSum[, .(MAABx10 = mean(rollMeanAAB), nFiresx10 = mean(rollMeanFires)), .(runName, year)]

#will need to split into wide
#calculate the rolling mean and standard deviation of burn area and fires
burnSum <- burnSum[!is.na(nFiresx10)]
ggplot(data = burnSum, aes(x = year, y = MAABx10, col = runName)) +
  geom_line(size = 1.3) +
  # geom_line(size = 2, alpha = 0.5) +
  labs(x = "year", y = "rolling 10-year mean annual area burned (ha)", title = "Sub-Boreal") +
  scale_color_discrete("GCM and SSP")

ggplot(data = burnSum, aes(x = year, y = nFiresx10, col = runName)) +
  geom_line(size = 1.5) +
  ylim(0, max(burnSum$nFiresx10) * 1.1) +
  labs(x = "year", y = "10-year mean no. of ignitions", title = "Sub-Boreal") +
  scale_color_discrete("GCM and SSP") +
  theme_bw()
