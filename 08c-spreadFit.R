do.call(setPaths, spreadFitPaths)

source("05-google-ids.R")


fSsimDataPrep$fireSense_nonAnnualSpreadFitCovariates[[1]] <- as.data.table(fSsimDataPrep$fireSense_nonAnnualSpreadFitCovariates[[1]])
fSsimDataPrep$fireSense_nonAnnualSpreadFitCovariates[[2]] <- as.data.table(fSsimDataPrep$fireSense_nonAnnualSpreadFitCovariates[[2]])
fSsimDataPrep$fireSense_annualSpreadFitCovariates <- lapply(fSsimDataPrep$fireSense_annualSpreadFitCovariates, as.data.table)
fSsimDataPrep$fireBufferedListDT <- lapply(fSsimDataPrep$fireBufferedListDT, as.data.table)

extremeVals <- 4
lowerParamsNonAnnual <- rep(-extremeVals, times = ncol(fSsimDataPrep$fireSense_nonAnnualSpreadFitCovariates[[1]]) - 1)
lowerParamsAnnual <- c(-extremeVals, -extremeVals)
upperParamsNonAnnual <- rep(0, extremeVals) #zero for youngAge (assumes YA is first formula term)
upperParamsAnnual <- c(extremeVals, extremeVals)
lowerParams <- c(lowerParamsAnnual, lowerParamsNonAnnual)
upperParams <- c(upperParamsAnnual, upperParamsNonAnnual)

## Spread log function bounds

lower <- c(0.25, 0.2, 0.1, lowerParams)
upper <- c(0.276, 2, 4, upperParams) #adjusted down from 0.286
dfT <- cbind(c("lower", "upper"), t(data.frame(lower, upper)))
message("Upper and Lower parameter bounds are:")
Require:::messageDF(dfT)

cores <- rep("localhost", parallel::detectCores() / 2)

spreadFitParams <- list(
  fireSense_SpreadFit = list(
    # "cacheId_DE" = paste0("DEOptim_", studyAreaName), # This is NWT DEoptim Cache
    "cloudFolderID_DE" = cloudCacheFolderID,
    "cores" = cores,
    "DEoptimTests" = c("adTest", "snll_fs"), # Can be one or both of c("adTest", "snll_fs")
    "doObjFunAssertions" = FALSE,
    "iterDEoptim" = 160,
    "iterStep" = 160,
    "iterThresh" = 396L,
    "lower" = lower,
    "mutuallyExclusiveCols" = ifelse(fuelClasses, list("youngAge" = c("class", "nf_")), list("youngAge" = "vegPC")),
    "maxFireSpread" = max(0.28, upper[1]),
    "mode" = c("fit", "visualize"), ## combo of "debug", "fit", "visualize"
    "NP" = length(cores),
    "objFunCoresInternal" = 1L,
    "objfunFireReps" = 100,
    #"onlyLoadDEOptim" = FALSE,
    "rescaleAll" = TRUE,
    "trace" = 1,
    "SNLL_FS_thresh" = if (peutils::user("emcintir")) NULL else NULL,# NULL means 'autocalibrate' to find suitable threshold value
    "upper" = upper,
    #"urlDEOptimObject" = if (peutils::user("emcintir")) "spreadOut_2021-02-11_Limit4_150_SNLL_FS_thresh_BQS16t" else NULL,
    "useCloud_DE" = useCloudCache,
    "verbose" = TRUE,
    "visualizeDEoptim" =  FALSE,
    "useCloud_DE" = useCloudCache,
    ".plot" = if (isTRUE(firstRunSpreadFit)) TRUE else FALSE,
    ".plotSize" = list(height = 1600, width = 2000)
  )
)

spreadFitObjects <- list(
  fireBufferedListDT = fSsimDataPrep[["fireBufferedListDT"]],
  firePolys = fSsimDataPrep[["firePolys"]],
  fireSense_annualSpreadFitCovariates = fSsimDataPrep[["fireSense_annualSpreadFitCovariates"]],
  fireSense_nonAnnualSpreadFitCovariates = fSsimDataPrep[["fireSense_nonAnnualSpreadFitCovariates"]],
  fireSense_spreadFormula = fSsimDataPrep[["fireSense_spreadFormula"]],
  flammableRTM = fSsimDataPrep[["flammableRTM"]],
  #parsKnown = spreadOut$fireSense_SpreadFitted$meanCoef,
  rasterToMatch = fSsimDataPrep[["rasterToMatch"]],
  spreadFirePoints = fSsimDataPrep[["spreadFirePoints"]],
  studyArea = fSsimDataPrep[["studyArea"]]
)

spreadName <- ifelse(fuelClasses, "spreadOut_fuelClass", "spreadOut")
newGoogleIDs <- gdriveSims[[spreadName]] == ""
fspreadOut <- file.path(Paths$outputPath, paste0(spreadName, studyAreaName, ".qs"))
if (isTRUE(usePrerun)) {
  if (!file.exists(fspreadOut)) {
    googledrive::drive_download(file = as_id(gdriveSims[[spreadName]]), path = fspreadOut)
  }
  spreadOut <- loadSimList(fspreadOut)
} else {
  spreadOut <- Cache(
    simInitAndSpades,
    times = list(start = 0, end = 1),
    params = spreadFitParams,
    modules = "fireSense_SpreadFit",
    paths = spreadFitPaths,
    objects = spreadFitObjects,
    #useCloud = useCloudCache,
    #cloudFolderID = cloudCacheFolderID,
    userTags = c("fireSense_SpreadFit", studyAreaName)
  )
  saveSimList(
    sim = spreadOut,
    filename = fspreadOut,
    #filebackedDir = dspreadOut,
    fileBackend = 2
  )
  if (isTRUE(newGoogleIDs) | length(newGoogleIDs) == 0) {
    googledrive::drive_put(media = fspreadOut, path = gdriveURL, name = basename(fspreadOut), verbose = TRUE)
  } else {
    googledrive::drive_update(file = as_id(gdriveSims[[spreadName]]), media = fspreadOut)
  }
}

if (firstRunSpreadFit) {
  filesToUpload <- c("fireSense_SpreadFit_veg_coeffs.txt",
                   "figures/PCAcoeffLoadings.png",
                   "figures/spreadFit_coeffs.png")

  gdrive_ID <- switch(studyAreaName,
                      XX = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",  ## TODO: customize
                      YY = "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy")
  lapply(filesToUpload, function(f) {
    drive_upload(file.path("outputs", studyAreaName, f), as_id(gdrive_ID), overwrite = TRUE)
  }) ## TODO: upload first time, update subsequently.
}

if (requireNamespace("slackr") & file.exists("~/.slackr")) {
  slackr::slackr_setup()
  slackr::slackr_msg(
    paste0("`fireSense_SpreadFit` for ", studyAreaName, " completed on host `", Sys.info()[["nodename"]], "`."),
    channel = config::get("slackchannel"), preformatted = FALSE
  )
}
