source("run_analysis.R")
library(assertr)
library(magrittr)

## ensure harData is of correct dim
verify(harData, ncol(harData) == 
           length(unique(union(names(testData), names(trainData))))) %>%
verify(nrow(harData) == nrow(testData) + nrow(trainData))


## ensure mean/std data set contains the correct number of columns
##  - counted by hand, there are 66 mean/std features
##  - plus 4 added by me
verify(harDataMeanSD, ncol(harDataMeanSD) == 70)


## ensure mean/std gathered data has the correct dim
##  - the mean/std data has 10299 rows and 70 columns, 66 of which are being
##    gathered
verify(harDataGathered, nrow(harDataGathered) == nrow(harDataMeanSD) * (ncol(harDataMeanSD)-4))
