## Google Drive locations for pre-run simulation objects
## these are used when config option 'prerun' is true

if (studyAreaName == "BC") {
  gdriveURL <- "https://drive.google.com/drive/folders/1zq8HT4MKAV8RZv5ggrsDN-dmJt-KeD3_?usp=sharing"
} else if (studyAreaName == "Yukon") {
   gdriveURL <-  "https://drive.google.com/drive/folders/1zq8HT4MKAV8RZv5ggrsDN-dmJt-KeD3_?usp=sharing"
} else if (studyAreaName == "RIA") {
  gdriveURL <- "https://drive.google.com/drive/folders/1y0SzeFQWZxeKjtsTwD4_XqRPl1rMb_eA?usp=sharing"
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
  "Yukon" = list(
    ## e.g., simOutPreamble = "yyyyyyyyyyyyyyyyyyyyy",  ## use ID only, not full URL
    simOutPreamble = "",
    biomassMaps2001 = "1vcU9GeSKj2YqMfQTwqnaxOlkbeAfZYKW",
    biomassMaps2011 = "1dYEGipMDf0iV1yniJ8SiOeYETSNoRcXd",
    fSsimDataPrep = "1WrvvZrUZ9GER9eS-jHRDPZhrXxGtYsGT",
    ignitionOut = "1gMRfi4wY1V9cjNFbOCKwznIGjJuXpc4j",
    escapeOut = "11LNR-Iwdd2Lq6EWpCbPBx4NOs56Vm29w",
    spreadOut = "1PVEBMf6ddkxyje3QIunq83e371tYbFBC",
    results = "https://drive.google.com/drive/folders/1xoqwH8HSQhDQviImPA6lmPSK1k7ztAQf?usp=sharing"
  ),
  "RIA" = list(
    biomassMaps2001 = '1jSdaULcq6H0W9tegYn6YyG1HkJFDqQ85',
    biomassMaps2011 = "1-BDaGZTfZh1I3tVW-hQdNs_rx47exX9X",
    fSsimDataPrep = "1ViwF9OWBG4_7U9mStWLpNOT5BqPJ5Zv3",
    ignitionOut = "1snGvTH27oIe6MlSLplcyKy099bOb7ibC",
    escapeOut = "1imexXvXM8VFjCp_UCKhK7Krdd_kwCi8Q",
    spreadOut = "12hjVsWmFCX8rtorOUyCc5UvCqloq7c-8"
  )
)

gdriveResults <- list(
  "BC_CSIRO-Mk3_RCP85_1" = "1oN7C-WFe-J3AUO9eWZRLk3M-tlRKVjhX", # ha burned: 5,348,888 mean biomass: 61.9 Mg/ha
  "BC_CSIRO-Mk3_RCP85_2" = "1C-bzpeybrPpBik-W_Pb9G8jycuDdYzix", # ha burned: 5,446,850 mean biomass: 62.2 Mg/ha
  "BC_CSIRO-Mk3_RCP85_3" = "1M-wGzSvLn-Q6Nvj5RUGIam8IaXbsSZwL", # ha burned: 3,431,069 mean bimoass: 64.3 Mg/ha
  "BC_CSIRO-Mk3_RCP45_1" = "1hnn4iDwXla7_qBdEEh3brPP0IIDIumr-", # ha  burned: 2,462,269 mean biomass: 66.0 Mg/ha
  "BC_CSIRO-Mk3_RCP45_2" = "1E3i9eqJ_S8SIBAhwrgYg3KBUoOowazTI", # ha burned: 2,632,500 mean biomass: 66.0 Mg/ha
  "BC_CSIRO-Mk3_RCP45_3" = "1GCPt_jAJA_wI71wrrijun9Xjau2b1TBo", #ha burned: 2,458,656, mean biomass: 66.1 Mg/ha
  "BC_Access1_RCP45_1" = "1HPgLw6BVnUDXBEJ09UBFa4rxPv1fKb-I", # ha burned: 3,176,050 mean biomass:  63.5 Mg/ha
  "BC_Access1_RCP45_2" = "11FStJrq52VR1e_x86hPv6rkNcU809qpy", #ha burned: 2,968,488 mean biomass: 63.6 Mh/ha
  "BC_Access1_RCP45_3" = "1LUmJy2irM9zamP_bahgc3EBCIexFg9oj", #ha burned: 3,368,288 mean biomass: 64.4 Mg/ha
  "BC_Access1_RCP85_2" =  "1ix6pgiCQNma7xlefRk1WSmOxeT05qSXU", # ha burned: 3,707,181 mean biomass: 60.98 mg/ha
  "BC_Access1_RCP85_1" = "1qIkuLc45T_2a7lDK4ABp6gRialfIJcVZ", # ha burned: 3,609,369. mean biomass: 61.2 Mg/ha
  "BC_Access1_RCP85_3" = "1WilixGkfOXz6RLbmrlYWA5z4PrNWsGf4", # ha burned: 3,694,356 mean biomass: 61.2 Mg/ha
  "BC_INM-CM4_RCP45_1" = "1_HU_GHl0pC7F0b_UOvavUyXYWwdgdvWl", # ha burned: 2,152,356 mean biomass: 65.1 Mg/ha
  "BC_INM-CM4_RCP45_2" = "1ICCFcsDAVa0dCJihADMYp1MSikeOThcy", # ha burned : 2,093,700 mean biomass: 65.4 Mg/ha
  "BC_INM-CM4_RCP45_3" =  "15x0EUykIWgzeS49znwQ205dLXxV38sN3", #ha burned: 1,305,231 mean biomass: 66.7 Mg/ha
  "BC_INM-CM4_RCP85_1" = "1ENRDFzb0nQGXVsL-H9xyVHuKx5GyP5L3", # ha burned: 2,154,944 mean biomass: 67.0 Mg/ha
  "BC_INM-CM4_RCP85_2" =  "1znYInI9KmecksPG7TF9s3hFm9YjyHXjm", # ha burned: 2,230,112 mean biomass: 67.42 Mg/ha
  "BC_CanESM2_RCP45_1" = "1xE02E74_UQy5P_A62EXfxx26jLgVTX05", # ha burned: 5,048,144 mean biomass: 67.1 Mg/ha
  "BC_CanESM2_RCP45_2" =  "13BF_aGve-QsPsjmKheQTsCDL3md86Ikn", # ha burned: 4,921,981 mean biomass: 67.5 Mg/ha
  "BC_CanESM2_RCP45_3" = "13UBeXaW9XylB6V-lQoBKindU4oZ_b65A", #ha burned: 5,096,669 mean biomass: 67.6 Mg/ha
  "BC_CanESM2_RCP85_1" =  "1fAfNoxaimEey_y0JD6vH36WxElkPUJka", # ha burned: 4,432,338 mean biomass: 67.4 Mg/ha
  "BC_CanESM2_RCP85_2" =  "1T_o-vhasa6d1rgTGnId2LYMA4q8yO-bf", #ha burned: 4,331,200 mean biomass: 67.33 Mg/ha
  ###### Yukon #####
  "Yukon_CSIRO-Mk3_RCP45_1" = "1UBRyZYIsgLShNeb_b0sfpeABkWdz_5WI", # ha burned: 12,753,362 mean biomass: 28 Mg/ha
  "Yukon_CSIRO-Mk3_RCP45_2" = "1hr5oRkSHoTUZdkMaqo1KgjXFin2esREV", #ha burned: 12,029,156 mean biomass: 29.2 Mg/ha
  "Yukon_CSIRO-Mk3_RCP45_3" = "1pl9I8l1j0z4CxN3igadyhORqY72wUHQY", #ha burned: 11,150,719, mean biomass: 29.1 Mg/ha
  "Yukon_CSIRO-Mk3_RCP85_1" = "1acgHrSYLjl_KDWOnC-_gX1FhuhHhXipu", # ha burned: 12,193,931 mean biomass: 29.1 Mg/ha
  "Yukon_CSIRO-Mk3_RCP85_2" = "18jaaM_qZgTg8htWTbhmt6F6yZLrxiHU1", #ha burned: 13,031,562 mean biomass: 37.9 Mg/ha
  "Yukon_CSIRO-Mk3_RCP85_3" = "1CWZa56_WkgCEHfaIPSERWhpse49aLnU1", #ha burned: 13,312,431 mean biomass: 27.0 Mg/ha
  "Yukon_Access1_RCP85_1" = "1cKMLwgFye3BDbIG2c80JcFeePdX5HVk7", # ha burned: 15,266,269 mean biomass: 26.0 Mg/ha
  "Yukon_Access1_RCP85_2" = "1v05Z7dOmtu9BT3X5766LMclXhrK9kjk2", #ha burned: 16,669,025 mean biomass:: 25.1 Mg/ha
  "Yukon_Access1_RCP85_3" = "1lnwPZtR4E8M67Li_5OChbq1e22Yg254t", #ha burned: 17,186,487  mean Biomass: 25.1 Mg/ha
  "Yukon_Access1_RCP45_1" = "1iMxtPgN2MZ-yWdzWcFBLje-VML836jgV", #ha burned: 14,184,881 mean biomass: 29.2 Mg/ha
  "Yukon_Access1_RCP45_2" = "1Rjrh1AtGuocWpXeIRNX6T-AOVojO8ZPq", #ha burned: 14,224,106 mean biomass: 29.2 Mg/ha
  "Yukon_Access1_RCP45_3" = "1nt9WulrfBd6eL9FZlgUgL8Sda_pPQzDN", #ha burned: 14,187,025 mean biomass: 28.9 Mg/ha
  "Yukon_CanESM2_RCP45_1" =  "1Z1RS2SnxJjSrwRHVkg7jqFe8DrRG1LoE", #ha burned: 15,729,737 mean biomass: 28.9 Mg/ha
  "Yukon_CanESM2_RCP45_2" =  "1KM8n-HtaSxA3qD5qOAhAbKQx7VO4URtg", #ha burned 15,835,337 mean biomass: 28.6 Mg/ha
  "Yukon_CanESM2_RCP45_3" = "1wA501L7LnhP8c26RJbjT4_EcSoYHI3C8", #ha burned: 16,210,987 mean biomass: 28.5 Mg/ha
  "Yukon_CanESM2_RCP85_1" = "1Is1ihwRpBSV8Q0Q9Fux5eohelwreWwEq", #ha burned: 18,679,956 mean biomass: 27.8 Mg/ha
  "Yukon_CanESM2_RCP85_2" =  "11BgsHVb2RBQ1o1-Ok5NrDZnCP3PnnSiG", #ha burned: 18,614,519 mean biomass: 27.0 Mg/ha
  "Yukon_CanESM2_RCP85_3" =  "1fdEp-8ifQm1hakd_SMwiczjyfEks4PQM", #ha burned 18,819,981 mean biomass: 27.3 Mg/ha
  "Yukon_INM-CM4_RCP85_1" = "1j_Eh7_9p0kJil8-O7sdSgKXgtx_uauEE", #ha burned: 9,604,587 mean biomass: 30.3 Mg/ha
  "Yukon_INM-CM4_RCP85_2" =  "1gesjZVvj1565hV2knjjx30MTTmWd6IjT", #ha burned: 9,129,812 mean Biomass: 30.9 Mg/ha
  "Yukon_INM-CM4_RCP85_3" = "1U3Syv6WiPwI7wwLoMGZ7dALwx3BvwlLn", #ha burned: 7,875,656 mean Biomass: 30.1 Mg/ha
  "Yukon_INM-CM4_RCP45_1" = "1Bx6Z4E9vHBT1iF2kSzMMAYeTmGF4HKtL", #ha burned: 8,567,525 mean biomass: 32.1 Mg/ha
  "Yukon_INM-CM4_RCP45_2" = "1IjJKQRYcOLGmWhM_tvgJQ7ChNnc2El5_", #ha burned: 8,642,837 mean biomass: 31.2 Mg/ha
  "Yukon_INM-CM4_RCP45_3" =  "1-VaByKNHZQLwrXqp2NZNy_nV-O6mmrdL", #ha burned: 8,554,425 mean biomass: 31.8 Mg/ha
  #####RIA####
  "RIA_CSIRO-Mk3_RCP85_2" = "1mmwHQZrwngSPpzs7FWn97-XfveRpPH2V" #ha burned 76,167,875 mean biomass: 36.8 Mg/ha
)
