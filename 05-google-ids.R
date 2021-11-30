## Google Drive locations for pre-run simulation objects
## these are used when config option 'prerun' is true




switch(studyAreaName,
       "BC" =  { gdriveURL <- "https://drive.google.com/drive/folders/1zq8HT4MKAV8RZv5ggrsDN-dmJt-KeD3_"},
       "Yukon" = { gdriveURL <-  "https://drive.google.com/drive/folders/1zq8HT4MKAV8RZv5ggrsDN-dmJt-KeD3_"},
       "RIA" = { gdriveURL <- "https://drive.google.com/drive/folders/1y0SzeFQWZxeKjtsTwD4_XqRPl1rMb_eA"},
       "WCB" = { gdriveURL <- "https://drive.google.com/drive/folders/1vwrFVb6KCNgdJxh0C25828y76ni3oF7P"},
       "SB" = { gdriveURL <- "https://drive.google.com/drive/folders/1hhdpf84Oufm5iL_VwqUUmmuI9X0XsbqC"},
       "WB" = { gdriveURL <- "https://drive.google.com/drive/folders/1PZG5_shP5rrvtLPtb7GgJKuoJh6SOyWu"}
)

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
    results = "1n5mfIzvqAEpCewiXntWyAJ149SDyX9lY"
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
    results = "1xoqwH8HSQhDQviImPA6lmPSK1k7ztAQf"
  ),
  "RIA" = list(
    biomassMaps2001 = '1jSdaULcq6H0W9tegYn6YyG1HkJFDqQ85',
    biomassMaps2011 = "1-BDaGZTfZh1I3tVW-hQdNs_rx47exX9X",
    fSsimDataPrep = "1ViwF9OWBG4_7U9mStWLpNOT5BqPJ5Zv3",
    ignitionOut = "1snGvTH27oIe6MlSLplcyKy099bOb7ibC",
    escapeOut = "1imexXvXM8VFjCp_UCKhK7Krdd_kwCi8Q",
    spreadOut = "12hjVsWmFCX8rtorOUyCc5UvCqloq7c-8",
    results = "1y0SzeFQWZxeKjtsTwD4_XqRPl1rMb_eA"
  ),
  "WB" = list(
    results = "1PZG5_shP5rrvtLPtb7GgJKuoJh6SOyWu",
    biomassMaps2001 = "1wpJnUvB9Ca_ek0C4Qm9vsj5KlqQ5n7yt",
    biomassMaps2011 = "1C9Rhjgo27VsBuShtdIfwpM_mBvX-Xx6X",
    fSsimDataPrep = "14VsGPCe5N1srRl8LEUiYC6MUF8O-Oe-K",
    fSsimDataPrep_fuelClass = "1oMjqarQe7Wqov1I_57n_fG_htur2NlYL",
    ignitionOut =  "1LkOqG_L4boorb_MTntASA2Ll5foZWfkz",
    escapeOut = "1GkPrvdmPTkxZ9xC6dO2CIaXUfdcKfXm1",
    spreadOut_fuelClass = "1CbpuBVw5sJbE5VVBtHo0Pqwun_O-Er2H"
  ),
  "WCB" = list(
    results = "1vwrFVb6KCNgdJxh0C25828y76ni3oF7P",
    biomassMaps2001 =  "1u5kFbYoN4CPLCvikMd--q2m78juuvcxI",
    biomassMaps2011 = "10Po5zF__jg_J9sdFxM1j2_lsgt48uBbm",
    fSsimDataPrep = "1tlqO1W3j3pYxGpugEAl2sug3iTNa3gQk",
    fSsimDataPrep_fuelClass = "1_W9G3ZmwJnuJOWW9bkG-BllxabDk7mVm",
    ignitionOut = "1U4GzRWzuWfB71E8olaC5X41mP-pWC5U4",
    escapeOut = "1Tm8ex_MIbngYLMi6GqelvKjX7MQi49WN",
    spreadOut = "1SYfpikqJjYVYyI01cCkceiQULJXNjqIS",
    spreadOut_fuelClass = "1Z8xl_fWu1zzstw03RGkhnpxR9wSMahBc"
  ),
  "SB" = list(
    results = "1hhdpf84Oufm5iL_VwqUUmmuI9X0XsbqC",
    biomassMaps2001 = "1VdH_vCPDOBasCYiDo0kD0vunNIh4SolO",
    biomassMaps2011 = "1jl94nI2u5UuR7ZAzhtNE6KvYd0evKNTK",
    fSsimDataPrep =  "1XHNNnQNRuIVufjT-ZVxGJcK2FPgh1NPk",
    fSsimDataPrep_fuelClass = "1OroO4moL5b0iLKggHP0eSPiU43qcbpsa",
    ignitionOut =  "1157gFEmXkZWkUYfNVgZhfBC8ojhJPW-q",
    escapeOut = "1QkwHyITunBZ1tasvgKLFptnvRukDaVPK",
    spreadOut = "1ah6HwqaBWbzvOkqFIJP_qmYPnlOJffVk",
    spreadOut_fuelClass = "1uRnFm0aeKa4D82C9Lw0ugBCp-VNqH148"
  )
)

gdriveResults <- list(
  "BC_CSIRO-Mk3_RCP85_1" = "1oN7C-WFe-J3AUO9eWZRLk3M-tlRKVjhX", # ha burned: 5,348,888 mean biomass: 61.9 Mg/ha
  "BC_CSIRO-Mk3_RCP85_2" = "1C-bzpeybrPpBik-W_Pb9G8jycuDdYzix", # ha burned: 5,446,850 mean biomass: 62.2 Mg/ha
  "BC_CSIRO-Mk3_RCP45_1" = "1hnn4iDwXla7_qBdEEh3brPP0IIDIumr-", # ha  burned: 2,462,269 mean biomass: 66.0 Mg/ha
  "BC_CSIRO-Mk3_RCP45_2" = "1E3i9eqJ_S8SIBAhwrgYg3KBUoOowazTI", # ha burned: 2,632,500 mean biomass: 66.0 Mg/ha
  "BC_Access1_RCP45_1" = "1HPgLw6BVnUDXBEJ09UBFa4rxPv1fKb-I", # ha burned: 3,176,050 mean biomass:  63.5 Mg/ha
  "BC_Access1_RCP45_2" = "11FStJrq52VR1e_x86hPv6rkNcU809qpy", #ha burned: 2,968,488 mean biomass: 63.6 Mh/ha
  "BC_Access1_RCP85_2" =  "1ix6pgiCQNma7xlefRk1WSmOxeT05qSXU", # ha burned: 3,707,181 mean biomass: 60.98 mg/ha
  "BC_Access1_RCP85_1" = "1qIkuLc45T_2a7lDK4ABp6gRialfIJcVZ", # ha burned: 3,609,369. mean biomass: 61.2 Mg/ha
  "BC_INM-CM4_RCP45_1" = "1_HU_GHl0pC7F0b_UOvavUyXYWwdgdvWl", # ha burned: 2,152,356 mean biomass: 65.1 Mg/ha
  "BC_INM-CM4_RCP45_2" = "1ICCFcsDAVa0dCJihADMYp1MSikeOThcy", # ha burned : 2,093,700 mean biomass: 65.4 Mg/ha
  "BC_INM-CM4_RCP85_1" = "1ENRDFzb0nQGXVsL-H9xyVHuKx5GyP5L3", # ha burned: 2,154,944 mean biomass: 67.0 Mg/ha
  "BC_INM-CM4_RCP85_2" =  "1znYInI9KmecksPG7TF9s3hFm9YjyHXjm", # ha burned: 2,230,112 mean biomass: 67.42 Mg/ha
  "BC_CanESM2_RCP45_1" = "1xE02E74_UQy5P_A62EXfxx26jLgVTX05", # ha burned: 5,048,144 mean biomass: 67.1 Mg/ha
  "BC_CanESM2_RCP45_2" =  "13BF_aGve-QsPsjmKheQTsCDL3md86Ikn", # ha burned: 4,921,981 mean biomass: 67.5 Mg/ha
  "BC_CanESM2_RCP85_1" =  "1fAfNoxaimEey_y0JD6vH36WxElkPUJka", # ha burned: 4,432,338 mean biomass: 67.4 Mg/ha
  ###### Yukon #####
  "Yukon_CSIRO-Mk3_RCP45_1" = "1UBRyZYIsgLShNeb_b0sfpeABkWdz_5WI", # ha burned: 12,753,362 mean biomass: 28 Mg/ha
  "Yukon_CSIRO-Mk3_RCP85_1" = "1acgHrSYLjl_KDWOnC-_gX1FhuhHhXipu", # ha burned: 12,193,931 mean biomass: 29.1 Mg/ha
  "Yukon_Access1_RCP85_1" = "1cKMLwgFye3BDbIG2c80JcFeePdX5HVk7", # ha burned: 15,266,269 mean biomass: 26.0 Mg/ha
  "Yukon_Access1_RCP45_1" = "1iMxtPgN2MZ-yWdzWcFBLje-VML836jgV", #ha burned: 14,184,881 mean biomass: 29.2 Mg/ha
  "Yukon_CanESM2_RCP45_1" =  "1Z1RS2SnxJjSrwRHVkg7jqFe8DrRG1LoE", #ha burned: 15,729,737 mean biomass: 28.9 Mg/ha
  "Yukon_CanESM2_RCP85_1" = "1Is1ihwRpBSV8Q0Q9Fux5eohelwreWwEq", #ha burned: 18,679,956 mean biomass: 27.8 Mg/ha
  "Yukon_INM-CM4_RCP85_1" = "1j_Eh7_9p0kJil8-O7sdSgKXgtx_uauEE", #ha burned: 9,604,587 mean biomass: 30.3 Mg/ha
  "Yukon_INM-CM4_RCP45_1" = "1Bx6Z4E9vHBT1iF2kSzMMAYeTmGF4HKtL", #ha burned: 8,567,525 mean biomass: 32.1 Mg/ha

  #####RIA####
  "RIA_CSIRO-Mk3_RCP45_1" =  "14cIOY1eeZ0YhsORvk35rQCc5YoM_2Xt", #ha burned: 64,603,381 mean biomass: 44.2 Mg/ha
  "RIA_CSIRO-Mk3_RCP85_2" = "1mmwHQZrwngSPpzs7FWn97-XfveRpPH2V", #ha burned 76,167,875 mean biomass: 36.8 Mg/ha
  "RIA_INM-CM4_RCP45_1" =  "1LQOgkJgvy51GrhHJpifUaYly6I-qS82E", #ha burned: 30,735,556 mean biomass: 52.5 Mg/ha
  "RIA_INM-CM4_RCP85_1" = "1XUomyrj6bRERY780Y_iwRXhGzbCZC82C", #ha burned: 33,462,119 mean biomass: 50.9 Mg/ha

  ####SB#### - 90 year sumBurn ~ 2,500,000 ha - starting biomass = 130 Mg/ha
  "SB_Access1_RCP45_1" = "1mnZd6qJBtnGnLDIarlLgVppt6If35Dix", #ha burned: 5,510,813 mean biomass: 80 Mg/ha
  "SB_Access1_RCP45_2" = "1THD_vjsWuG5OUoiOvyHFIaiz9GyOz4On", #ha burned: 5,749,575 mean biomass: 79.2 Mg/ha
  "SB_Access1_RCP45_3" = "19EPRllUCNKH_j_VLsqT9XtOoZGv82Jiw", #ha burned: 5,656,256 mean biomass: 80.4 Mg/ha
  "SB_Access1_RCP85_2"  = "1HzGL_4R5pjQlPu45j3nr1kTdNZyA5OC0", #ha burned: 7,911,038 mean biomass: 68.4 Mg/ha
  "SB_Access1_RCP85_3" = "1JrmhyEAX0_CWNZ7yTXQd_Be4QbywMd3T", #ha burned: 7,462,350 mean biomass: 69.4 Mg/ha

  ##WB 90-year sumBurn = 9,779,156 ha, starting biomas = 56.4 Mg/ha
  "WB_Access1_RCP85_1" =  "1Q3YbcOzkT17FBTrtM-GnuiHYgGqRqZZ7", #ha burned: 20,231,206 mean biomass: 34.6 Mg/ha
  "WB_Access1_RCP45_1" =  "1nTS_GiOrQz-k2XJKkwvqhyihj96qq-qf", #ha burned: 19,356,950 mean biomass:  32.84 Mg/ha #new spp
  "WB_Access1_RCP45_3" = "1ZbRR527Mo90Wza41cfRLX0BgzdmH3U7T", #ha burned: 29,775,294 mean biomass: 38.7
  "WB_CanESM2_RCP45_3" = "1oV_Ti6wnRII8i9ycCRNKvLvk4vHjxpCV", #ha burned: 39 726,856 mean biomass: 38.7 Mg/ha
  "WB_CanESM2_RCP85_3" = "1Q2esE-lOsJhvkjHhV2DYER1xB5CbHojI", #ha burned: 46,025,088 mean biomass: 33.7 Mg/ha
  "WB_INM-CM4_RCP45_3" = "1tFc08IEQNXizgrubLnE56o4RWtdhjNWc", #ha burned: 18,150,569 mean biomass: 42.1


  #WCB: 90-year sumBurn = 6,294,584 biomass 2011 = 66 Mg/ha
  "WCB_Access1_RCP45_1" = "1H8GNThB-LW2bcMpW5zGiVWwrhZm13_5K", #ha burned: 12,975,550 mean biomass: 46.4 Mg/ha
  "WCB_Access1_RCP45_1" = "1GUPWtiWeDmIkX8P4EmDwlMNWYE66mSQQ", #ha burned: 10,417,106 mean biomass: 40.1 Mg/ha
  "WCB_Access1_RCP85_1" = "1lN-yQGR-fwNOJ0L-O4Mc8Y8seVOCTziP", #ha burned: 14,441,012 mean biomass: 43.3 Mg/ha
  "WCB_CanESM2_RCP85_1" = "1_clYqABVTgTfrA-a0qsW_n2KICIlgYbE", #ha burned: 15,744,000, mean biomass: 44.6 Mg/ha
  "WCB_CanESM2_RCP85_2" = "1k4bUNlRQxOwwZ-hHTUFgWEZxZ4QeLv6Q", #ha burned: 15,528,350 mean biomass: 46.5 Mg/ha
  "WCB_CanESM2_RCP85_3" = "1HqrN7uT29s4N_u0VEWbdZ-5IQtfJEJ2z", #ha burned: 17,096,938, mean Biomass: 44.0 Mg/ha
  "WCB_INM-CM4_RCP45_2" = "1Frpg4pIeC4IVAgypA8KBCD0exhDRFj2a", #ha burned: 9,868,825 mean biomass: 48.2 Mg/ha
  "WCB_INM-CM4_RCP85_1" = "1GXDxorSsXZWui54vLkZ7Bp3SHzU4xh02", #ha burned: 13,095,331 mean biomass: 48.6 Mg/ha
  "WCB_INM-CM4_RCP85_2" = "1djjv_DxensBQVMSvovJMk5ayzpFA0byZ",  #ha burned: 10,829,550 mean biomass: 49.4 Mg/ha
  "WCB_INM-CM4_RCP85_3" = "1MDPWDDYCmXf8EVw_f6KS4-Qo819OWu6f" #ha burned: 6,446,844 mean biomass: 49.2 WITH NEW SPREADFIT



  # "WCB_CanESM2_RCP45_1" = "1y_QfDME-Me5Ep8_kaERFqXwxIfYWj85q", #ha burned: 8,894200, mean biomass: 53.0 Mg/ha
  # "WCB_CanESM2_RCP85_1" = "12mKMD8Tlmffe2g9-7Ry_5H2x44ozfpK1", #ha burned: 20,065,369 mean biomass: 40.5 Mg/ha
  # "WCB_INM-CM4_RCP85_1" = "1czcpRiMvMurM7sbZ7DcoSe0Vs5r2BUuy", #ha burned: 1,328,863 mean biomass: 49.2 Mg/ha
  # "WCB_INM-CM4_RCP45_1" = "1rAzOOSuvnslUEXlF2y9X8d4_fP5Le3CN", #ha burned: 1,160,325 biomass: 48.7 Mg/ha
  # "WCB_Access1_RCP45_1" = "1ktr4ocldfGyzyL9LIO7Xn-Q3NyrqNoH5", #ha burned: 7,093656 biomass: 46.7 Mg/ha
  # "WCB_Access1_RCP85_1" = "1KC-Da6EKWmtjNoLFrisYKf7zc2z4Q4-Y", #ha burned: 15,895,300 biomass: 38.53 Mg/ha
  # "WCB_INM-CM4_RCP45_noLandRCS_1" = "1wd97xbxjHNxX5R5QRlfIfFPn9nvrGGj0", #ha burned: 999,837 mean biomass: 69.01 Mg/ha
  # "WCB_CanESM2_RCP45_noLandRCS_1" = "16iy8rAFwuHp0CiC4cc-zYjzHpHfxlC9r", #ha burned: 7,762,988 mean biomass: 61.8 Mg/ha
  # "WCB_Access1_RCP45_noLandRCS_1" = "1MvvjV52ZGKfpYG0AiU3T1YJ3UMFHzSQS", #ha burned: 7,268,094 mean biomass: 61.7 Mg/ha
  # "WCB_INM-CM4_RCP45_withNoAM" = "1SMlHNkaW_2gFRGIco2aMqAvyT9tjLYO2", #ha burned 997,375  mean biomass: 54.4 Mg/ha
  # "WCB_INM-CM4_RCP45_withAM" =  "112RSKqXwrg-xeU4hKKhPOEFnQKFqf7uE", #ha burned 1,023,694 mean biomass: 54 Mg/ha
  # "WCB_CanESM2_RCP85_withNoAM" = "1RCYcBVDBTmR0H3AsQ5uM6W3YS3oUrCpP", #ha burned: 21,787,344 mean biomass: 38.5 Mg/ha
  # "WCB_CanESM2_RCP85_withAM" = "1r1Eze2O-t-Ye4Pg9204u9YTa1hMNjTJ1", #ha burned: 22,204,541 mean biomass: 41 Mg/ha
  # "WCB_CanESM2_RCP45_withNoAM" ="1Cn4YgoCida5w63GsYAcIgJEv4shVpdKL", #ha burned: 9,147,869 mean biomass: 54.9 Mg/ha
  # "WCB_CanESM2_RCP45_withAM" = "1HASC2HcegLhqbsfHmO1LiEnvjs0QhLLp", #ha burned 8,910,113 mean biomass: 51 Mg/ha
  # "WCB_Access1_RCP45_withNoAM" = "1aXvSfm5LelurUsqnkdCPT6BXf6qgCZq7", #ha burned 6,897,613 mean biomass: 51.3 Mg/ha
  # "WCB_Access1_RCP45_withAM" = "1qOPD9Tc58ipEylvvXO3SzJbkxZPriAmP", #ha burned: 7,164519 biomass: 52.5 Mg/ha
  # "WCB_Access1_RCP85_withAM" = "1aWq5u2Us7dET91HrJ14l8VyT5yQihv6v"#ha burned 14,743,500  biomass: 41.2 Mg/ha
  )

