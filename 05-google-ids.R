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

  ####SB#### - 90 year sumBurn ~ 2,500,000 ha - starting biomass = 130 Mg/ha
  "SB_historical_LandR_1" = "1fj7EG4oi9F9OSkRagKUKneJX1hd-D7Rv", #ha burned 1,336,468 mean biomass: 104.9 Mg/ha
  "SB_historical_LandR_2" = "190X5CtBae59v1J7JtWJv249Tv43qvo-a", #ha burned: 1,285,856 mean biomass: 105.0 Mg/ha
  "SB_historical_LandR_3" = "1FpMgizvPqSTc6sIzNwpS1qghFI1hqMNy", #ha burned: 1,349,637 mean biomass: 105.0 Mg/ha
  "SB_INM-CM4_RCP45_noLandRCS_1" = "1cbCOnwI340TMQ8dT7BIfN1pcIZrM7yhb", #ha burned: 1,002,362 mean biomass: 106.0 Mg/ha
  "SB_INM-CM4_RCP45_noLandRCS_2" = "1nGjzMrLzbhwvxztta3h6Ek3H4FhnDebq", #ha burned: 974,481 mean biomass: 106.5
  "SB_INM-CM4_RCP45_noLandRCS_3" = "1ZujxCREE1vQG4L1cjBKZFlsjIsfMKsqW", #ha burned: 1,012,400 mean biomass: 105.7 Mg/ha
  "SB_INM-CM4_RCP45_1" = "14N_xBrTFDVLvc4ZS-JElnPcAyyG5VNmW", #ha burned: 947,718 mean biomass: 96.5 Mg/ha
  "SB_INM-CM4_RCP45_2" = "1phDs9nfUEPiZ1sl-70qH-GGgS9XB9cJK", #ha burned: 947,881 mean biomass: 96.7 Mg/ha
  "SB_INM-CM4_RCP45_3" = "1HZR6D2QSDMgFHHXh8hN-92kyv792fBNh", #ha burned: 1,019,194 mean biomass: 96.5 Mg/ha
  "SB_INM-CM4_RCP85_noLandRCS_1" = "1dRkN4GrwveTcUPSTiKHx9vF_WeYgyeSh", #ha burned: 1,253,025 mean biomass: 104.4 Mg/ha
  "SB_INM-CM4_RCP85_noLandRCS_2" = "1w7zRa0WSddAK7fFGpQuBFhc5xm6Wl_q0", #ha burned: 1,303,512 mean biomass: 103.6 Mg/ha
  "SB_INM-CM4_RCP85_noLandRCS_3" = "1InQhlMUsKhDXdjIm5pvDg9MmZ6tXrNDE", #ha burned: 1,253,181 mean biomass: 104.4 Mg/ha
  "SB_INM-CM4_RCP85_1" = "1ihnx6KeS9-PaTs0k7F8FhDQkenIKlFOg", #ha burned: 1,298,737 mean biomass: 95.7 Mg/ha
  "SB_INM-CM4_RCP85_2" = "1Y-aiOmIdTQKVrOJuOxPymLYAj_-E3Dwb", #ha burned: 1,368,948 mean biomass: 95.6 Mg/ha
  "SB_INM-CM4_RCP85_3" = "11ErJY5eya_Ib0pQEZLNrOuK8pFsw7ytQ", #ha burned: 1,381,643 mean biomass: 94.8 Mg/ha
  "SB_CanESM2_RCP45_noLandRCS_1" = "1oxXtV1km5z-B9oD7pVpE6ZkT7di2Z6Sw",  #ha burned: 4,580,131 mean biomass: 92.8 Mg/ha
  "SB_CanESM2_RCP45_noLandRCS_2" = "1Ig2HXRzhIwC1jcgn-OqS3sdv_CoJ_JAw", #ha burned: 4,445,556 mean biomass: 92.8 Mg/ha
  "SB_CanESM2_RCP45_noLandRCS_3" = "1pvK0NltQNqRt6E5uHbrpAaevOa_lSYWi", #ha burned: 4,510,037 mean biomass: 92.0 Mg/ha
  "SB_CanESM2_RCP45_1" = "1P607lmq4dS0p5OtpRdLLbBw_LyzrbhUP", #ha burned: 4,421,950 mean biomass: 95.9 Mg/ha
  "SB_CanESM2_RCP45_2" = "1QT5CQeP-PaCBLj-VD46rSotjPgc891p5", #ha burned: 4,395,894 mean biomass: 95.7 Mg/ha
  "SB_CanESM2_RCP45_3" = "1v6qCPoYpCWWHSKSrmDbUvoNUB77Qz5s3", #ha burned: 4,402,841 mean biomass: 93.7 Mg/ha
  "SB_CanESM2_RCP85_noLandRCS_1" = "1l22il-apprl7vlgqtUNuqgbtVw3iNMjN", #ha burned:  6,910,900 mean biomass: 76.6 Mg/ha
  "SB_CanESM2_RCP85_noLandRCS_2" = "1-akO9BMs49ucwLnVymJEc5YGvydBuWEw", #ha burned: 6,810,356 mean biomass: 77.1 Mg/ha
  "SB_CanESM2_RCP85_noLandRCS_3" = "1J5mb82tEM-nA2Qfmjjvku1KXjRbMEjgh", #ha burned: 6,563,131 mean biomass: 79.0 Mg/ha
  "SB_CanESM2_RCP85_2" = "1mMkNP9IA9OCIqBnVzDlvxPUFaFkMtnth", #ha burned: 7,059,218 mean biomass: 80.6 Mg/ha
  "SB_CanESM2_RCP85_3" = "1nDWQ4hiDotmWdU_AtZwEQiT5BhBnvomQ", #ha burned: 6,741,387 mean biomass: 80.0 Mg/ha

  "SB_Access1_RCP45_noLandRCS_1" = "1Wu72zTwguASEtJriozVOlzjAcyEXUi0D", #ha burned: 5,459, 475 mean biomass: 85.8 Mg/ha


  "SB_Access1_RCP45_1" = "1LJhFX9rqEfd8U2QBaWn0B6x9lITOF9Z9", #ha burned: 5,767,237 mean biomass: 78.4 Mg/ha
  "SB_Access1_RCP45_2" = "1HqdL1ArgzLKHZt90GrCqXQ43OyYg_oln", #ha burned: 6,069,481 mean biomass: 77.8

  "SB_Access1_RCP85_noLandRCS_1" = "1z7hIS4bPh0enRsIPy4LdB1JUe_cr30d8", #ha burned: 8,188,531 mean biomass: 73.5 Mg/ha
  "SB_Access1_RCP85_noLandRCS_2" = "1qe5_ZilhRYhKjhI-BJew-uxar3ullB3w", #ha burned: 8,113,231 mean biomass: 72.4 Mg/ha
  "SB_Access1_RCP85_noLandRCS_3" = "17gks6tXzmmMWT4N9swsLSI7rtL9ZIxe5", #ha burned: 7,814,387 mean biomass: 73.5 Mg/ha
  "SB_Access1_RCP85_1" = "1B8xkOJULK69E_cONjBmGtBG70Za-qPjQ", #ha burned: 8,432,643 mean biomass: 68.4 Mg/ha
  "SB_Access1_RCP85_2" = "1u7VYuFY3qnJFPIfOn3wPmko0c-AjsOJ2", #ha burned: 6,224,412 mean biomass: 77.6 Mg/ha
  "SB_Access1_RCP85_3" = "1yD-8Ct0bWpOAI_s_JfCwBoRHIbEjc6ng", #ha burned: 6,270,512 mean biomass: 78.5 Mg/ha

  ##WB 90-year sumBurn = 9,779,156 ha, starting biomas = 56.4 Mg/ha
  "WB_historical_LandR_1" = "1HDYLSdMNIwqRmiepP67z1M3xQfyN1dTF", #ha burned: 17,607,643 mean biomass: 40.0
  "WB_historical_LandR_3" = "1G_91qxbb9CyR9H3NSNYE2ixua3WnVK3Y", #ha burned: 27,851,543 mean biomass: 42.1
  "WB_Access1_RCP45_1" =  "1nTS_GiOrQz-k2XJKkwvqhyihj96qq-qf", #ha burned: 19,356,950 mean biomass:  32.84 Mg/ha #new spp
  "WB_Access1_RCP85_1" = "1yl2P-a_qqI2_7AUtYgDfgUQQCdpjGnIG", #ha burned: 20,831,112 mean biomass: 34.6 Mg/ha


  #WCB: 90-year sumBurn = 6,294,584 biomass 2011 = 66 Mg/ha
  "WCB_historical_LandR_1" = "1HeNIG0xE0AgDmr9AaChjrZATd8IXmJd", #ha burned: 7,571,621 mean biomass: 60.1 Mg/ha
  "WCB_historical_LandR_3" = "1E1iDnn1W1qEmZjm-NecKwCW3rpPGxEjk", #ha burned: 8,126,006 mean biomass: 59.0 Mg/ha
  "WCB_Access1_RCP45_1" = "1OH6ELQxmq6PyoMJYu32znfO3pSxgouHC", #ha burned: 10,685,531, mean biomass: 40.3 Mg/ha
  "WCB_Access1_RCP45_2" = "1WQpks0BgarwvN7VtqV1nQYgFmjK1TXHN", #ha burned: 10,375,575, mean biomass: 42.8 Mg/ha
  "WCB_Access1_RCP45_noLandRCS_3" = "1hu1Z5rh_f2JpFUM83PRO0f9FFxlq-zmi", #ha burned: 10,246,050 mean biomass: 55.6 Mg/ha
  "WCB_Access1_RCP85_1" = "1soWkclJc3v3jmUZCvyU6STA6HJOLOvuN", #ha burned: 12,582,225 mean biomass: 36.1 Mg/ha
  "WCB_Access1_RCP85_2 "= "14SGVo7xAgdKY8O15_bhEvagxReZ-1sbU", #ha burned: 12,733,256 mean biomass: 38.5
  "WCB_Access1_RCP85_noLandRCS_1" = "1Tl_xF8havp7CjJKNl32uAhdxpyTfdrzY", #ha burned: 12,924,618 mean biomass: 47.9 Mg/ha
  "WCB_CanESM2_RCP45_1" = "1n72z60QpGyOKJcFKmNMItRtbpuvFwlFe", #ha burned: 11,196,275 mean biomass: 41.8 Mg/ha
  "WCB_CanESM2_RCP45_2" = "1oWDAJAa635X1BjGiIsqz0ULCIw3gv1Tu", #ha burned: 11,677,200 mean biomass: 44.6 Mg/ha
  "WCB_CanESM2_RCP45_noLandRCS_2" = "1NQFMecdV1YVzPQcbYNJ_W3FZU9JHYc-4", #ha burned: 10,639,025 mean biomass: 54.7 Mg/ha
  "WCB_CanESM2_RCP85_1" = "10c982ZNJRs9YEH5gOqePhy0yDjhJBzU0", #ha burned 15,493,487 mean biomass: 36.0 Mg/ha
  "WCB_CanESM2_RCP85_3" = "1MPz2JrldpLu7oFmVJreA1HGyGds0h-NL", #ha burned: 15,822,462 mean biomass: 38.9 mg/ha
  "WCB_CanESM2_RCP85_noLandRCS_2" = "1SEmgVX1SdN5flOBN5F6dIsMaa1tsA4rk", #ha burned: 15376325 mean biomass: 45.7 Mg/ha
  "WCB_INM-CM4_RCP45_1" = "1ovMDtbfK07xLgeiUiZDwagydGeMcXXuZ", #ha burned: 5,354,043 mean biomass: 48.9 Mg/ha
  "WCB_INM-CM4_RCP45_3" = "1wnvdur51qw0cPaPeG5XSrih6UGcZikE1", #ha burned: 5,303,118 mean biomass: 50.5 Mg/ha
  "WCB_INM-CM4_RCP45_noLandRCS_2" = "1SSEMP7Y3zFe-5JQGA256fGOOjpzlZQ43", #ha burned: 4,953,062 mean biomass: 64.8 Mg/ha
  "WCB_INM-CM4_RCP85_1" = "1_W7XgppzAwZ-TU5wGgAhZOCjjrbnqJvP", #ha burned: 5,509,119 mean biomass: 46.5 Mg/ha
  "WCB_INM-CM4_RCP85_3" = "171PdcPsz5uWYHyXA4xe9aVgYWPy2D_Jd", #ha burned: 5,332,137 mean biomass: 47.7 Mg/ha
  "WCB_INM-CM4_RCP85_noLandRCS_2" = "11b78CEsOCJjOk2udvMkflP0jiuclE5tm" #ha burned: 5,663,525 mean biomass: 61.9 Mg/ha

  )

