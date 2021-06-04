## Google Drive locations for pre-run simulation objects
## these are used when config option 'prerun' is true

if (studyAreaName == "BC") {
  gdriveURL <- "https://drive.google.com/drive/folders/1zq8HT4MKAV8RZv5ggrsDN-dmJt-KeD3_?usp=sharing"
} else if (studyAreaName == "Yukon") {
  gdriveURL <- 'https://drive.google.com/drive/folders/1xoqwH8HSQhDQviImPA6lmPSK1k7ztAQf?usp=sharing'
}

gdriveSims <- switch(
  studyAreaName,
  "BC" = list(
    ## e.g., simOutPreamble = "yyyyyyyyyyyyyyyyyyyyy",  ## use ID only, not full URL
    simOutPreamble = "",
    biomassMaps2001 = "",
    biomassMaps2011 = "",
    fSsimDataPrep = "",
    ignitionOut = "",
    escapeOut = "",
    spreadOut = ""
  ),
  YY = list(
    ## e.g., simOutPreamble = "yyyyyyyyyyyyyyyyyyyyy",  ## use ID only, not full URL
    simOutPreamble = "",
    biomassMaps2001 = "",
    biomassMaps2011 = "",
    fSsimDataPrep = "",
    ignitionOut = "",
    escapeOut = "",
    spreadOut = ""
  )
)
