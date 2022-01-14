#10b-fireSummary
library(ggplot2)
resultsTable <- buildResultsTable(studyAreaName = "SB")

burnSummaries <- lapply(resultsTable$fileLocation, FUN = function(run, rt = resultsTable) {
  thisRun <- rt[fileLocation == run,]
  simList <- qs::qread(file = file.path(thisRun$fileLocation, paste0(thisRun$filename, ".qs")))
  burnSummary <- as.data.table(simList$burnSummary)
  burnSummary[, decade := round(year/10) * 10]
  burnSummaryDecade <- burnSummary[, .(burnSum = sum(areaBurnedHa),
                                       mfs = mean(areaBurnedHa),
                                       sdMFS = sd(areaBurnedHa),
                                       Nfires = .N), .(decade)]
  burnSummaryDecade[, `:=`(
    GCM = thisRun$GCM,
    RCP = thisRun$RCP,
    driver = thisRun$driver,
    rep = thisRun$rep
  )]
  rm(simList)
  return(burnSummaryDecade)
})
burnSummaries <- rbindlist(burnSummaries)

BS <- burnSummaries[, .(meanAAB = mean(burnSum)/10, sdAAB = sd(burnSum)/10), .(GCM, RCP, decade)]
BS[, runName := as.factor(paste(GCM, RCP, sep = " "))]

ggplot(data = BS, aes(x = decade, y = meanAAB, col = runName)) +
  geom_line(size = 1.5, alpha = 0.6) +
  geom_ribbon(data = BS, aes(ymax = meanAAB + sdAAB, ymin = meanAAB - sdAAB), alpha = 0.3) +
  labs(x = "year", y = "mean annual area burned (ha)") +
  scale_fill_discrete(name = "GCM and RCP")
