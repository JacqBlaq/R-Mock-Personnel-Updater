tabsetPanel(
      type = "tabs",
      tabPanel("Mass Record Change",#---------------------- #Mass Record Change-----------------------------
               hr(),
               box(
                     width = 3,
                     status = "success",
                     selectInput("ColumnChoice", 
                                 "Pick a Column to Edit: ", 
                                 selected = NULL, 
                                 choices = names(vals$Data)
                     )#selectInput
               ),#box
               box(
                     width = 3,
                     status = "success",
                     uiOutput("selection") 
                     #file.edit(paste(beginning.path, "app.R", sep = ""))
                     #----Under: Record and Column Edits
               ),#box
               box(width = 3,
                   status = "success",
                   textInput(
                         "new_record_entry", 
                         "Enter Record Change: ")
               ),#box
               box(width = 3,
                   status = "success",
                   actionButton(
                         "recordSave", 
                         "Enter New Record", 
                         icon = icon("save"),
                         width = "100%")
               )#box
               
      ),#tabpanel
      tabPanel("Record Change with Condition", #-------------------Record Change with condition-------------------
               hr(),
               box(
                     width = 2,
                     status = "success",
                     selectInput("recordColChoice", 
                                 "Pick a Column to Edit: ", 
                                 selected = NULL, 
                                 choices = names(vals$Data))
               ),#box
               box(
                     width = 2,
                     status = "success",
                     uiOutput("selection2")
                     #file.edit(paste(beginning.path, "app.R", sep = ""))
                     #----Record Change with Condition
               ),#box
               box(
                     width = 2,
                     status = "success",
                     selectInput(
                           "recordCol", 
                           "Where Column equals: ", 
                           choices = names(vals$Data))
               ),#box
               box(
                     width = 2,
                     status = "success",
                     uiOutput("recordSelect")
                     #file.edit(paste(beginning.path, "app.R", sep = ""))
                     #----Record Change with Condition
               ),#box
               box(
                     width = 2,
                     status = "success",
                     textInput("new_record_entry_condition", 
                               "Enter Record Change: ")
               ),#box
               box(
                     width = 2,
                     status = "success",
                     actionButton(
                           "condtionSave", 
                           "Enter New Record", 
                           icon = icon("save"), 
                           width = "100%")
               )#box
      ),#tabpanel
      tabPanel("Add a Column", #--------------------Add a Column-----------------------------------
               hr(),
               box(
                     width = 3,
                     status = "success",
                     radioButtons(
                           "col_type", 
                           "Select Column Type: ", 
                           choices = c("Character", 
                                       "Integer", 
                                       "Numeric", 
                                       "Date"),
                           inline = T)
               ),#box
               box(
                     width = 2,
                     status = "success",
                     dateInput(
                           "date_column", 
                           "Select Date (Only if Date type): ")
               ),#box
               box(
                     width = 2,
                     status = "success",
                     textInput(
                           "new_col_name", 
                           "Enter new Column Name: ")
               ),#box
               box(
                     width = 2,
                     status = "success",
                     textInput(
                           "new_column_entry", 
                           "Enter new Column Entry:")
               ),#box
               box(
                     width = 2,
                     status = "success",
                     actionButton(
                           "columnSave", 
                           "Enter new column", 
                           icon = icon("save"), 
                           width = "100%")
               )#box 
      ),#tabPanel
      tabPanel("Add Column with Condition", #----------Add Column with Condition--------------------------
               hr(),
               box(
                     width = 2,
                     status = "success",
                     checkboxInput(
                           "condition", 
                           "Check to add new column with a condition")
               ),#box
               box(
                     width = 2,
                     status = "success",
                     selectInput(
                           "columnChoice_", 
                           "Where Column equals: ", 
                           selected = NULL, 
                           choices = names(vals$Data))
               ),#box
               box(
                     width = 2,
                     status = "success",
                     uiOutput("colSelection")
                     #file.edit(paste(beginning.path, "app.R", sep = ""))
                     #----Add Column with Condition
               )#box
               
               
      ),#tabPanel
      tabPanel("Delete a Column", #-----------Delete a Column---------------
               hr(),
               box(
                     width = 6,
                     status = "success",
                     checkboxGroupInput(
                           "delColumnChoice", 
                           "Check Column(s) to Delete: ", 
                           choices = names(vals$Data), 
                           selected = NULL, inline = T)
               ),#box
               box(
                     width = 2,
                     status = "success",
                     actionButton(
                           "delColumnSave", 
                           "Delete Columns", 
                           icon = icon("window-close"), 
                           width = "100%")  
               )#box
      )#tabPanel
)#tabsetPanel