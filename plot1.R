#Load library

library(dplyr)

#Read household_power_consumption.txt

power_con <- read.table("~/household_power_consumption.txt", header = TRUE, stringsAsFactors = FALSE, sep = ";")

#Convert variables

power_con <- power_con %>% mutate(date_time = paste(Date, Time)) %>%
                           select(date_time, Global_active_power : Sub_metering_3)
power_con$date_time <- strptime(power_con$date_time, "%d/%m/%Y %H:%M:%S")
power_con$Global_active_power <- as.numeric(power_con$Global_active_power)
power_con$Global_reactive_power <- as.numeric(power_con$Global_reactive_power)
power_con$Voltage <- as.numeric(power_con$Voltage)
power_con$Global_intensity <- as.numeric(power_con$Global_intensity)
power_con$Sub_metering_1 <- as.numeric(power_con$Sub_metering_1)
power_con$Sub_metering_2 <- as.numeric(power_con$Sub_metering_2)

#Subset "2007-02-01 ~ 2007-02-02
year <- power_con$date_time$year
month <- power_con$date_time$mon
day <- power_con$date_time$mday

power_p1 <- cbind(power_con, year, month, day)
power_p1 <- subset(power_p1, year == 107) %>% subset(month == 1) %>%
             subset(day == 1 | day == 2)
power_p1 <- select(power_p1, -c(year, month, day))

#Plot Global Active Power histogram

with(power_p1, hist(Global_active_power, xlab = "Global Active Power(kilowatts)", ylab = "Frequency",
                                          main = "Global Active Power", col = "red"))

dev.copy(png, file = "plot1.png")
dev.off()
