rm(list = ls())

setwd("~/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")

#1

feature<-read.table("features.txt",header=FALSE)

trainingset<-read.table("train/X_train.txt",col.name=feature$V2)
traininglabel<-read.table("train/y_train.txt",col.name="labels")
trainingsubject<-read.table("train/subject_train.txt",col.name="subject")
train<-cbind(traininglabel,trainingsubject,trainingset)

testset<-read.table("test/X_test.txt",col.name=feature$V2)
testlabel<-read.table("test/y_test.txt",col.name="labels")
testsubject<-read.table("test/subject_test.txt",col.name="subject")
test<-cbind(testlabel,testsubject,testset)

library(dplyr)
train<-mutate(train,datatype="train")
test<-mutate(test, datatype="test")

alldataset<-rbind(train,test)

#2
meansd<-select(alldataset, subject, labels, contains("mean"), contains("std"))

#3
label<-read.table("activity_labels.txt", header=FALSE)
meansd$labels<-factor(meansd$labels, levels=c(1, 2, 3, 4, 5, 6),
label=c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", 

"STANDING", "LAYING"))

#4
column<-colnames(meansd)
for(i in 1:length(column))
{
column[i]<-gsub("^t","time",column[i])
column[i]<-gsub("^f","frequency",column[i])
column[i]<-gsub("mean","Mean",column[i])
column[i]<-gsub(".std","STD",column[i])
column[i]<-gsub("BodyBody","Body",column[i])
}
colnames(meansd)<-column

#5
meandf<-aggregate(.~labels,data=meansd,mean)
write.table(meandf, './tidyData.txt',row.names=TRUE,sep='\t')
