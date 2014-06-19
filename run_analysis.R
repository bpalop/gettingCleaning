# Belen Palop - Getting and Cleaning Data Project
# June 2014


#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. Creates a second, independent tidy data set with the average of each variable for each 
#   activity and each subject. 

# Setting up the working directory for R. 
# Don't forget to unzip the dataset in this folder since reads are made with "./UCI HAR Dataset/*"

setwd("~/Documents/14-coursera/dataAnal/gettingCleaning/project")

#Prepare nicer names for variables from features' file 
features=read.csv("./UCI HAR Dataset/features.txt",header=F,sep=" ")
nombres=features$V2
#Change "-" for "_" in all feature names
nombres=lapply(nombres,function(x) gsub("-","_",x))

#Choose only mean and std measurements
#Mark all measurements ending with mean() or std(), assuming the only means and deviations we're looking for
#come from the last operation we've performed. We discard columns where Mean is part of the name.
nombres=lapply(nombres,function(x) gsub("mean()","MEAN",x,fixed=T))
nombres=lapply(nombres,function(x) gsub("std()","STD",x,fixed=T))

#Store the nicer names on the table 
features$V2=nombres

#Make a list of the columns of the variables we need from each experiment
chosen=grep("MEAN",nombres)
chosen=sort(c(chosen,grep("STD",nombres)))

#Make a table that links feature number and pretty name
library(data.table)
chosenFeatures=data.table(feature=features$V1[chosen])
chosenFeatures[,name:=features$V2[chosen]]

#Load test files and keep only the chosen variables
subject_test=read.csv("./UCI HAR Dataset/test/subject_test.txt",header=F)
X_test=read.csv("./UCI HAR Dataset/test/X_test.txt",header=F,sep="")[,chosen]
activity_test=read.csv("./UCI HAR Dataset/test/y_test.txt",header=F,sep="")

#Load train files and keep only the chosen variables
subject_train=read.csv("./UCI HAR Dataset/train/subject_train.txt",header=F)
X_train=read.csv("./UCI HAR Dataset/train/X_train.txt",header=F,sep="")[,chosen]
activity_train=read.csv("./UCI HAR Dataset/train/y_train.txt",header=F,sep="")

#Concat test and train for each variable in a single data frame
subject=rbind(subject_train,subject_test)
X=rbind(X_train,X_test)
activity=rbind(activity_train,activity_test)

#Give descriptive activity names to name the activities in the data set
actNames=read.csv("./UCI HAR Dataset/activity_labels.txt",header=F,sep="")
actNames=lapply(actNames,function(x) gsub("_","",x,fixed=T))
activity=merge(activity,actNames)$V2

#Make a data frame called "datos" with subject, activity and results
datos<-cbind(subject,activity,X)
#Give nice names to variables 
colnames(datos)=c("subject","activity",chosenFeatures$name)

#Make a data table from the data frame
datos=as.data.table(datos)

#Prepare the tidy dataset. 
#Start with a data table with the first aggregate by subject and activity, i.e., third column
tidy=datos[,mean(eval(as.name(names(datos)[3]))),by=list(subject,activity)]
setnames(tidy,"V1",names(datos)[3])
tidy=as.data.table(tidy)
#add one by one the rest of the columns
for(i in seq(4,length(names(datos)))){
  aux=datos[,mean(eval(as.name(names(datos)[i]))),by=list(subject,activity)]
  tidy[,eval(as.name(names(datos)[i])):=aux$V1]
}

write.csv(tidy,"./tidy.txt")

