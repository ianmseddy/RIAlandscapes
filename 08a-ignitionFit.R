do.call(setPaths, ignitionFitPaths)

source("05-google-ids.R")
newGoogleIDs <- gdriveSims[["ignitionOut"]] == ""

## ub and lb have to be provided for now

biggestObj <- as.numeric(object.size(fSsimDataPrep[["fireSense_ignitionCovariates"]]))/1e6 * 1.2

fSsimDataPrep$fireSense_ignitionCovariates <- as.data.table(fSsimDataPrep$fireSense_ignitionCovariates)
if (any(grep("class4", names(fSsimDataPrep$fireSense_ignitionCovariates)))) {
  fSsimDataPrep$fireSense_ignitionFormula <- paste0("ignitions ~ youngAge:MDC + nonForest_highFlam:MDC + ",
                                                    "nonForest_lowFlam:MDC + class2:MDC + class3:MDC + class4:MDC + ",
                                                    "youngAge:pw(MDC, k_YA) + nonForest_lowFlam:pw(MDC, k_NFLF) + ",
                                                    "nonForest_highFlam:pw(MDC, k_NFHF) + class2:pw(MDC, k_class2) + ",
                                                    "class3:pw(MDC, k_class3) + class4:pw(MDC, K_class4) - 1")

}

nCores <- pmin(16, pemisc::optimalClusterNum(biggestObj)/2 - 6)
ignitionFitParams <- list(
  fireSense_IgnitionFit = list(
    cores = nCores,
    # fireSense_ignitionFormula = fSsimDataPrep$fireSense_ignitionFormula,
    fireSense_ignitionFormula = fSsimDataPrep$fireSense_ignitionFormula,
    ## if using binomial need to pass theta to lb and ub
    lb = list(coef = 0,
              knots = list(MDC = round(quantile(fSsimDataPrep[["fireSense_ignitionCovariates"]]$MDC,
                                                probs = 0.05), digits = 0))),
    ub = list(coef = 20,
              knots = list(MDC = round(quantile(fSsimDataPrep[["fireSense_ignitionCovariates"]]$MDC,
                                                probs = 0.8), digits = 0))),
    family = quote(MASS::negative.binomial(theta = 1, link = "identity")),
    iterDEoptim = 500,
    .plots = "png" #trying this
  )
)

ignitionFitObjects <- list(
  fireSense_ignitionCovariates = fSsimDataPrep[["fireSense_ignitionCovariates"]],
  # fireSense_ignitionCovariates = tempDat,
  ignitionFitRTM = fSsimDataPrep[["ignitionFitRTM"]]
)

fignitionOut <- file.path(Paths$outputPath, paste0("ignitionOut_", studyAreaName, ".qs"))
if (isTRUE(usePrerun)) {
  if (!file.exists(fignitionOut)) {
    googledrive::drive_download(file = as_id(gdriveSims[["ignitionOut"]]), path = fignitionOut, overwrite = TRUE)
  }
  ignitionOut <- loadSimList(fignitionOut)
} else {
  ignitionOut <- Cache(simInitAndSpades,
                       times = list(start = 0, end = 1),
                       # ignitionSim <- simInit(times = list(start = 0, end = 1),
                       params = ignitionFitParams,
                       modules = "fireSense_IgnitionFit",
                       paths = ignitionFitPaths,
                       objects = ignitionFitObjects,
                       userTags = c("ignitionFit")
  )
  saveSimList(
    sim = ignitionOut,
    filename = fignitionOut,
    #filebackedDir = dignitionOut,
    fileBackend = 2
  )
  if (isTRUE(newGoogleIDs) | length(newGoogleIDs) == 0) {
    googledrive::drive_put(media = fignitionOut, path = gdriveURL, name = basename(fignitionOut), verbose = TRUE)
  } else {
    googledrive::drive_update(file = as_id(gdriveSims[["ignitionOut"]]), media = fignitionOut)
  }
}

if (requireNamespace("slackr") & file.exists("~/.slackr")) {
  slackr::slackr_setup()
  slackr::slackr_msg(
    paste0("`fireSense_IgnitionFit` for ", studyAreaName, " completed on host `", Sys.info()[["nodename"]], "`."),
    channel = config::get("slackchannel"), preformatted = FALSE
  )
}

