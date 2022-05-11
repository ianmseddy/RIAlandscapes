#notes on running
I used the batchRunCreate script to create a table that contained the structure of study area, GCM, SSP, growth and mortality driver (gmcsDriver),
AM setting (on or off), AM scenario (with AM or without) and replicate. Ultimately I decided it was easier to create a second table for AM,
as this is essentially a second type of simulation, with different modules (AssistedMigrationBC, simpleHarvest), no non-climate-sensitive growth setting, a mandatory study area of SB (no data on the Yukon portions of other study areas), special ecoregions, etc.


To run everything, subset part of the table using the batchRunControl.R script, and then source the global script. Users on new machines should configure settings such as temp drive location using the config.yml script. I never set up parallelization, but it would be nice to save some time.
Later I allowed for a "300yr" replicate name, if the GCM is set to "historical". This is missing from the table, as it was only intended
to be a qualitative assessment of model performance. But since biomass declined in all reference runs, I wanted to confirm if it rebounded.

The post-processing and generation of figures is controlled by 10-functions, 10a-postProcessing, 10b-FireResults, and 10c-Biomass Results.
The 10a-postProcessing script is used to download all the study areas and reps from Google drive.
All of this uses 'for' loops and is a bit clunky and ad hoc.
The functions in the 10-functions script are mainly used to change the structure of the results from lists to
raster stacks or lists of mosaicked rasters, etc.
They are hard-coded to search for names of study areas, gcms, etc. in the objects.
I did not use any of the PredictiveEcology postProcessing functions - I was too pressed for time to confirm if the structure of reps and what not
would easily match my own. The biomass scripts do not need to be run after the fire scripts.

Also I treated all climate-sensitive and non-climate-sensitive growth runs as shared replicates for the purposes of fire,
as there is only very limited indirect feedbacks on fire from climate-sensitive growth (from my superficial estimate of MAAB ~ gmcsDriver + studyArea + GCM + SSP, no effect at all).
