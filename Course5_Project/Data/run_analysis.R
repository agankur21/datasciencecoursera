
getMergedData <- function(folderPath){
        setwd(folderPath)
        #Get Primarity Tables 
        featuresKey = read.table(file = "features.txt",sep = " ",col.names =  c("featureNumber","featureType"),colClasses = c("numeric","character"))
        activityKey = read.table(file = "activity_labels.txt",sep = " ",col.names = c("activityNumber","activityType"),colClasses = c("numeric","character"))
        #Processing Feature Names
        featuresKey$featureType <- sapply(X = featuresKey$featureType,processLabelText,USE.NAMES = F)
        #Processing  Names
        activityKey$activityType <- sapply(X = activityKey$activityType,processActivityName,USE.NAMES = F)
        #Merging Training Dataset
        train_features = read.table("train//X_train.txt",col.names = (featuresKey$featureType),colClasses = rep("numeric",nrow(featuresKey)))
        train_activity = read.table("train//y_train.txt",col.names= c("ActivityCode"),colClasses = c("numeric"))
        train_subject = read.table("train//subject_train.txt",col.names= c("SubjectCode"),colClasses = c("numeric"))
        trainData_merged = cbind(train_features,train_activity,train_subject)
        #Merging Test Dataset
        test_features = read.table("test//X_test.txt",col.names = (featuresKey$featureType),colClasses = rep("numeric",nrow(featuresKey)))
        test_activity = read.table("test//y_test.txt",col.names = c("ActivityCode"),colClasses = c("numeric"))
        test_subject = read.table("test//subject_test.txt",col.names = c("SubjectCode"),colClasses = c("numeric"))
        testData_merged = cbind(test_features,test_activity,test_subject)
        #Merging training and test Data
        mergedDataset <- rbind(trainData_merged,testData_merged)
        #Merge with Activity Data
        mergedDataset <- merge(x = mergedDataset,y = activityKey,by.x = "ActivityCode",by.y = "activityNumber",all = F)
}

getMergedDataWithMeanStd <- function(mergedDataset){
        #Getting only columns with mean and std in their name
        columnNames = names(mergedDataset)
        featureNamesMean <- columnNames[grep(pattern = "Mean",x = columnNames)]
        featureNamesStd <- columnNames[grep(pattern = "Std",x = columnNames)]
        variableFeatures <- c(featureNamesMean,featureNamesStd)
        mergedDatasetwithMean_Std <- mergedDataset[,c(variableFeatures,"activityType","SubjectCode")]
        mergedDatasetwithMean_Std
}


processLabelText <- function(initialLabel){
        editedLabel = gsub(pattern = "[,-]",'.',sub(pattern = "\\()-",".",x = initialLabel))
        editedLabel = sub(pattern = "\\()","",x = editedLabel)
        if(substring(editedLabel,1,1)== 'f'){
             editedLabel <- paste("Frequency.",substring(editedLabel,2),sep = "")
        }
        else if(substring(editedLabel,1,1)== 't'){
                editedLabel <- paste("Time.",substring(editedLabel,2),sep = "")
                }
        editedLabel = gsub(pattern = "mean","Mean",editedLabel)
        editedLabel = gsub(pattern = "std","Std",editedLabel)
        editedLabel
}

processActivityName <- function(activity){
        editedText = sub(pattern = "\\_"," ",x = activity)
        
}

mergeData1 <- getMergedData(getwd())
mergeData2 <- getMergedDataWithMeanStd(mergeData1)
summarisedData <- aggregate(x = mergeData2[,1:86],by = list(SubjectCode = mergeData2$SubjectCode,ActivityType = mergeData2$activityType),FUN = mean,simplify = T)
write.table(summarisedData, "SummaryOutput.txt", sep="\t",row.names = F)

