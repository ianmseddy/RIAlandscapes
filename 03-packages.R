
Require(c("data.table", "plyr", "pryr"), upgrade = FALSE) ## ensure plyr loaded before dplyr or there will be problems


Require::Require("PredictiveEcology/SpaDES.install (>= 0.0.5)", upgrade = FALSE)
Require(c("PredictiveEcology/SpaDES.core@development (>=1.0.6.9023)"),
        which = c("Suggests", "Imports", "Depends"), upgrade = FALSE) # need Suggests in SpaDES.core
Require("PredictiveEcology/SpaDES.project", upgrade = FALSE, which = c("Suggests", "Imports", "Depends"))

# Require("jimhester/archive", upgrade = FALSE)
Require(c("RCurl", "fasterize","raster", "sf", "data.table", "magrittr"), upgrade = FALSE)

