setwd("/Users/evansadler/Desktop/Edmonds")
data.survey <- read.csv("survey.csv", na.strings = c("", " "))

require(plyr)
cartime <- count(data.survey$TIME)
cartime <- cartime[cartype$x != 'NA',]
cartime$percentage = cartime$freq / sum(cartime$freq)

barplot(cartime$percentage, names.arg = cartime$x)

sd(cartime$freq[cartime$freq != 0])
cartime$gallons <- cartime$percentage*200432654*cartime$x
sum(cartime$gallons)
