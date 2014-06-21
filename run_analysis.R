#-----------------------Source the data-------------------------------------
# Check wther the data files is availble in the working directory.
require(RCurl) # Package is needed to download file, if you 
if (!file.exists("UCI HAR Dataset")) {
        # Check wthether the zip archive is available.
        if (!file.exists("getdata_projectfiles_UCI HAR Dataset.zip")) {
                # Define data source.
                dataurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"  
                # Download, save and unzip the file.
                library(RCurl)
                bin <- getBinaryURL(dataurl, ssl.verifypeer=FALSE, 
                                    noprogress = FALSE)
                con <- file("getdata_projectfiles_UCI HAR Dataset.zip",
                            open = "wb")
                writeBin(bin, con)
                close(con)
                unzip("getdata_projectfiles_UCI HAR Dataset.zip")
        } else
                unzip("getdata_projectfiles_UCI HAR Dataset.zip")
}
files <- list.files(path = "UCI HAR Dataset", pattern = "*.txt", all.files = TRUE,
           recursive = TRUE, full.names = TRUE)

# Checks whether the folder had some text files.
if (length(files) == 0) {
        stop("It appears that the required data is missing.")
}
#----------------------Create data frames--------------------------------------
# files from the inertial folder is removed from the list of the files
files <- files[!grepl("Inertial", files)]
# Remaining data files are read as data frames for manipulation
xtest <- read.table(files[grepl("X_test", files, ignore.case = TRUE)], 
                    header = FALSE)
ytest <- read.table(files[grepl("Y_test", files, ignore.case = TRUE)],
                    header = FALSE)
xtrain <- read.table(files[grepl("X_train", files, ignore.case = TRUE)],
                   header = FALSE)
ytrain <- read.table(files[grepl("y_train", files, ignore.case = TRUE)],
                   header = FALSE)
# Reading the fatures data and activity and subjects
features <- read.table(files[grepl("Dataset/features.txt", files,
                                   ignore.case = TRUE)], header = FALSE)
act <- read.table(files[grepl("activity", files,
                                   ignore.case = TRUE)], header = FALSE)
subjtest <- read.table(files[grepl("subject_test", files,
                              ignore.case = TRUE)], header = FALSE)
subjtrain <- read.table(files[grepl("subject_train", files,
                                   ignore.case = TRUE)], header = FALSE)
# -------------------------Transformations-------------------------------------
# Transform feature names to the valid names
features[,2] <- make.names(features[,2])
# Usea features to name the data frames. Training and test data is marked
colnames(xtrain) <- features[,2]
colnames(xtest) <- features[,2]
# Combing ytest xtest and required activity data
i <- NULL
for (i in 1 : nrow(act)) {
        ytest$V1[ytest$V1  == i] <- as.character(act[i,2])
        ytrain$V1[ytrain$V1  == i] <- as.character(act[i,2])
        i <- i + 1
}
#------------------------Merging the data--------------------------------------
testdta <- cbind(subjtest, ytest, xtest)
traindta <- cbind(subjtrain, ytrain, xtrain)
dta <- rbind(testdta, traindta)
#------------------------Cleaning----------------------------------------------
# Keep columns from the master data that corrspond to desired mearues
colnames(dta)[2] <- "Activity"
colnames(dta)[1] <- "Subject"
measures=c('std','mean', 'Activity', 'Subject')
dta <- dta[ , grepl(measures[1] , names(dta)) | 
                    grepl(measures[2] , names(dta)) |
                    grepl(measures[3] , names(dta)) |
                   grepl(measures[4] , names(dta))]
# Redundant objects are removed, this will only keep the data frame.
rm(list=ls()[!grepl('^dta$',ls())]) 
#-------------------------Create second independent data set-------------------
# Create summary values for the clean data, non-numeric values are removed
# to avoid the errors
aves = aggregate(dta[,sapply(dta, is.numeric)],
                 by=list(dta$Subject, dta$Activity),FUN=mean)
# Rename the columns
names(aves)[1] <- "Subject"
names(aves)[2] <- "Activity"
# Sorrt data frame
aves <- aves[order(aves$Subject, aves$Activity),]
# Row names are removed in order not to mess up the export and later import
rownames(aves) <- NULL
# Export tidy data
write.table(aves, "tidy.txt", sep="\t")