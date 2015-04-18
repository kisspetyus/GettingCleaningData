##1) Merges the training and the test sets to create one data set.

##reading train data (tr is train data)
tr <- read.table("UCI HAR Dataset//train/X_train.txt")

##reading test data (te is test data)
te <- read.table("UCI HAR Dataset//test//X_test.txt")

##merging train and test (t is the merged data)
t <- rbind(tr,te)


##2) Extracts only the measurements on the mean and standard deviation for each measurement. 

##reading column name (tl contains the column names)
tl <- read.table("UCI HAR Dataset//features.txt")

##selecting the mean() and std() columns (fm contains the row number of the mean columns, fs contains the row number of the std columns)
fm <- grep("mean()",tl$V2,fixed = T)
fs <- grep("std()",tl$V2,fixed = T)

##selecting only the columns where the column numbers are identical with the two arrays of the previous step
t <- t[,c(fm,fs)]



##3) Uses descriptive activity names to name the activities in the data set
##read train activity file (trac is the train activity file)
trac <- read.table("UCI HAR Dataset/train/y_train.txt")

##read test activity file (teac is the test activity file)
teac <- read.table("UCI HAR Dataset/test/y_test.txt")

##adding the two activity dataset together
tac <- rbind(trac,teac)
names(tac) <- "act_code"

##binding the activity dataset with the dataset from step 2
t1 <- cbind(tac,t)

##reading the activity label file
acl <- read.table("UCI HAR Dataset/activity_labels.txt")
names(acl) <- c("act_code","activity")

##merging the activity label data and the dataset based on the activity code
tm <- merge(t1,acl,by.x = "act_code", by.y="act_code")

##rearranging the columns
tm <- tm[,c(1,68,2:67)]

##4) Appropriately labels the data set with descriptive variable names. 
##selecting the relevant column names from the column names data (tl)
tl1 <- tl[c(fm,fs),]
tmname <- as.character(tl1$V2)
names(tm) <- c("act_code","activity", tmname)


##5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##reading the subject files: train and test
trs <- read.table("UCI HAR Dataset//train//subject_train.txt")
tes <- read.table("UCI HAR Dataset//test//subject_test.txt")

##binding the train and test subject files
ts <- rbind(trs,tes)

##binding the subject data with the dataset
tms <- cbind(ts,tm)
names(tms) <- c("subject","act_code","activity", tmname)
 
##loading the reshape2 package
library(reshape2)

##selecting the column names of the measure variables
meas <- names(tms[,4:69])

##melting the file
tmsmelt <- melt(tms,id=c("subject","act_code","activity"),measure.vars = meas)

##casting the melted files by the subject and the activity category
tmscast <- dcast(tmsmelt, subject + activity ~ variable, mean)
write.table(tmscast,"ActivityTidy.txt",row.name=F)
