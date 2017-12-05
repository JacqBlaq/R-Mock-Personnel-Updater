#Validate when an error occurs
validate(
      need(!is.null(input$filter), "No column selected. Please make a Column Selection."),
      need(!(input$full_s == T && input$part_s ==T), "Cannot select both Part-time and Full-time together."),
      need(!(input$noEnd_s == T && input$yesEnd_s == T), "Connot select both 'No End Date' and 'Has End Date' together.")
)#validate

ET = vals$Data

if(input$full == T){
      ET <- ET[ET$FTE == 1,]
}
if(input$part == T){
      ET <- ET[ET$FTE != 1,]
}
if (input$role_ != "All"){
      ET <- ET[ET$Role == input$role_,]
}
if (input$employee != "All"){
      ET <- ET[ET$SalesforceName == input$employee,]
}
if (input$director != "All"){
      ET <- ET[ET$Director == input$director,]
}
if (input$team != "All"){
      ET <- ET[ET$Team == input$team,]
}
#-----------------------------------
#Filter Start and End dates
if (input$start_level_ == "Before"){
      ET <- filter(ET, ET$StartDate < input$searchDate_)
}
if (input$start_level_ == "After"){
      ET <- filter(ET, ET$StartDate > input$searchDate_)
}
if (input$end_level_ == "Before"){
      ET <- filter(ET, ET$EndDate < input$search_endDate)
      # ET <- ET[ET$startDate < input$searchDate,]
}
if (input$end_level_ == "After"){
      ET <- filter(ET, ET$EndDate > input$search_endDate_)
}
#-----------------------------------
#Filter to show all between radio buttons for Dates
if (input$start_level_ == "All"){
      ET <- ET
}
if (input$end_level_ == "All"){
      ET <- ET
}
#------------------------------------
#Filter Full-time and Part-time employees
if(input$full_s == T){
      ET <- ET[ET$FTE == 1,]
}
if(input$part_s == T){
      ET <- ET[ET$FTE != 1,]
}
#-----------------------------------
#Filter who has an End date and who doesnt
if(input$noEnd_s == T){
      ET <- ET[is.na(ET$EndDate)]
}
if(input$yesEnd_s == T){
      ET <- ET[!is.na(ET$EndDate)]
}
select(ET, one_of(input$filter))
