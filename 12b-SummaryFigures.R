library(reproducible)
library(data.table)
library(ggplot2)
library(raster)
library(nngeo)
library(sf)
#these are simple maps and figures of the study areas#
#they make use of sim objects but are otherwise unrelated
setwd("C:/Ian/Git/RIAlandscapes")

outputDir <- "outputs"
#study Areas - aggregated SA was missing...
SBsim <- qs::qread("outputs/SB/biomassMaps2001_SB.qs")
WBsim <- qs::qread("outputs/WB/biomassMaps2001_WB.qs")
WCBsim <- qs::qread("outputs/WCB/biomassMaps2001_WCB.qs")

studyAreas <- list(SB = SBsim$studyAreaReporting,
                   WB = WBsim$studyAreaReporting,
                   WCB = WCBsim$studyAreaReporting)
tempSAR <- lapply(studyAreas, st_as_sf)
SAshp <- rbind(tempSAR$WB, tempSAR$WCB, tempSAR$SB)
SAshp <- nngeo::st_remove_holes(SAshp)
# st_write(SAshp, dsn = "outputs/RIA_3studyArea.shp")


SBsim <- qs::qread("outputs/SB/fSsimdataPrep_fuelClass_SB.qs")
WBsim <- qs::qread("outputs/WB/fSsimdataPrep_fuelClass_WB.qs")
WCBsim <- qs::qread("outputs/WCB/fSsimdataPrep_fuelClass_WCB.qs")

#something is wrong with the postProcess of standAgeMap SB
ageMap_SB <- SBsim$standAgeMap2011
LCC_SB <- SBsim$rstLCC
ageMap_WB <- WBsim$standAgeMap2011
LCC_WB <- WBsim$rstLCC
ageMap_WCB <- WCBsim$standAgeMap2011
LCC_WCB <- WCBsim$rstLCC

rm(WBsim, WCBsim, SBsim)


#generate histograms.
SBdat <- data.table(studyArea = "SB", age = getValues(ageMap_SB), LCC = getValues(LCC_SB))
WBdat <- data.table(studyArea = "WB", age = getValues(ageMap_WB), LCC = getValues(LCC_WB))
WCBdat <- data.table(studyArea = "WCB", age = getValues(ageMap_WCB), LCC = getValues(LCC_WCB))

SAdata <- rbind(SBdat, WBdat, WCBdat)
SAdata <- na.omit(SAdata)

LCCLeg <- data.table(LCC = 1:20,
                     Landcover = c("Temperate/Sub-polar needleleaf forest", #1
                                   "Polar/Sub-polar taiga needleleaf forest", #2,
                                   "Tropical/Sub-tropical broadleaf evergreen forest", #3
                                   "Tropical/Sub-tropical deciduous forest", #4,
                                   "Temperate/Sub-polar deciduous forest", #5
                                   "Mixed forest", #6,
                                   "Tropical shrubland", #7,
                                   "Shrubland", #8,
                                   "Tropical grassland", #9,
                                   "Grassland", #10
                                   "Shrubland-lichen-moss", #11
                                   "Grassland-lichen-moss", #12
                                   "Barren-lichen-moss", #13
                                   "Wetland", "Cropland", "Barren", "Urban", #17
                                   "Water", "Snow and Ice",
                                   "Wetland (NFIS*)"))

SAdata <- LCCLeg[SAdata, on = c("LCC")]
SAdata[, totalN := .N, .(studyArea)]
LCCSAdata <- SAdata[, .(count = .N), .(Landcover, totalN, studyArea, LCC)]
LCCSAdata[, LCCpct := count/totalN * 100]
setkey(LCCSAdata, LCC)


LCCHistograms <- ggplot(data = LCCSAdata, aes(x = LCCpct, y = reorder(Landcover, LCC, .fun = 'min'),
                                              fill = studyArea)) +
                          geom_bar(stat = "identity", position = "dodge") +
                          labs(x = "percent cover", y = "Landcover", fill = "Biome")
LCCHistograms
ggsave(file.path(outputDir, "summary figures", "LCCbyBiome.png"), plot = LCCHistograms, device = "png")

AgeHistogram <- ggplot(data = SAdata[LCC %in% c(1:6, 20)], aes(x = age)) +
  geom_density(size = 1) +
  facet_wrap(~studyArea) +
  labs(x = "stand age (kNN)") +
  theme_bw()
AgeHistogram
ggsave(file.path(outputDir, "summary figures", "AgeDistByBiome.png"), plot = AgeHistogram, device = "png")


###mosaic maps #####
RIAage <- raster::mosaic(ageMap_SB, ageMap_WB, ageMap_WCB, fun = "max")
RIAlcc <- raster::mosaic(LCC_SB, LCC_WB, LCC_WCB, fun = "min")
if (FALSE) {
writeRaster(RIAage, "outputs/summary rasters/RIAageMap.tif", overwrite = TRUE)
writeRaster(RIAlcc, "outputs/summary rasters/RIAlcc.tif")
}


####fire####

###


flamAreaSB <- sum(SBsim$flammableRTM[], na.rm = TRUE) * 6.25
flamAreaWCB <- sum(WCBsim$flammableRTM[], na.rm = TRUE) * 6.25
flamAreaWB <- sum(WBsim$flammableRTM[], na.rm = TRUE) * 6.25

firePolys_WB <- WBsim$firePolysForAge
firePolys_SB <- SBsim$firePolysForAge
firePolys_WCB <- WCBsim$firePolysForAge


rm(SBsim, WCBsim, WBsim)

#I think we want to compare the MAAB (as a % of flammable area)
firePolys_WB <- do.call(rbind, firePolys_WB)
#the nulls need to be rm
toRM <- lapply(firePolys_SB, is.null)
firePolys_SB <- firePolys_SB[!unlist(toRM)]
firePolys_SB <- do.call(rbind, firePolys_SB)
firePolys_WCB <- do.call(rbind, firePolys_WCB)
#for maps
firePolys_RIA <- rbind(firePolys_SB, firePolys_WCB, firePolys_WB)
firePolys_RIA <- st_as_sf(firePolys_RIA)
# st_write(firePolys_RIA, "outputs/RIA_3studyArea_firePolys.shp")
firePolys_RIA <- as.data.table(firePolys_RIA)
firePolys_RIA[as.numeric(POLY_HA) > SIZE_HA]# there is some rounding error, no big issue
fpdt <- firePolys_RIA[, .(AAB = sum(as.numeric(POLY_HA)), N = .N, meanFS = mean(as.numeric(POLY_HA))),
                      .(YEAR, studyAreaName)]

flammableArea <- data.table(studyAreaName = c("SB", "WB", "WCB"),
                            flamArea = c(flamAreaSB, flamAreaWB, flamAreaWCB))
fpdt <- flammableArea[fpdt, on = c("studyAreaName")]
fpdt[, pctBurn := AAB/flamArea * 100]

MFSgg <- ggplot(data = fpdt, aes(x = YEAR, y = meanFS, col = studyAreaName)) +
  geom_point(size = 1.2, alpha = 0.6) +
  geom_smooth(alpha = 0.2, se = FALSE, method = "lm") +
  labs(x = "year", y = "mean annual fire size (ha)", col = "biome") +
  ylim(0, NA)
MFSgg
ggsave("outputs/summary figures/MFSbyBiome_lm.png", plot = MFSgg, device = "png")

AABgg <- ggplot(data = fpdt, aes(x = YEAR, y = AAB/100, col = studyAreaName)) +
  geom_point(size = 1.2, alpha = 0.6) +
  geom_smooth(alpha = 0.2, se = FALSE) +
  labs(x = "year", y = "annual area burned (km2)", col = "biome") +
  ylim(0, NA)
AABgg
ggsave("outputs/summary figures/AABurnedByBiome.png", plot = AABgg, device = "png")

PtBgg <- ggplot(data = fpdt, aes(x = YEAR, y = pctBurn, col = studyAreaName)) +
  geom_point(size = 1.2, alpha = 0.6) +
  geom_smooth(alpha = 0.2, se = FALSE, method = "lm") +
  labs(x = "year", y = " area burned (%)", col = "biome",
       title = "NFDB data 1986-2020") +
  ylim(0, NA)
PtBgg
ggsave("outputs/summary figures/PctAreaBurnedByBiome_lm.png", plot = PtBgg, device = "png")

NFiresgg <- ggplot(data = fpdt, aes(x = YEAR, y = N, col = studyAreaName)) +
  geom_point(size = 1.2, alpha = 0.6) +
  geom_smooth(alpha = 0.2, se = FALSE, method = "lm") +
  labs(x = "year", y = "annual number of fires", col = "biome", title = "NFDB data 1986-2019")
NFiresgg
ggsave("outputs/summary figures/NfiresByBiome_lm.png", plot = NFiresgg, device = "png")
