#Validate when an error occurs
validate(
      need(!is.null(input$checked), "No column selected. Please make a Column Selection."),
      need(!is.null(input$ExOptions), "No column Selected")
)#validate

if(input$ExOptions == "Show All"){
      table1
}#show all
if(input$ExOptions == "By Name"){
      table1 <- table1[table1$Clarityname == input$searchName,]
}#if by name

#+++++++++++++++++++++++++++++
#Filter Start and End dates
if (input$before_ == "Before"){
      table1 <- filter(table1, table1$Months < input$beforeDate)
}
if (input$before_ == "All"){
      table1 <-table1
}
if (input$after_ == "After"){
      table1 <- filter(table1, table1$Months > input$afterDate)
}
if (input$after_ == "All"){
      table1 <-table1
}
#+++++++++++++++++++++++++++++
# #Filter Full-time and Part-time employee
if(input$expand_full == T){
      table1 <- table1[table1$fte == 1,]
}
if(input$expand_part == T){
      table1 <- table1[table1$fte != 1,]
}
# +++++++++++++++++++++++++++++
# #Filter by role, name, director, and team
if (input$expand_role != "All"){
      table1 <- table1[table1$Role == input$expand_role,]
}
if (input$expand_director != "All"){
      table1 <- filter( table1,  table1$Director == input$expand_director)
}
if (input$expand_team != "All"){
      table1 <- table1[table1$Team == input$expand_team,]
}
expander_table <- select(table1, one_of(input$checked)) 

#----Display Datatable of filtered Expander-----------
output$ex_table <- DT::renderDataTable(DT::datatable(
      class = "cell-border stripe", filter = "top",{
            expander_table
      }))#ex_table

#Download Expander------------
output$downloadAs <- downloadHandler(
      filename = function(){
            paste(input$ex_download, "csv", sep = ".")
      },#function
      content = function(file) {
            write.csv( expander_table, file, row.names = FALSE)
      }#file
)#download Handler