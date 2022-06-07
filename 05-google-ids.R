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

  # ####SB#### - 90 year sumBurn ~ 2,500,000 ha - starting biomass = 130 Mg/ha
  # "SB_INM-CM4_RCP45_noLandRCS_1" = "1cbCOnwI340TMQ8dT7BIfN1pcIZrM7yhb", #ha burned: 1,002,362 mean biomass: 106.0 Mg/ha
  # "SB_INM-CM4_RCP45_noLandRCS_2" = "1nGjzMrLzbhwvxztta3h6Ek3H4FhnDebq", #ha burned: 974,481 mean biomass: 106.5
  # "SB_INM-CM4_RCP45_noLandRCS_3" = "1ZujxCREE1vQG4L1cjBKZFlsjIsfMKsqW", #ha burned: 1,012,400 mean biomass: 105.7 Mg/ha
  # "SB_INM-CM4_RCP45_1" = "14N_xBrTFDVLvc4ZS-JElnPcAyyG5VNmW", #ha burned: 947,718 mean biomass: 96.5 Mg/ha
  # "SB_INM-CM4_RCP45_2" = "1phDs9nfUEPiZ1sl-70qH-GGgS9XB9cJK", #ha burned: 947,881 mean biomass: 96.7 Mg/ha
  # "SB_INM-CM4_RCP45_3" = "1HZR6D2QSDMgFHHXh8hN-92kyv792fBNh", #ha burned: 1,019,194 mean biomass: 96.5 Mg/ha
  # "SB_INM-CM4_RCP85_noLandRCS_1" = "1dRkN4GrwveTcUPSTiKHx9vF_WeYgyeSh", #ha burned: 1,253,025 mean biomass: 104.4 Mg/ha
  # "SB_INM-CM4_RCP85_noLandRCS_2" = "1w7zRa0WSddAK7fFGpQuBFhc5xm6Wl_q0", #ha burned: 1,303,512 mean biomass: 103.6 Mg/ha
  # "SB_INM-CM4_RCP85_noLandRCS_3" = "1InQhlMUsKhDXdjIm5pvDg9MmZ6tXrNDE", #ha burned: 1,253,181 mean biomass: 104.4 Mg/ha
  # "SB_INM-CM4_RCP85_1" = "1ihnx6KeS9-PaTs0k7F8FhDQkenIKlFOg", #ha burned: 1,298,737 mean biomass: 95.7 Mg/ha
  # "SB_INM-CM4_RCP85_2" = "1Y-aiOmIdTQKVrOJuOxPymLYAj_-E3Dwb", #ha burned: 1,368,948 mean biomass: 95.6 Mg/ha
  # "SB_INM-CM4_RCP85_3" = "11ErJY5eya_Ib0pQEZLNrOuK8pFsw7ytQ", #ha burned: 1,381,643 mean biomass: 94.8 Mg/ha
  # "SB_CanESM2_RCP45_noLandRCS_1" = "1oxXtV1km5z-B9oD7pVpE6ZkT7di2Z6Sw",  #ha burned: 4,580,131 mean biomass: 92.8 Mg/ha
  # "SB_CanESM2_RCP45_noLandRCS_2" = "1Ig2HXRzhIwC1jcgn-OqS3sdv_CoJ_JAw", #ha burned: 4,445,556 mean biomass: 92.8 Mg/ha
  # "SB_CanESM2_RCP45_noLandRCS_3" = "1pvK0NltQNqRt6E5uHbrpAaevOa_lSYWi", #ha burned: 4,510,037 mean biomass: 92.0 Mg/ha
  # "SB_CanESM2_RCP45_1" = "1P607lmq4dS0p5OtpRdLLbBw_LyzrbhUP", #ha burned: 4,421,950 mean biomass: 95.9 Mg/ha
  # "SB_CanESM2_RCP45_2" = "1QT5CQeP-PaCBLj-VD46rSotjPgc891p5", #ha burned: 4,395,894 mean biomass: 95.7 Mg/ha
  # "SB_CanESM2_RCP45_3" = "1v6qCPoYpCWWHSKSrmDbUvoNUB77Qz5s3", #ha burned: 4,402,841 mean biomass: 93.7 Mg/ha
  # "SB_CanESM2_RCP85_noLandRCS_1" = "1l22il-apprl7vlgqtUNuqgbtVw3iNMjN", #ha burned:  6,910,900 mean biomass: 76.6 Mg/ha
  # "SB_CanESM2_RCP85_noLandRCS_2" = "1-akO9BMs49ucwLnVymJEc5YGvydBuWEw", #ha burned: 6,810,356 mean biomass: 77.1 Mg/ha
  # "SB_CanESM2_RCP85_noLandRCS_3" = "1J5mb82tEM-nA2Qfmjjvku1KXjRbMEjgh", #ha burned: 6,563,131 mean biomass: 79.0 Mg/ha
  # "SB_CanESM2_RCP85_1" = "1zImWb_8Bmf1rYKe9wL7hveAmEem0cYr5", #ha burned: 7,001,012 mean biomass: 78.5 Mg/ha
  # "SB_CanESM2_RCP85_2" = "1mMkNP9IA9OCIqBnVzDlvxPUFaFkMtnth", #ha burned: 7,059,218 mean biomass: 80.6 Mg/ha
  # "SB_CanESM2_RCP85_3" = "1nDWQ4hiDotmWdU_AtZwEQiT5BhBnvomQ", #ha burned: 6,741,387 mean biomass: 80.0 Mg/ha
  # "SB_Access1_RCP45_noLandRCS_1" = "1K0e-NQ92eakk7DzQJ7yBXYrl1B2nD-M9", #ha burned: 4,179,162 mean biomass: 91.4 Mg/ha
  # "SB_Access1_RCP45_noLandRCS_2" = "19GBXp-sxwxx2bPffPz_ODpveHL_Ouypl", #ha burned: 4,633,506 mean biomass: 91.8 Mg/ha
  # "SB_Access1_RCP45_noLandRCS_3" = "16qsAZiQ_UXCGX4EzIhL-AJX30XiLcMqJ", #ha burned: 4,557.982 mean biomass: 91.2 Mg/ha
  # "SB_Access1_RCP45_1" = "12qO0ryLqEt63ioJNt1pywpmFC5uCn6pC", #ha burned: 4,517,462 mean biomass: 87.2 Mg/ha
  # "SB_Access1_RCP45_2" = "17CfwaILCZJzRdBIbCfDCoRU2MM2PUNvS", #ha burned: 4,068,206 mean biomass: 88.6 Mg/ha
  # "SB_Access1_RCP45_3" = "16EQj552DcFZf7bXaN3B2wnS4P7FHW415", #ha burned: 4,303,012 mean biomass: 87.5 Mg/ha
  # "SB_Access1_RCP85_noLandRCS_1" = "1X1rwf4Bw5r_Z8L2F8jSEKiqHXw4DZ7kp", #ha burned: 6,003,918 mean biomass: 81.3 Mg/ha
  # "SB_Access1_RCP85_noLandRCS_2" =  "1itNM6VlhpagNWfVOdSr-GmKbIQ41gSQD", #ha burned: 5,856,506 mean biomass: 83.1 Mg/ha
  # "SB_Access1_RCP85_noLandRCS_3"  = "1bZvs9z3T3ra-Qh_5vmcA0CqapG2aNBVi", #ha burned: 5,328,668 mean biomass: 83.2 Mg/ha
  # "SB_Access1_RCP85_1" = "1pK-YTHKT5o8i7P3i4WClQ3rf458g0byk", #ha burned: 6,397,268 mean biomass: 78.2 Mg/ha
  # "SB_Access1_RCP85_2" = "1rbZIpkFY01ySNAoEOipjGH1ZmOVGGX7D", #ha burned: 5,879,175 mean biomass: 80.0 Mg/ha
  # "SB_Access1_RCP85_3" = "1yD-8Ct0bWpOAI_s_JfCwBoRHIbEjc6ng", #ha burned: 6,270,512 mean biomass: 78.5 Mg/ha
  #
  # ##WB 90-year sumBurn = 9,779,156 ha, starting biomas = 56.4 Mg/ha
  # "WB_historical_LandR_1" = "id: 1B69F5x3Nh9tvvqziNEyS1cKeTKL_ZgHT", #ha burned: 21,391,618 mean biomass: 42.4 Mg/ha
  # "WB_historical_LandR_2" = "1cm7QdeGb7sNV_4ianiR4i2DvHLw1j8Vf", #ha burned: 18,907,087 mean biomass: 43.4 Mg/ha
  # "WB_historical_LandR_3" = "1eeVz6VprloyZ20Y2FLuxvBECWnG1oCqx", #ha burned: 21,759,925 mean biomass: 41.3 Mg/ha
  # "WB_INM-CM4_RCP45_1" = "1b8rxLc-5Ude8XxWTZMtR9dSsxXHKyith", #ha burned: 15,169,043 mean biomass: 41.1
  # "WB_INM-CM4_RCP45_2" = "18-GhsZpDcvZHevQwco1RhSJgPscEw5fV", #ha burned: 15,443,531 mean biomass: 42.0
  # "WB_INM-CM4_RCP45_3" = "1sjw2CIFtxzc88fZFAL1yZc1cA_z2xswN", #ha burned: 15,129,350 mean biomass: 42.5
  # "WB_INM-CM4_RCP45_noLandRCS_1" = "1MwcjMDYEtY_kd9dBwDqurrTeDljjpXw1", #ha burned: 16,878,725 mean biomass: 44.4 Mg/ha
  # "WB_INM-CM4_RCP45_noLandRCS_2" = "1W8Iy7fYGTGLkkVMqk_eGo5lse6Sk6M5I", #ha burned: 15,208,637 mean biomass: 44.6 Mg/ha
  # "WB_INM-CM4_RCP45_noLandRCS_3" = "1-VDxTRs66qloJ_QSD82iXUkEZbpo4bgc", #ha burned: 16,065,868 mean biomass: 44.1 Mg/ha
  # "WB_INM-CM4_RCP85_1" = "1gL6LFX9AjQ3Lbys-rcNk5YhR3WDNz5DC", #ha burned: 16,349,818 mean biomass 42.6 Mg/ha
  #
  #
  # "WB_INM-CM4_RCP85_noLandRCS_1" = "1REdCKR7dLumqEo6dTZFSdYXwP1E8XrwL", #ha burned: 15,430,375 mean biomass: 45.2 Mg/ha
  # "WB_INM-CM4_RCP85_noLandRCS_2" = "1fozsE7sFZENLxqfg3Kd3czekSiuljjXl", #ha burned: 16,042,968 mean biomass: 44.1 Mg/ha
  # "WB_INM-CM4_RCP85_noLandRCS_3" =  "1a7fRqQTmNjlCD1IFwwgXpxc4X6PCiyHN", #ha burned: 14,957,331 mean biomass: 44.3 Mg/ha
  # "WB_CanESM2_RCP45_1" = "1ThI9GApg6r_DKKNPikv_EMeLyiaizPHe", #ha burned: 30,801,300 mean biomass: 38.6 Mg/ha
  # "WB_CanESM2_RCP45_2" = "1ZWxS33qwS6oFDdX6fNUS6YKo4iX8FnM4", #ha burned: 29,458,437 mean biomass: 38.7 Mg/ha
  # "WB_CanESM2_RCP45_3 " = "12EfE7c0bz4SqzZTgVmhfkSjxm8OFiaDn", #ha burned: 30,557,418 mean biomass: 39.1 Mg/ha
  # "WB_CanESM2_RCP45_noLandRCS_1" = "18wPzIAEz_KY8DpDimZl1yUOXvEGyqav2", #ha burned: 29,908,812 mean biomass: 37.6 mg/ha
  # "WB_CanESM2_RCP45_noLandRCS_2" = "1Gbr3m8Ph3aj2YFMg9d-QftIRWyI2c3HI", #ha burned: 30,275,756 mean biomass: 37.9 Mg/ha
  # "WB_CanESM2_RCP45_noLandRCS_3" = "1gzvhkDFgNf3VAW8_LW7J3X9lz7F3rJMR", #burn summary: 29,455,462 mean biomass: 38.4 Mg/ha
  # "WB_CanESM2_RCP85_1" = "18DDBaPOTZk08GR2bfe6Z5X6DkcX_DAXE", #ha burned: 36,762,862 mean biomass: 34.5 Mg/ha
  #
  # "WB_CanESM2_RCP85_noLandRCS_1" = "15879mh3fXh5ogtZbzXWdsEQk8tEf3dse", #ha burned: 35,175,837 mean biomass: 32.9 Mg/ha
  # "WB_CanESM2_RCP85_noLandRCS_2" = "16mOT398wC358wm2POsYpBLKRlYIuG9HP", #ha burned: 38,060,712 mean biomass: 32.0 Mg/ha
  #
  # "WB_Access1_RCP45_1" = "1I0Q1VlY9fJcv-h9rNEMfr65cQg7P4ULt", #ha burn: 24,504,731 mean biomass: 38.4 Mg/ha
  # "WB_Access1_RCP45_2" = "1_3m7H4mk5CYiKJ_kfjq7Gq3qSTljTsZ7", #ha burned: 24,118,781 mean biomass: 38.9 Mg/ha
  # "WB_Access1_RCP45_3" = "1GhEgKUh4v9TrruUJD5EWZX85Cu4Iu2rk", #ha burned: 23,979,625 mean biomass: 38.6 Mg/ha
  # "WB_Access1_RCP45_noLandRCS_1" = "1aXFgVVVcsjo9vXyyH5klJ9hCRrFa1EPp", #ha burned: 23,796,181 mean biomass: 40.1 Mg/ha
  # "WB_Access1_RCP45_noLandRCS_2" = "1S13HiAwIA6zKZ26uQbbvMNYsoLesDRZc", #ha burned: 26,038,225 mean biomass: 40.3 Mg/ha
  # "WB_Access1_RCP45_noLandRCS_3" = "1CK9ckIvJXTscwesRp5O32jpW7GcAKd6l", #ha burned: 23,467,675 mean biomass: 40.3 mg/ha
  #
  # "WB_Access1_RCP85_3" = "1EN1AjUGdHLeI3Q4aFj7tv5pTQNEeyOge", #ha burned: 26,598,181 mean biomass: 35.5 Mg/ha
  #
  #
  # "WB_Access1_RCP85_noLandRCS_3" = "1FLMOWEdJ3AIi9aW-YI0AZ1ncDVCwDZuV", #ha burned: 26,956,650 mean biomass: 35.9
  #
  #
  # #WCB: 90-year sumBurn = 6,294,584 biomass 2011 = 66 Mg/ha
  # "WCB_historical_LandR_1" = "1HeNIG0xE0AgDmr9AaChjrZATd8IXmJd", #ha burned: 7,571,621 mean biomass: 60.1 Mg/ha
  # "WCB_historical_LandR_2" = "1JAnvKF9mtr11NTkctjmOh0MCPgRuoxLO", #ha burned: 7,007,097 mean biomass: 60.0 Mg/ha
  # "WCB_historical_LandR_3" = "1E1iDnn1W1qEmZjm-NecKwCW3rpPGxEjk", #ha burned: 8,126,006 mean biomass: 59.0 Mg/ha
  # "WCB_Access1_RCP45_1" = "1OH6ELQxmq6PyoMJYu32znfO3pSxgouHC", #ha burned: 10,685,531, mean biomass: 40.3 Mg/ha
  # "WCB_Access1_RCP45_2" = "1WQpks0BgarwvN7VtqV1nQYgFmjK1TXHN", #ha burned: 10,375,575, mean biomass: 42.8 Mg/ha
  # "WCB_Access1_RCP45_3" = "1d5q03LXIWdhjvuaMZZAJsp6TBzwlg7kl", #ha burned: 9,627,081 mean biomass: 40.4 Mg/ha
  # "WCB_Access1_RCP45_noLandRCS_1" = "16eAXTJgxKXmG7gpdFmic3f5awiCAqNlT", #ha burned: 9,912,600 mean biomass: 56.1 Mg/ha
  # "WCB_Access1_RCP45_noLandRCS_2" = "1KRVuauzCcHlWBxkR5PFSSwRKpjAdxpV6", #ha burned: 10,558,356 mean biomass: 53.8 Mg/ha
  # "WCB_Access1_RCP45_noLandRCS_3" = "1hu1Z5rh_f2JpFUM83PRO0f9FFxlq-zmi", #ha burned: 10,246,050 mean biomass: 55.6 Mg/ha
  # "WCB_Access1_RCP85_1" = "1soWkclJc3v3jmUZCvyU6STA6HJOLOvuN", #ha burned: 12,582,225 mean biomass: 36.1 Mg/ha
  # "WCB_Access1_RCP85_2" = "14SGVo7xAgdKY8O15_bhEvagxReZ-1sbU", #ha burned: 12,733,256 mean biomass: 38.5 Mg/ha
  # "WCB_Access1_RCP85_3" = "1b5BbU-OkcvyEfGvE9QuUhXR6F6Qw9yaZ", #ha burned: 12,949,818 mean biomass: 34.4 Mg/ha
  # "WCB_Access1_RCP85_noLandRCS_1" = "14ONQFGSlV2KRbv-qK2syRT9q9wN3IqW1", #ha burned: 13,354,512 mean biomass: 49.4 Mg/ha #outlier verified
  # "WCB_Access1_RCP85_noLandRCS_2" = "1Nq7R-TNGNRzI0dmLDBl-OJS5NuweuZqK", #ha burned: 10,352,318 mean biomass: 55.1 Mg/ha
  # "WCB_Access1_RCP85_noLandRCS_3" = "1Hv72qosKUTnfZxMP2M3o_kTC4SgC5P6_", #ha burned: 10,089,656 mean biomass: 55.5 Mg/ha
  # "WCB_CanESM2_RCP45_1" = "1n72z60QpGyOKJcFKmNMItRtbpuvFwlFe", #ha burned: 11,196,275 mean biomass: 41.8 Mg/ha
  # "WCB_CanESM2_RCP45_2" = "1oWDAJAa635X1BjGiIsqz0ULCIw3gv1Tu", #ha burned: 11,677,200 mean biomass: 44.6 Mg/ha
  # "WCB_CanESM2_RCP45_3" = "1iHpLBk-8mQ11QgEa3rGwM-M3TQjlkAWI", #ha burned: 11,399,212 mean biomass: 41.7 Mg/ha
  # "WCB_CanESM2_RCP45_noLandRCS_1" = "1-SoV8SrPSmT8g4qAL2pOVVHm3wAfuHJB", #ha burned: 11,071,412 mean biomass: 54.0 Mg/ha
  # "WCB_CanESM2_RCP45_noLandRCS_2" = "1NQFMecdV1YVzPQcbYNJ_W3FZU9JHYc-4", #ha burned: 10,639,025 mean biomass: 54.7 Mg/ha
  # "WCB_CanESM2_RCP45_noLandRCS_3" = "1w5-G5QtvPSmsEfwyGjgR9KyYv7TOF92K", #ha burned: 11,049,156 mean biomass: 53.9 Mg/ha
  # "WCB_CanESM2_RCP85_1" = "10c982ZNJRs9YEH5gOqePhy0yDjhJBzU0", #ha burned 15,493,487 mean biomass: 36.0 Mg/ha
  # "WCB_CanESM2_RCP85_2" = "1RBxhFsZxAfHt43Mz-YW3GJyPVsmNSBrA", #ha burned: 15,029,543 mean biomass: 36.1 Mg/ha
  # "WCB_CanESM2_RCP85_3" = "1MPz2JrldpLu7oFmVJreA1HGyGds0h-NL", #ha burned: 15,822,462 mean biomass: 38.9 mg/ha
  # "WCB_CanESM2_RCP85_noLandRCS_1" = "1LjUrNJRKKvrAY82CJiRKz0B_2TiT4fvJ", #ha burned: 14,419,737 mean biomass: 47.1 Mg/ha
  # "WCB_CanESM2_RCP85_noLandRCS_2" = "1SEmgVX1SdN5flOBN5F6dIsMaa1tsA4rk", #ha burned: 15,376,325 mean biomass: 45.7 Mg/ha
  # "WCB_CanESM2_RCP85_noLandRCS_3" = "1jveOsFEx1kiqP_98YV_YBznSU_PkxdcB", #ha burned: 14,810,318 mean biomass: 46.9 Mg/ha
  # "WCB_INM-CM4_RCP45_1" = "1ovMDtbfK07xLgeiUiZDwagydGeMcXXuZ", #ha burned: 5,354,043 mean biomass: 48.9 Mg/ha
  # "WCB_INM-CM4_RCP45_2" = "125lvFHrqxJJHd8Unk1OMYq3JYWF8YFAq", #ha burned: 5,180,543 mean biomass: 48.8 Mg/ha
  # "WCB_INM-CM4_RCP45_3" = "1wnvdur51qw0cPaPeG5XSrih6UGcZikE1", #ha burned: 5,303,118 mean biomass: 50.5 Mg/ha
  # "WCB_INM-CM4_RCP45_noLandRCS_1" = "1Na_Z9qQTVM9V12CwM3ZEBzkLlB958ffc", #ha burned: 4,791,112 mean biomass: 64.1 Mg/ha
  # "WCB_INM-CM4_RCP45_noLandRCS_2" = "1SSEMP7Y3zFe-5JQGA256fGOOjpzlZQ43", #ha burned: 4,953,062 mean biomass: 64.8 Mg/ha
  # "WCB_INM-CM4_RCP45_noLandRCS_3" = "1EdhogyYW4J52qSFlIFgHh5_IcWj324wz", #ha burned: 4,873,637 mean biomass: 63.7 Mg/ha
  # "WCB_INM-CM4_RCP85_1" = "1_W7XgppzAwZ-TU5wGgAhZOCjjrbnqJvP", #ha burned: 5,509,119 mean biomass: 46.5 Mg/ha
  # "WCB_INM-CM4_RCP85_2" = "12DuUY3eys0xenME08vkQADKxwx_cNVBP", #ha burned: 5,377,487 mean biomass: 48.7 Mg/ha
  # "WCB_INM-CM4_RCP85_3" = "171PdcPsz5uWYHyXA4xe9aVgYWPy2D_Jd", #ha burned: 5,332,137 mean biomass: 47.7 Mg/ha
  # "WCB_INM-CM4_RCP85_noLandRCS_1" = "1kOhwTsr2S7x4aLMTeEPbH3mENP8QAvUN", #ha burned: 5,668,006 mean biomass: 61.5 Mg/ha
  # "WCB_INM-CM4_RCP85_noLandRCS_2" = "11b78CEsOCJjOk2udvMkflP0jiuclE5tm", #ha burned: 5,663,525 mean biomass: 61.9 Mg/ha
  # "WCB_INM-CM4_RCP85_noLandRCS_3" = "1mulbLBE26rDC_fVYz7k-D6ZZxjP2xrUf", #ha burned: 5,893,068 mean biomass: 61.5 Mg/ha

  ###CMIP6###
  # ####SB#### - 90 year sumBurn ~ 2,500,000 ha - starting biomass = 130 Mg/ha *** some bad youngAge pixels
  #historical - complete
  "SB_historical_LandR_1" = "1akY_YOxeeN9jq3T22eVlyy6XikJnsIzZ", #ha burned: 1,360,237 mean biomass: 97.8 Mg/ha
  "SB_historical_LandR_2" = "1-c8nnDyZWyLoVKFg_zj8UV57pmGIteEB", #ha burned: 1,988,088 mean biomass: 94.8 Mg/ha
  "SB_historical_LandR_3" = "1HovXmX4wM1PdTVREFNWk5-cHTTkgBWK-", #ha burned: 1,506,863 mean biomass: 97.0 Mg/ha
  #CanESM5 245 - complete
  "SB_CanESM5_245_noLandRCS_1" = "1fsEJ1KF6N09g066f3V44BY4PUVverx4f",#ha burned: 652,919 99.9 Mg/ha
  "SB_CanESM5_245_1" = "1kgq4Ykm--jBJem1Z5yy0MEo4wVUq4Vo2",# ha burned: 719,519 mean biomass: 96.3 Mg/ha
  "SB_CanESM5_245_noLandRCS_2" = "1nzuMktmBPP_Oo_ywYTh1e7NCqkbxc7CE",#ha burned: 703,181 mean biomass: 100.4 Mg/ha
  "SB_CanESM5_245_2" = "1wiovLsiBa83JgBq0u-hUWhxxnNiKKcBJ",#ha burned: 683,050 mean biomass: 96.6 Mg/ha
  "SB_CanESM5_245_noLandRCS_3" = "1tQXqaG892DQ0PTglSu3Iq1gmPrt7N-Ld", #ha burned: 908,462 mean biomass: 98.9 Mg/ha
  "SB_CanESM5_245_3" = "1e73g2yzVjHp9giynX9gJ7ZkmF-t_1RlH", #ha burned: 74,8681 mean biomass: 96.8 Mg/ha
  #CanESM5 370 - complete
  "SB_CanESM5_370_noLandRCS_1" = "1SUfScOgLk0V6Fk8hEQKG5dIL9HcZzSJ0",#ha burned: 1,356,019 mean biomass: 94.6 Mg/ha
  "SB_CanESM5_370_1" = "17zJdVv6nOFc2hPBD10mZWd_vEKcHfeHS", #ha burned: 1,483,688 mean biomass: 94.8 Mg/ha
  "SB_CanESM5_370_noLandRCS_2" = "1dGnedOeNOrk0jcEh56VmiXIXSkL3wRtX",#ha burned: 1,561,075 mean biomass: 93.1 Mg/ha
  "SB_CanESM5_370_2" = "1h2y-q6XWt2YeIX1h3IAIPXDL7GLHnR_I", #ha burned: 1,391,944 mean biomass: 93.3 Mg/ha
  "SB_CanESM5_370_noLandRCS_3" = "1MT4ETl23lZDkKB8mKnO3B0VIEH6rBxxh", #ha burned: 1,238,550 mean biomass: 95.4 Mg/ha
  "SB_CanESM5_370_3" = "1wF23ipCEfuSJhB483GL7EeK41EVi0UbV",#ha burned: 1,361,238 mean biomass: 94.6 Mg/ha
  #CNRM 245 - complete
  "SB_CNRM-ESM2-1_245_noLandRCS_1"= "1CizM2tdJQdM8K3-ktIXZEFThBZk9Wyng", #ha burned: 1,385,119, mean biomass: 96.2 Mg/ha
  "SB_CNRM-ESM2-1_245_1" = "1PVTBmd_LptAzeqONimlZlZTHkq8PJ5VS", #ha burned: 1,611,050 mean biomass: 91.9 Mg/ha
  "SB_CNRM-ESM2-1_245_noLandRCS_2"= "1qlvy0qScsUqxzr1Y0uBZam21c53AiUXG", #ha burned: 1,425,800, mean biomass: 96.2 Mg/ha
  "SB_CNRM-ESM2-1_245_2" = "1vDk3tP1Dvtkgd_wPUnvGq_6Quluiq5cI", #ha burned: 1,483,856 mean biomass: 91.1 Mg/ha
  "SB_CNRM-ESM2-1_245_noLandRCS_3" = "1QRVdcOKwvubJKh5Xc1mupzAurXvRhXjo", #ha burned: 1,365,931 mean biomass: 96.3 Mg/ha
  "SB_CNRM-ESM2-1_245_3" = "1sNrAceF4XRJNyb2ew_3HfXH_X6h5yv7e",#ha bunred:  1,558,781 mean biomass: 91.8 Mg/ha
  #CNRM 370 - complete
  "SB_CNRM-ESM2-1_370_noLandRCS_1" = "1uds92wFrllc6oMjtDShg0x4D-JfLYhz4", #ha burned: 1,609,900 mean biomass: 94.3 Mg/ha
  "SB_CNRM-ESM2-1_370_1" = "12LICC2q9tgVm_rNfQAA9uvFWR5S0P4P0", #ha burned: 1,635,412 mean biomass: 89.9 Mg/ha
  "SB_CNRM-ESM2-1_370_noLandRCS_2" = "1He1hXVOZK9E3g6h9DXWlg8cs60HoNLTp", #ha burned: 1,580,081 mean biomass: 94.1 Mg/ha
  "SB_CNRM-ESM2-1_370_2" = "1sNb6eY97LzW7uCpw_JGygo1HC8_21Hgn",#ha burned: 1,521,606 mean biomass: 91.7 Mg/ha
  "SB_CNRM-ESM2-1_370_noLandRCS_3" = "1FAT-tsrP-zOjv5OcsDn2lIYam5pS4FLj", #ha burned: 1,967,200 mean biomass: 90.8 Mg/ha,
  "SB_CNRM-ESM2-1_370_3" = "1DfnvKnvMBcmJHYEzlb7kqpIBwHk23NvY", #ha burned: 1,591,550 mean biomass: 92.1 Mg/ha
  #Access5 245 - complete
  "SB_ACCESS-ESMI1-5_245_noLandRCS_1" = "1lj2WpNee6Abr1cMGWs-p6H5Ug4iFnJrp", #ha burned: 2,272,438 mean biomass: 88.4 Mg/ha
  "SB_ACCESS-ESMI1-5_245_1" = "17Xv1FmXAv0-vyS3cVfgmSUJhpNsu-WKf", #ha burned: 2,439,488 mean biomass: 84.8 Mg/ha
  "SB_ACCESS-ESMI1-5_245_noLandRCS_2" = "18bmOpO87pYsEiaBTN94CsNWo95y70AHv", #ha burned: 2,536,606 mean biomass: 87.2 Mg/ha
  "SB_ACCESS-ESMI1-5_245_2" = "1qzhss0w2WhAnNO77qx827r_EjsMWPIV0",#ha burned: 2,017,600 mean biomass: 86.1 Mg/ha
  "SB_ACCESS-ESMI1-5_245_noLandRCS_3" = "1RfhGdaQdFPQ7Vg1uKlzGg7jF1maQ2XV2", #ha burned 2,392,244 mean biomass: 89.0 Mg/ha
  "SB_ACCESS-ESMI1-5_245_3"= "1_gl4fjss8_dc6znFiRx4VuMZbEVf-1Lt", #ha burned: 1,840,238 mean biomass: 84.3 Mg/ha
  #Access 370 - complete
  "SB_ACCESS-ESMI1-5_370_noLandRCS_1" = "1l1S6GfNkD088P0W7n4IhSf52QUNaRVxl", #ha burned: 3,701,738 mean biomass: 80.3 Mg/ha
  "SB_ACCESS-ESMI1-5_370_1" = "12BByOCynHbIMLn4uEEwS23P3wH5p6rO3", #ha burned: 3,434,619 mean biomass: 80.6 Mg/ha
  "SB_ACCESS-ESMI1-5_370_noLandRCS_2" = "1L0KY9f8PChm6Z0VJUb9CQ40HtiQFcoLJ", #ha burned: 3,971,325 mean biomass: 79.3 Mg/ha
  "SB_ACCESS-ESMI1-5_370_2" = "1Ook0-ETU4wLW02wSqrikftRuC-sF1aIW",#ha burned: 3,614,688 mean biomass: 80.0 Mg/ha
  "SB_ACCESS-ESMI1-5_370_noLandRCS_3" = "1uUX3vK_c0aT7EjrwoOE9M2InFu8SpGPh", #ha burned: 3,668,938 mean biomass: 80.2 Mg/ha
  "SB_ACCESS-ESMI1-5_370_3" = "1A3mqFKYtNHZ1iIxp8vkUejjJYU4IWEiH", #ha burned: 3,486,669 mean biomass: 79.2 Mg/ha
  #####WCB####: 90-year sumBurn = 6,294,584 biomass 2011 = 66 Mg/ha
  #historical
  "WCB_historical_LandR_1" = "1xOOkZAxgBxRLdNwgCLAY4SkQyX_aBhOv", #ha burned: 7,224,788 mean biomass: 50.5 Mg/ha
  "WCB_historical_LandR_2" = "1CsUVOnzrMNo7BjGbNGZxSxyTYBaBVfFH", #ha burned: 7,657,100 mean biomass: 51.0 Mg/ha
  "WCB_historical_LandR_3" = "1patskulv6KrimAxQvdCzuQqZGDzVzUz4", #ha burned: 6,556,094 mean biomass: 52.7 Mg/ha
  #CanESM5 245 - complete
  "WCB_CanESM5_245_noLandRCS_1" = "1DBOMiwu2hKqDDe9GZvlztJXTBWVqBXII", #ha burned: 3,892,025 mean biomass: 64.3 Mg/ha
  "WCB_CanESM5_245_1" = "1N9KMZy64INssoM5tuRBdUis0JSwRNWEK",#ha burned: 3,689,844 mean biomass: 52.0 Mg/ha
  "WCB_CanESM5_245_noLandRCS_2" = "10XYUtMGEGP5QJKYpoSj_H3zEQEdXlyfw", #ha burned: 3,946,725 mean biomass: 64.3 Mg/ha
  "WCB_CanESM5_245_2" = "1Gs89kaC-n7GnoyBhPIq1NOmypgX_ykp_", #ha burned: 3,775,694 mean biomass: 51.4 Mg/ha
  "WCB_CanESM5_245_noLandRCS_3" = "1jZx4UfC_NI7UqKeMuKn_v25syC7NYO_s", #ha burned: 3,724,912 mean biomass: 64.4 Mg/ha
  "WCB_CanESM5_245_3" = "1SZa8WhjsnzjiHrobZWgTTCglXnDvX52s", #ha burned: 3,428,681 mean biomass: 51.5 Mg/ha
  #CanESM5 370 - complete
  "WCB_CanESM5_370_noLandRCS_1" = "1hzuXrl7mSRcKgAk1VsXQgr7dgEreJimi", #ha burned: 4,876,856 mean biomass: 61.1 Mg/ha
  "WCB_CanESM5_370_1" ="1ZCS3mlpYm9WGDXEIgiVgehBZHOmmWsyf", #ha burned: 5,279,938 mean biomass: 48.7 Mg/ha
  "WCB_CanESM5_370_noLandRCS_2" = "1qT7AF8IOXzZMzXDLmzDMx3Ta8ZbW98BI", #ha burned: 4,973,775 mean biomass: 60.1 Mg/ha
  "WCB_CanESM5_370_2" = "1pXW1otBq0R5FSRhLwhEBmBX31jY8dz6T", #ha burned: 5,452,612, mean biomass: 49.2 Mg/ha
  "WCB_CanESM5_370_noLandRCS_3" = "1FFm1IM2y3BBhik3hbQZzyzyI8d12667q", #ha burned: 4,964,350 mean biomass: 61.0 Mg/ha
  "WCB_CanESM5_370_3" = "1AJCaoxha3bxz8BgGQ3RjPWv-EGLFD0AQ",#ha burned: 4,607,619 mean biomass: 49.6 Mg/ha
  #CNRM 245  - complete
  "WCB_CNRM-ESM2-1_245_noLandRCS_1" = "1nY_VKEn_mpdPw_jb-tisxGJml2dnSO8f", #ha burned: 5,839,056 mean biomass: 60.3 Mg/ha
  "WCB_CNRM-ESM2-1_245_1" = "1_v3oyoiaXLz9hnhnaua3Flp2r0zhZlA1", #ha burned: 5,544,419 mean biomass: 50.3 Mg/ha
  "WCB_CNRM-ESM2-1_245_noLandRCS_2" = "1ynWRnhD27x-FSDs8BFRwktlAau93tz1Q", #ha burned: 5,601,556 mean biomass: 60.1 Mg/ha
  "WCB_CNRM-ESM2-1_245_2" = "1ciofQRghRxXXbEx9RT6Nj4bG_O7ZFm5T", #ha burned: 5,549,000 mean biomass: 50.0 Mg/ha
  "WCB_CNRM-ESM2-1_245_noLandRCS_3"="1Oj_Sv5P93zZMW1IwNQmPFET5H1J1s9UU", #ha burned: 6,138,969 mean biomass: 59.1 Mg/ha
  "WCB_CNRM-ESM2-1_245_3" = "1rEqdEDHQIoRo04kzYDqh_Vg-mYj-ktz6", #ha burned: 4,986,706 mean biomass: 49.8 Mg/ha
  #CNRM 370 - complete
  "WCB_CNRM-ESM2-1_370_noLandRCS_1" = "1_8hI8Q2W8zrVaul-O_dk5OcT_A9Krqxc", #ha burned: 6,163,875 mean biomass: 58.0 Mg/ha
  "WCB_CNRM-ESM2-1_370_1" = "1ewOu5VC3CJRRt367QaEf52y9wIrlZczW", #ha burned: 6,044,994 mean biomass: 47.4 Mg/ha
  "WCB_CNRM-ESM2-1_370_noLandRCS_2" = "1lOg6xdWVxcgVdwf_Kcg1Z4TQZ3E9cuhZ", #ha burned: 6,231,988 mean biomass: 58.4 Mg/ha
  "WCB_CNRM-ESM2-1_370_2" = "1izqeOXVfY-RpVgc2Zj-2b24VKEANojzJ", #ha burned: 6,228,500 mean biomass: 49.3 Mg/ha
  "WCB_CNRM-ESM2-1_370_noLandRCS_3" = "1jh3ymEWXm3GCxZLppFxsct0y4AJuFp1-", #ha burned: 6,271,988 mean biomass: 58.4 Mg/ha
  "WCB_CNRM-ESM2-1_370_3" = "1JCB4FX2VWF_HGVHNKDtWNLJqAskZzb4R", #ha burned: 6,708,981 mean biomass: 49.2 Mg/ha
  #Access5 245  - complete
  "WCB_ACCESS-ESMI1-5_245_noLandRCS_1" = "1HxSYWgBh0objNE7Hi_uPHNg8yj51mp31", #ha burned: 5,153,956 mean biomass: 60.5 Mg/ha
  "WCB_ACCESS-ESMI1-5_245_1" = "1tiW1H3xESfZyUNmgHDoVs94uVAblJV4i", #ha burned: 4,609,794, mean biomass: 47.4 Mg/ha
  "WCB_ACCESS-ESMI1-5_245_noLandRCS_2" = "1rbmLkck4qHornVxrQpKJxdBg4r7iispB", #ha burned: 5,191,519 mean biomass: 60.2 Mg/ha
  "WCB_ACCESS-ESMI1-5_245_2" ="1W8SNoCfXQpaFgQ5S0hHxsawf_iKFnc3G", #ha burned: 4,964,425, mean biomass: 46.9 Mg/ha
  "WCB_ACCESS-ESMI1-5_245_noLandRCS_3" ="1c9DI4xha-yQXe--GKF5sNhQqReX5FTAy", #ha burned: 5,338,638 mean biomass: 60.0 Mg/ha
  "WCB_ACCESS-ESMI1-5_245_3" = "16Zvhw9M1enDgckUE3oincTWMudDwLRP3",#ha burned: 4,684,106 mean biomass: 47.5 Mg/ha
  #Access 370 - complete
  "WCB_ACCESS-ESMI1-5_370_noLandRCS_1" = "14b75A0GIPxuV7AEOSdahSEbNqh3pE5c5", #ha burned: 6,760,381 mean biomass: 56.5 Mg/ha
  "WCB_ACCESS-ESMI1-5_370_1" = "1Oh3OdS_UnLa12XStORjpQC91fPKVcMa3", #ha burned: 6,156,581, mean biomasss: 44.4 Mg/ha
  "WCB_ACCESS-ESMI1-5_370_noLandRCS_2" = "13LdmfmjQQSdQt3oo3ZPoNTiemFHlPe99", #ha burned: 6,307,419 mean biomass: 56.5 Mg/ha
  "WCB_ACCESS-ESMI1-5_370_2" = "12FfzNRHILsv80Lk0PoXSCYPnFORphYW3", #ha burned: 6,452,888 mean biomass: 43.7 Mg/ha
  "WCB_ACCESS-ESMI1-5_370_noLandRCS_3" = "1mDE5FvKMxSzc3qZx_t5CRTMMGCh3qKMY", #ha burned: 6,200,412 mean biomass: 57.2 Mg/ha
  "WCB_ACCESS-ESMI1-5_370_3" = "1qOAka8svH15h-vTumeMO_SJDd4lPvyfU", #ha burned: 6,011,744, mean biomass: 45.8 Mg/ha
  ####WB#### 90-year sumBurn = 9,779,156 ha, starting biomass = 56.4 Mg/ha
  #Historical
  "WB_historical_LandR_1" = "10ib9LAkHtScDx4DQsU_2C0c2yOSUSifc", #ha burned: 20,742,494 mean biomass: 38.0 Mg/ha
  "WB_historical_LandR_2" = "1y9tObV1i9SB0uqWKj9FuCjuFW_ifno1t", #ha burned: 20,377,562 mean biomass: 39.8 Mg/ha
  "WB_historical_LandR_3" = "1V21w_7qRyr2j3i0_YQPvd9UDWS9WQsiM", #ha burned: 20,257,194 mean biomass: 37.9 Mg/ha
  #CanESM5 245 - complete
  "WB_CanESM5_245_noLandRCS_1" = "1OCnnPYDFbORODmK7L7CTVCrp2cbNeMxO", #ha burned: 10,718,106 mean biomass: 43.4 Mg/ha
  "WB_CanESM5_245_1" = "1JkiU-xCpauXTPgGTNp_TPzCpMr19G2ny", #ha burned: 11,116,338, mean biomass: 40.2 Mg/ha
  "WB_CanESM5_245_noLandRCS_2" = "1CV2McNXSbvU9sqaA0TRx9ucgTrDVrqLY", #ha burned: 11,804,212  mean biomass: 42.4 Mg/ha
  "WB_CanESM5_245_2" = "1lXG5imoF5Iw8XNaZqM0-F1wY-HVQLz80", #ha burned: 10,699,494, mean biomass: 40.5 Mg/ha
  "WB_CanESM5_245_noLandRCS_3" = "1XpzNQ346wpYjURjr-QnHDmrJZSZIQprD", #ha burned: 11,379,300, mean biomass: 42.6 Mg/ha
  "WB_CanESM5_245_3" = "1D-NbvJ-Y34t-4INhMzfa-qTKDnK7qqgi", #ha burned: 11,641,694, mean biomass: 41.2 Mg/ha Mg/ha
  #CanESM5 370 - complete
  "WB_CanESM5_370_noLandRCS_1" = "1tgyY3MsA_oY3T4uAzvP0Rj8TqGF7Di6u", #ha burned: 12,235,231 mean biomass: 41.6 Mg/ha
  "WB_CanESM5_370_1" = "10O6KgAqdHJux-f1yFs5r6b4t2p7hAZe0", #ha burned: 12,479,438 mean biomass: 43.3 Mg/ha
  "WB_CanESM5_370_noLandRCS_2" = "1ie-aY-_ml4oTi4eunGEu4RoFQHJKPwsK", #ha burned: 12,590,238, mean biomass: 41.3 Mg/ha
  "WB_CanESM5_370_2" = "1YxvU0V54lyRdD_sQcT6pKo5sfDok6u_c", #ha burned: 11,783,944 mean biomass: 43.9 Mg/ha
  "WB_CanESM5_370_noLandRCS_3" = "1dFY33CT3EK_eSEHAZHES6Mh2W6FRKT1y", #ha burned: 12,548,238 mean biomass: 41.2
  "WB_CanESM5_370_3" ="1Zw5_P_mbjiXraVUPSNfyxOmq1lGpk84u", #ha burned: 11,376,500 mean biomass: 44.7 Mg/ha
  #CNRM 245  - complete
  "WB_CNRM-ESM2-1_245_noLandRCS_1" ="1xhf2hL4RQ9_mgIVkfViifBZZ4B3SZU5Y", #ha burned: 13,653,038 mean biomass: 40.4 Mg/ha
  "WB_CNRM-ESM2-1_245_1" = "1jmSr1I0W51wZBmIt9dD9gYBMVukfQA9A", #ha burned: 11,995,725 mean biomass: 40.5 Mg/ha
  "WB_CNRM-ESM2-1_245_noLandRCS_2" = "1wjqlhEnetPYXPjtKj4XEUbsobZOEmakT", #ha burned: 11,857,550 mean biomass 41.8 Mg/ha
  "WB_CNRM-ESM2-1_245_2" = "1IqXjEHwo-p-iYqmeH7TPBNUQi3KK2lSv", #ha burned: 13,071,506  mean biomass: 40.4 Mg/ha
  "WB_CNRM-ESM2-1_245_noLandRCS_3" = "1B0xcOZCpEY3vvurVrGYXQB9tgQIYZLOw",#ha burned: 12,622,894 mean biomass: 41.7 Mg/ha
  "WB_CNRM-ESM2-1_245_3" = "1t6ppxSHrbvjKw2RYvmi5w3CZKJCjMnaT", #ha burned: 14,160,619 mean biomass: 39.5 Mg/ha
  #CNRM 370 - complete
  "WB_CNRM-ESM2-1_370_1" = "1uCAMKkap-HVaTI58tSabnhKRYnY6d6kl",# ha burned: 13,748,756 mean biomass: 42.1 Mg/ha
  "WB_CNRM-ESM2-1_370_noLandRCS_1" = "1No6sg_bmOrLT7j-B5N_Xr4rhqNEltZ1y", #ha burned: 12,007,469 mean biomass: 42.6 Mg/ha
  "WB_CNRM-ESM2-1_370_2" = "1PBevRnxYxbJcXH-eTx2TMV30B1JgVEDv", #ha burned: 13,969,550 mean biomass: 39.0 Mg/ha
  "WB_CNRM-ESM2-1_370_noLandRCS_2" = "1GNtJVVAu57NsKaIdaDVVhXOgitY0qL45", #ha burned: 13,548,244 mean biomass: 40.8 Mg/ha
  "WB_CNRM-ESM2-1_370_3" = "1UJFX5lDb6JdN8Kborvi2By6SD48s4u6n", #ha burned: 13,240,562 mean biomass: 39.1 Mg/ha
  "WB_CNRM-ESM2-1_370_noLandRCS_3" = "1lGSGpKmcZ47TR68iNeejU-cTp5B7hQh9",# ha burned: 12,135,944 mean biomass: 42.6 Mg/ha
  #Access5 245 complete
  "WB_ACCESS-ESMI1-5_245_noLandRCS_1" = "1lVtqikuE82wYBQG_1wUOJFFr39zDWImu", #ha burned: 14,806,250 mean biomass: 39.6 Mg/ha
  "WB_ACCESS-ESMI1-5_245_1" = "1riUve5z6mug11iuC50RnxreE5Y7TKl6K", #ha burned: 13,371,031 mean biomass: 39.1 Mg/ha
  "WB_ACCESS-ESMI1-5_245_noLandRCS_2" = "1QuYpe2rN9PQvJNlQCDOLS1VgSzwQgqO7", # ha burned: 14,426,631, mean biomass: 40.5 Mg/ha
  "WB_ACCESS-ESMI1-5_245_2" = "1xA2KDpMuwJqNJ5zPm48nOXydazJXaGhM", #ha burned: 13,454,331 mean biomass: 38.9 Mg/ha
  "WB_ACCESS-ESMI1-5_245_noLandRCS_3" = "1w5vgNHwyQfOzhtvH9d4RLD93c4WkwxMm", #ha burned: 14,315,087 mean biomass: 39.7 Mg/ha
  "WB_ACCESS-ESMI1-5_245_3" = "1TPgrMIvhFto8GCU6G88_dBZasBWT0kGd", # ha burned: 15,040,119 mean biomass: 37.7 Mg/ha
  #Access5 370 - complete
  "WB_ACCESS-ESMI1-5_370_noLandRCS_1" = "1dy9ruwp00KnIyWywbLoxLjIS4HoWn0aI", #ha burned: 15,887,475 mean biomass: 39.4 Mg/ha
  "WB_ACCESS-ESMI1-5_370_1" ="1I020OO4jdfL7b0ZBVAIibWVYcF7sKTmX", #ha burned: 16,261,781 mean biomass: 35.6 Mg/ha
  "WB_ACCESS-ESMI1-5_370_noLandRCS_2" = "1EgMe-1bjE49DvenzHa0is26rSFXIO_zI", #ha burned: 16,485,812 mean biomass: 37.5 Mg/ha
  "WB_ACCESS-ESMI1-5_370_2" = "1tbjsGsXbE0tWjF28nsguiziJTqkoYFBj", #ha burned: 16,537,706 mean biomass: 35.7 Mg/ha
  "WB_ACCESS-ESMI1-5_370_noLandRCS_3" = "1a3jZFe1bJsbwMeSYAuA7tC1FGAUV3Ama",#ha burned: 15,960,194 mean biomass: 37.5 Mg/ha
  "WB_ACCESS-ESMI1-5_370_3" = "1GTd7fAd-k-X4utXh6FQTtgVR0A865VQt", #ha burned: 15,593,088 mean biomass: 36.9 Mg/ha

  ##### SB Assisted Migration####
  #CanESM5
  "SB_CanESM5_245_withNoAM_1" = "1JGC9kS32XcMSwL0Rreur1iny9kVDDPeI", #ha burned: 540,650 mean biomass: 78.9 Mg/ha
  "SB_CanESM5_245_withNoAM_2" = "18b0wyGmudbadAVstksD4CD5TgZR5yIfB", #ha burned: 523,694 mean biomass: 78.0 Mg/ha
  "SB_CanESM5_245_withNoAM_3" = "1OcDmkmjUnOqJzg24Az3aEtSxzlGzp0qf",#ha burned: 537,894 mean biomass: 86.0 Mg/ha #wtf?
  "SB_CanESM5_245_withAM_1" = "1w3eT1DwwMQcIlr9f9xuVr8Wxu5KY1YYN", #ha burned: 5,90,569, mean biomass: 86.52 #wtf?
  "SB_CanESM5_245_withAM_2" = "1GEbw7sqL4wqxEuIgnlz0TIWIjkcD2gzO", #ha burned: 570,738 mean biomass: 78.2 Mg/ha
  "SB_CanESM5_245_withAM_3" = "17rrl65akfFvILZRGFTwO6PDVYwlFkDuv", #ha burned: 549,494 mean biomass: 78.3 mg/ha


  #CNRM 245
  "SB_CNRM-ESM2-1_245_withNoAM_1" = "1GCu-pgqXaCNhjFZfgd1O2iB8htdyk4VP", #ha burned: 1,210,456 mean biomass: 77.9 Mg/ha
  "SB_CNRM-ESM2-1_245_withNoAM_2" = "1SX5t2ylH-Ukgz5qZcqefY28sDZMAwpEN", # ha burned: 1,097,512 mean biomass: 78.7 Mg/ha
  "SB_CNRM-ESM2-1_245_withNoAM_3" = "1PCu9Tq7mxppyN4IcpqZmey1zprLUcYBI", #ha burned: 1,114,812 mean biomass: 78.4 Mg/ha
  "SB_CNRM-ESM2-1_245_withAM_1" = "1Y6hhpLrXGyH6ktqnkIobEwtavfLcAg2b",# ha burned: 1,101,875 mean biomass: 78.0 Mg/ha
  "SB_CNRM-ESM2-1_245_withAM_2" = "1q0X11ZZPDaSQl2IzhlAkzWbRb3a1doUX", #ha burned: 1,073,269 mean biomass: 78.5 Mg/ha
  "SB_CNRM-ESM2-1_245_withAM_3" = "19td3XalfwPQYw-b-JkwTRC5LtGmKBz3F", #ha burned: 1,059,300 mean biomass: 77.9 Mg/ha
  #CNRM 370
  "SB_CNRM-ESM2-1_370_withNoAM_2" = "19YST9IA1_5V54hbANCru6omvlKALOXpu", #ha burned: 1,593,281, mean biomass: 74.2 Mg/ha
  "SB_CNRM-ESM2-1_370_withNoAM_3" = "12hYAdxqyE-HjXKxbNAx1Z9b-U_tc_DML", #ha burned: 1,616, 856 mean biomass: 73.0 Mg/ha
  "SB_CNRM-ESM2-1_370_withAM_1"= "1c4YCz1wUp6lDFxoMna6Tr9O9BktmKfTs", #ha burned: 1,586,962 mean biomass: 74.0 Mg/ha
  "SB_CNRM-ESM2-1_370_withAM_2" = "1KLqN5asIfUIaiNtgIEXLvQw65Zn_SlSo", #ha burned: 1,568,038 mean biomass: 74.0 Mg/ha
  "SB_CNRM-ESM2-1_370_withAM_3" = "1CEAtFwY4dQx1oqSfx_vcbgvKah9C0C1X" #ha burned: 1,418,131 mean biomass: 74.1 Mg/ha



)

