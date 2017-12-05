#Validate when an error occurs
validate(
      need(!is.null(input$check), "No column selected. Please make a Column Selection."),
      need(!(input$full_ == T && input$part_ ==T), "Cannot select both Part-time and Full-time together."),
      need(!(input$noEnd == T && input$yesEnd == T), "Connot select both 'No End Date' and 'Has End Date' together.")
)#validate

DFT = vals$Data
#-----------------------------------
#Filter Start and End dates
if (input$start_level == "Before"){
      DFT <- filter(DFT, StartDate < input$searchDate)
}
if (input$start_level == "After"){
      DFT <- filter(DFT, StartDate > input$searchDate)
}
if (input$end_level == "Before"){
      DFT <- filter(DFT, EndDate < input$search_endDate)
}
if (input$end_level == "After"){
      DFT <- filter(DFT, EndDate > input$search_endDate)
}

#-----------------------------------
#Filter to show all between radio buttons for Dates
if (input$start_level == "All"){
      DFT <- DFT
}
if (input$end_level == "All"){
      DFT <- DFT
}
# #-----------------------------------
#Filter Full-time and Part-time employees
if(input$full_ == T){
      DFT <- DFT[DFT$FTE == 1,]
}
if(input$part_ == T){
      DFT <- DFT[DFT$FTE != 1,]
}
# #-----------------------------------
# #Filter who has an End date and who doesnt
if(input$noEnd == T){
      DFT <- DFT[is.na(DFT$EndDate)]
}
if(input$yesEnd == T){
      DFT <- DFT[!is.na(DFT$EndDate)]
}

# #-----------------------------------
# #Filter by role, name, director, and team
if (input$role_filter != "All"){
      DFT <- DFT[DFT$Role == input$role_filter,]
}
if (input$employee_filter != "All"){
      DFT <- DFT[DFT$SalesforceName == input$employee_filter,]
}
if (input$director_filter != "All"){
      DFT <- DFT[DFT$Director == input$director_filter,]
}
if (input$team_filter != "All"){
      DFT <- DFT[DFT$Team == input$team_filter,]
}

filter_stuff <- select(DFT, one_of(input$check))