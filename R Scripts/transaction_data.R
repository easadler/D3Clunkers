setwd("/Users/evansadler/Desktop/Edmonds")

data <- read.table("CARS_PAID_Final.txt", sep=",", fill= T, na.strings = c("", " "), quote="\"", header=TRUE)






# frequency by state
require(plyr)
states <- count(data$state)
names(states)[names(states) == "x"] <- "state"
states <-states[-nrow(states),]
states <- states[states$freq > 500,]
row.names(states) <- NULL

write.csv(states, file = "./public/state_freq.csv", row.names=FALSE)

# PER CAPITA
library(RCurl)
states_url = getURL("https://www.census.gov/popest/data/state/totals/2014/tables/NST-EST2014-01.csv")
states_pop = read.csv(textConnection(states_url), skip = 3, header = TRUE)

states_pop <- states_pop[6:56, names(states_pop) %in% c('X','X2014')]
row.names(states_pop) <- NULL
names(states_pop)[names(states_pop) == "X"] <- "state"
states_pop <- states_pop[!(states_pop$state %in% c('.District of Columbia')),]

states_pop$X2014 <- gsub("[^[:digit:]]", replacement = "", states_pop$X2014)
states_pop$X2014 <- as.numeric(states_pop$X2014)

fraction <- states$freq/states_pop$X2014
percapita <- data.frame(states$state, fraction)
colnames(percapita) <- c('state', 'freq')
write.csv(percapita, file = "./public/state_percapita.csv", row.names=FALSE)

# Gallons saved per year
data.clean <- data[which(data$new_vehicle_car_mileage > 0 | data$trade_in_mileage > 0),]
data.clean$galsaved <- (13476/data.clean$trade_in_mileage - 13476/data.clean$new_vehicle_car_mileage)
count(data.clean$galsaved) # some NaN, NA, Inf!
data.clean <- data[!(data$galsaved %in% c(NA, -Inf, NaN, Inf)),]



states_gs <- ddply(data.clean, c("state"), summarize, totgs = sum(galsaved, na.rm = TRUE))
colnames(states_gs) <- c('state', 'freq')

states_gs <- states_gs[states_gs$freq > 121402,]


write.csv(states_gs, file = "./public/state_gsaved.csv", row.names=FALSE)

# Gallons saved per year per car

fraction <- states_gs$freq/states$freq
percapita_gs <- data.frame(states_gs$state, fraction)
colnames(percapita_gs) <- c('state', 'freq')
write.csv(percapita_gs, file = "./public/state_percapita_gs.csv", row.names=FALSE)

#### Summary States
sum(states_gs$freq)




