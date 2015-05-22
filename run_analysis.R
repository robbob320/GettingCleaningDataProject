### GETTING AND CLEANING DATA  - Project

# download and unzip the files
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              destfile = "./dataset.zip")
unzip("dataset.zip")

#read all components of data - part 1, training set
xtrainFilename <- file.path('UCI HAR Dataset', 'train', 'X_train.txt')
xtrain <- read.table(xtrainFilename)
ytrainFilename <- file.path('UCI HAR Dataset', 'train', 'y_train.txt')
ytrain <- read.table(ytrainFilename)
subjecttrainFilename <- file.path('UCI HAR Dataset', 'train', 'subject_train.txt')
subjecttrain <- read.table(subjecttrainFilename)
#read all components of data - part 2, test set
xtestFilename <- file.path('UCI HAR Dataset', 'test', 'X_test.txt')
xtest <- read.table(xtestFilename)
ytestFilename <- file.path('UCI HAR Dataset', 'test', 'y_test.txt')
ytest <- read.table(ytestFilename)
subjecttestFilename <- file.path('UCI HAR Dataset', 'test', 'subject_test.txt')
subjecttest <- read.table(subjecttestFilename)

#bind all components of training data and test data into one data frame
trainframe <- cbind(xtrain, ytrain, subjecttrain)
testframe <- cbind(xtest, ytest, subjecttest)
mainframe <- rbind(trainframe, testframe)

#label the variables according to feature names provided
labelFilename <- file.path('UCI HAR Dataset', 'features.txt')
labels <- read.table(labelFilename, sep = " ")
labels <- c(as.character(labels[,2]), "activity", "subject")
colnames(mainframe) <- labels

#choose only variables which are means and standard deviations
means <- which(grepl("mean", colnames(mainframe)))
stds <- which(grepl("std", colnames(mainframe)))
extractedframe <- mainframe[,c(means, stds, ncol(mainframe)-1, ncol(mainframe))]

#make the activity a factor and name its levels according to the labels provided
activityFilename <- file.path('UCI HAR Dataset', 'activity_labels.txt')
actlabels <- read.table(activityFilename, sep = " ")
extractedframe$activity <- factor(extractedframe$activity, labels = actlabels[,2])

#melt the frame according to subject and activity in order to obtain atomic data
library(reshape2)
molten <- melt(extractedframe, id = c("subject", "activity"))
#aggregate the data according to subject and activity, computing their means
tidyframe <- dcast(molten, formula = subject + activity ~ variable, 
                   fun.aggregate = mean)

write.table(tidyframe, "tidyDataSet.txt", row.names = FALSE)
