library(SpaDES.core)
library(googledrive)
library(data.table)

studyAreaName <- "WCB" # "SB", "RIA", "WCB"

spreadFitPaths <- list(
  cachePath = file.path("cache", studyAreaName),
  modulePath = "modules",
  inputPath = "inputs",
  outputPath = file.path("outputs", studyAreaName)
)
do.call(setPaths, spreadFitPaths)

if (studyAreaName == "RIA") {
  gdriveURL <- "https://drive.google.com/drive/folders/1y0SzeFQWZxeKjtsTwD4_XqRPl1rMb_eA"
  ffSsimDataPrep <- file.path(spreadFitPaths$outputPath, paste0("fSsimDataPrep_RIA.qs"))
  #googledrive::drive_download(file = as_id("XXXXX"),
  #                            path = ffSsimDataPrep, overwrite = TRUE) ## TODO: need this
} else if (studyAreaName == "SB") {
  gdriveURL <- "https://drive.google.com/drive/folders/1hhdpf84Oufm5iL_VwqUUmmuI9X0XsbqC"
  ffSsimDataPrep <- file.path(spreadFitPaths$outputPath, paste0("fSsimDataPrep_SB.qs"))
  googledrive::drive_download(file = as_id("1XHNNnQNRuIVufjT-ZVxGJcK2FPgh1NPk"),
                              path = ffSsimDataPrep, overwrite = TRUE)
} else if (studyAreaName == "WCB") {
  gdriveURL <- "https://drive.google.com/drive/folders/1vwrFVb6KCNgdJxh0C25828y76ni3oF7P"
  ffSsimDataPrep <- file.path(spreadFitPaths$outputPath, paste0("fSsimDataPrep_WCB.qs"))
  googledrive::drive_download(file = as_id("1tlqO1W3j3pYxGpugEAl2sug3iTNa3gQk"),
                              path = ffSsimDataPrep, overwrite = TRUE)
}

fSsimDataPrep <- loadSimList(ffSsimDataPrep)

cloudCacheFolderID <- "https://drive.google.com/drive/folders/1zq8HT4MKAV8RZv5ggrsDN-dmJt-KeD3_"
firstRunSpreadFit <- TRUE
useCloudCache <- FALSE

fSsimDataPrep$fireSense_nonAnnualSpreadFitCovariates[[1]] <- as.data.table(fSsimDataPrep$fireSense_nonAnnualSpreadFitCovariates[[1]])
fSsimDataPrep$fireSense_nonAnnualSpreadFitCovariates[[2]] <- as.data.table(fSsimDataPrep$fireSense_nonAnnualSpreadFitCovariates[[2]])
fSsimDataPrep$fireSense_annualSpreadFitCovariates <- lapply(fSsimDataPrep$fireSense_annualSpreadFitCovariates, as.data.table)
fSsimDataPrep$fireBufferedListDT <- lapply(fSsimDataPrep$fireBufferedListDT, as.data.table)

extremeVals <- 4
lowerParamsNonAnnual <- rep(-extremeVals, times = ncol(fSsimDataPrep$fireSense_nonAnnualSpreadFitCovariates[[1]]) - 1)
lowerParamsAnnual <- c(-extremeVals, -extremeVals)
upperParamsNonAnnual <- rep(extremeVals, times = length(lowerParamsNonAnnual))
upperParamsAnnual <- c(extremeVals, extremeVals)
lowerParams <- c(lowerParamsAnnual, lowerParamsNonAnnual)
upperParams <- c(upperParamsAnnual, upperParamsNonAnnual)

## Spread log function bounds

lower <- c(0.25, 0.2, 0.1, lowerParams)
upper <- c(0.286, 2, 4, upperParams)
dfT <- cbind(c("lower", "upper"), t(data.frame(lower, upper)))
message("Upper and Lower parameter bounds are:")
Require:::messageDF(dfT)

cores <- c(rep("localhost", 68), rep("forcast01.local", 32))

spreadFitParams <- list(
  fireSense_SpreadFit = list(
    # "cacheId_DE" = paste0("DEOptim_", studyAreaName), # This is NWT DEoptim Cache
    "cloudFolderID_DE" = cloudCacheFolderID,
    "cores" = cores,
    "DEoptimTests" = c("adTest", "snll_fs"), # Can be one or both of c("adTest", "snll_fs")
    "doObjFunAssertions" = FALSE,
    "iterDEoptim" = 150,
    "iterStep" = 150,
    "iterThresh" = 396L,
    "lower" = lower,
    "maxFireSpread" = max(0.28, upper[1]),
    "mode" = if (isTRUE(firstRunSpreadFit)) c("fit", "visualize") else "fit", ## combo of "debug", "fit", "visualize"
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
    "visualizeDEoptim" = FALSE,
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

fspreadOut <- file.path(Paths$outputPath, paste0("spreadOut_", studyAreaName, ".qs"))

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

googledrive::drive_put(media = fspreadOut, path = gdriveURL, name = basename(fspreadOut), verbose = TRUE)

## Can you also upload these thrto gdriveURL:
filesToUpload <- c("figures/spreadFit_coeffs.png")

lapply(filesToUpload, function(f) {
  drive_upload(file.path("outputs", studyAreaName, f), as_id(gdriveURL), overwrite = TRUE)
})
