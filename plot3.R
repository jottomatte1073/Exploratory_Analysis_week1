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

power_p3 <- cbind(power_con, year, month, day)
power_p3 <- subset(power_p3, year == 107) %>% subset(month == 1) %>%
            subset(day == 1 | day == 2)
power_p3 <- select(power_p3, -c(year, month, day))
power_p3$date_time <- as.POSIXct(power_p3$date_time)

#Plot Energy sub metering

with(power_p3, plot(Sub_metering_1 ~ date_time, type = "l", xlab = "", ylab = "Energy sub metering"))
with(power_p3, lines(Sub_metering_2 ~ date_time, type = "l", col = "red"))
with(power_p3, lines(Sub_metering_3 ~ date_time, type = "l", col = "blue"))
legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
                   lty = c(1,1,1),
                   col=c("black","red","blue"))

dev.copy(png, file = "plot3.png")
dev.off()



