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
    fSsimDataPrep = "14lvEmS7d4oipgLeRIA4UIA1nj-1PMr0f",
    ignitionOut = "1_SpyfSzTPd70phPlJhr1dclgg2qw4MWT",
    escapeOut = "1sX2PbmoY5ESkgs8BWZAR-niVuFyU2xB0",
    spreadOut = "1ybSeXJfer8_4IVnDscW9U3O8dpyww6t9",
    results = "https://drive.google.com/drive/folders/1n5mfIzvqAEpCewiXntWyAJ149SDyX9lY?usp=sharing"
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

gdriveResults <- list(
  "BC_CSIRO-Mk3_RCP85_1" = "1HaR46ocCS3tJTW1vdRZ2KWlEzZb-oxSk",
  "BC_Access1_RCP45_1" = "1HPgLw6BVnUDXBEJ09UBFa4rxPv1fKb-I"

)
