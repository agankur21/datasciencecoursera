myData = read.table("household_power_consumption.txt",header = T,sep = ';')
head(myData)
date1 <- as.Date("2007-02-01",format = "%Y-%m-%d")
date2 <- as.Date("2007-02-02",format = "%Y-%m-%d")
myData <- transform(myData,Date = as.Date(Date,format = "%d/%m/%Y"))
relevantData <- myData[myData$Date==date1 | myData$Date==date2,]
hist(as.numeric(as.character(relevantData$Global_active_power)),main = 'Global Active Power',col = 'red',xlab = 'Global Active Power(kilowatts)')
dev.copy(png,file = 'plot1.png',width = 480,height = 480,units = 'px')
dev.off()