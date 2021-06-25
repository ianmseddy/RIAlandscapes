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
  "BC_CSIRO-Mk3_RCP85_1" = "1HaR46ocCS3tJTW1vdRZ2KWlEzZb-oxSk", # ha burned: 2,416,106 mean biomass: 65.9 Mg/ha
  "BC_CSIRO-Mk3_RCP45_1" = NA, ################################# ha burned: 2,574,050 mean biomass: 65.8 Mg/ha
  "BC_Access1_RCP45_1" = "1HPgLw6BVnUDXBEJ09UBFa4rxPv1fKb-I", #ha burned: 3,176,050 mean biomass:  63.5 Mg/ha
  "BC_Access1_RCP85_2" =  "1ix6pgiCQNma7xlefRk1WSmOxeT05qSXU", #ha burned: 3,707,181 mean biomass: 60.98 mg/ha
  "BC_Access1_RCP85_1" = "1qIkuLc45T_2a7lDK4ABp6gRialfIJcVZ", #ha burned: 3,609,369. mean biomass: 61.2 Mg/ha
  "BC_INM_CM4_RCP45_1" = "1_HU_GHl0pC7F0b_UOvavUyXYWwdgdvWl", #ha burned: 2,152,356 mean biomass: 65.1 Mg/ha
  "BC_INM_CM4_RCP85_1" = "1ENRDFzb0nQGXVsL-H9xyVHuKx5GyP5L3", #ha burned: 2,154,944 mean biomass: 67.0 Mg/ha
  "BC_CanESM2_RCP45_1" = "1xE02E74_UQy5P_A62EXfxx26jLgVTX05", #ha burned: 5,048,144 mean biomass: 67.1 Mg/ha
  "BC_CanESM2_RCP45_2" =  "13BF_aGve-QsPsjmKheQTsCDL3md86Ikn" #ha burned; 4,921,981 mean biomass: 67.5 Mg/ha


)
