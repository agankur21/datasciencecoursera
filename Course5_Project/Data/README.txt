The script consists of following functions along with their utilities:

1). getMergedData : This function gets a fully merged training and test dataset . This also includes the names of the features and activity associated with each observation.

2).getMergedDataWithMeanStd : Out of the 564 variables in the above output , this function selects only those columns which contains either "Mean" or "Std" 

3). For mining the label names and activity names , two functions processLabelText and processActivityName are created

4). The last part of the code consists of creating datasets, summarising them over Activity and Subject and finally writing them to an output file
