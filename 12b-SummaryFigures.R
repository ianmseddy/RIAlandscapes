library(reproducible)
library(data.table)
library(ggplot2)
library(raster)



outputDir <- "outputs"
SBsim <- qs::qread("outputs/SB/biomassMaps2011_SB.qs")
WBsim <- qs::qread("outputs/WB/biomassMaps2001_WB.qs")
WCBsim <- qs::qread("outputs/WCB/biomassMaps2011_WCB.qs")

ageMap_SB <- SBsim$standAgeMap
LCC_SB <- SBsim$rstLCC
ageMap_WB <- WBsim$standAgeMap
LCC_WB <- WBsim$rstLCC
ageMap_WCB <- WCBsim$standAgeMap
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
                                   "Wetland"))

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
writeRaster(RIAage, "outputs/summary rasters/RIAageMap.tif")
writeRaster(RIAlcc, "outputs/summary rasters/RIAlcc.tif")
