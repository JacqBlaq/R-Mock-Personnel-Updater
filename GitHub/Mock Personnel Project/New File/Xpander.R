personnel_List <- vals$Data
personnel_List$StartDate[is.na(personnel_List$StartDate)] <- '2015-01-01'
personnel_List$EndDate[is.na(personnel_List$EndDate)] <- '2017-12-31'
personnel_List$StartDate <- as.Date(personnel_List$StartDate, "%Y-%m-%d")
personnel_List$EndDate <- as.Date(personnel_List$EndDate, "%Y-%m-%d")
personnel_List$FTE <- as.numeric(personnel_List$FTE)
personnel_List <- data.table(personnel_List)

table_1 <- setDT(personnel_List)[, list(Months = seq.Date(as.Date(timeFirstDayInMonth(StartDate, format = "%Y-%m-%d")),
                                                          as.Date(timeLastDayInMonth(EndDate, format = "%Y-%m-%d")), by = "month")),
                                 by = list(ClarityName, StartDate, EndDate, Role, Team, Director, VP, FTE)]
table_1 <- data.table(table_1)

#Count of Business Days-----------------------------------------
#Add to table
table_1 = table_1[, busDays := sum(!weekdays(seq(as.Date(timeFirstDayInMonth(Months, format = "%Y-%m-%d")),
                                                 as.Date(timeLastDayInMonth(Months, format = "%Y-%m-%d")),
                                                 "days")) %in% c("Saturday", "Sunday")), Months]
table_1 = table_1[, startDate_busDays := sum(!weekdays(seq(as.Date(StartDate),
                                                           as.Date(timeLastDayInMonth(StartDate, format = "%Y-%m-%d")),
                                                           "days")) %in% c("Saturday", "Sunday")), StartDate]
table_1 = table_1[, EndDate_busDays := sum(!weekdays(seq(as.Date(EndDate),
                                                         as.Date(timeLastDayInMonth(EndDate, format = "%Y-%m-%d")),
                                                         "days")) %in% c("Saturday", "Sunday")), EndDate]
table_1 = table_1[, endBegin_End := sum(!weekdays(seq(as.Date(timeFirstDayInMonth(EndDate)),
                                                      as.Date(EndDate),
                                                      "days")) %in% c("Saturday", "Sunday")), EndDate]

firstMonths <- format(as.Date(table_1$Months), "%Y-%m")
actStart <- format(as.Date(table_1$StartDate), "%Y-%m")
actualEnd <- format(as.Date(table_1$EndDate), "%Y-%m")


table_1 = table_1[, actualDays :=
                        ifelse(actStart == actualEnd, (startDate_busDays - EndDate_busDays + 1),
                               ifelse(actualEnd == firstMonths, endBegin_End,
                                      ifelse(actStart == firstMonths, startDate_busDays, busDays
                                      )))]
#

table_1 = table_1[, fte := round((actualDays / busDays) * FTE, digits = 2)]