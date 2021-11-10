do.call(setPaths, ignitionFitPaths)

source("05-google-ids.R")
newGoogleIDs <- gdriveSims[["ignitionOut"]] == ""

## ub and lb have to be provided for now

biggestObj <- as.numeric(object.size(fSsimDataPrep[["fireSense_ignitionCovariates"]]))/1e6 * 1.2

fSsimDataPrep$fireSense_ignitionCovariates <- as.data.table(fSsimDataPrep$fireSense_ignitionCovariates)

nCores <- pmin(16, pemisc::optimalClusterNum(biggestObj)/2 - 6)

#remove youngAge where it is a fraction of the data, as well as nf_l
#whether or not pine shoudl be separate is a different question
tempFormula <- switch(studyAreaName,
                      "WCB"= { paste0("ignitions ~ nf_hf:MDC + nf_lf:MDC + class2:MDC + class3:MDC + ",
                                      "nf_hf:pw(MDC, k_nf_h) + nf_lf:pw(MDC, k_nf_l) + ",
                                      "class3:pw(MDC, k_cl3)- 1")},
                      "SB"= { paste0("ignitions ~ nf_hf:MDC + class2:MDC + class3:MDC + class4:MDC + ",
                                     "nf_hf:pw(MDC, k_nf_h) + class3:pw(MDC, k_cl3)",
                                     " + class4:pw(MDC, k_cl4) - 1")},
                      #this gives pine high ig at high MDC, low at low relative to other conifers
                      #otherwise the rate for grassland is stupid high, or convergence issues, or deciduous is more flammable
                      "WB" = { paste0("ignitions ~ nf_hf:MDC + class2:MDC + class3:MDC + ",
                                     "nf_hf:pw(MDC, k_nf_h) + ",
                                     "class3:pw(MDC, k_cl3) - 1")}

)
ignitionFitParams <- list(
  fireSense_IgnitionFit = list(
    cores = nCores,
    # fireSense_ignitionFormula = fSsimDataPrep$fireSense_ignitionFormula,
    fireSense_ignitionFormula = tempFormula,
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

