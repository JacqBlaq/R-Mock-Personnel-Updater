#Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jdk-9.0.1')
library(shiny)
library(shinydashboard)
library(flexdashboard)
library(shinyjs)
library(shinythemes)
library(htmlwidgets)
library(rhandsontable)
library(DT)
library(readxl)
library(data.table)
library(plyr)
library(dplyr)
library(fun)
library(sudoku)
library(markdown)
library(lpSolve)
library(readxl)
library(dtplyr)
library(data.table)
library(timeDate)
library(lubridate)
library(xlsx)
library(readr)
library(rJava)


source('~/R/Personnel Project/global.R')

# -------------------------------------------------------------------------------------------
#Make sure to edit path to xlsx file
Tableau_Personnel <- read_excel("~/GitHub/Mock Personnel Project/Mock Personnel.xlsx")
tableauPersonnel <- Tableau_Personnel

#Data.frame for rHandsonTable
personnel_Table <- data.frame(
      SalesforceName = tableauPersonnel$SalesforceName, ClarityName = tableauPersonnel$ClarityName, StartDate = tableauPersonnel$StartDate,
      EndDate = tableauPersonnel$EndDate, FTE = tableauPersonnel$FTE, Role = tableauPersonnel$Role, Team = tableauPersonnel$Team,
      Director = tableauPersonnel$Director, VP = tableauPersonnel$VP,stringsAsFactors = FALSE)

#Data.table to edit
tableauPersonnel <- data.table(tableauPersonnel)
tableauPersonnel$StartDate <- as.Date(tableauPersonnel$StartDate, format = "%Y/%m/%d")
tableauPersonnel$EndDate <- as.Date(tableauPersonnel$EndDate, format = "%Y/%m/%d")
tableauPersonnel$FTE <- as.numeric(tableauPersonnel$FTE)

vals = reactiveValues()
vals$Data = data.table(tableauPersonnel)

#-------------------------------------------------------------------------------------------
ui <- shinyUI(
      dashboardPage( 
            dashboardHeader(title = "Mock Personnel Updater",
                            titleWidth = 260),
            dashboardSidebar( width = 260,
                              sidebarMenuOutput("Semi_collapsible_sidebar")
            ),#dashboardSidebar
      
#------------------------------------------------------------------------------------------------        
            dashboardBody(
                  #Custom CSS for the header and side bar
                  tags$head(tags$style(
                        HTML('
                              .skin-blue .main-header .logo {
                              font-family: "Bradley Hand ITC";
                              background-color: #997a1e;
                              font-weight: bold;
                              font-size: 20px;
                              text-align:left;
                              }
                              .content-wrapper,
                               .right-side {
                               background-color: #E7E7E7 ;
                               }
                              .skin-blue .main-header .navbar {
                              background-color: #997a1e;
                              }
                              .skin-blue .main-header .logo:hover {
                              background-color: #878399;
                              }
                              .skin-blue .main-sidebar {
                              background-color: #000000;
                              color: #ffffff;
                              }
                              .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                              background-color: #645D7C;
                              }
                              .skin-blue .main-sidebar .sidebar .sidebar-menu a:hover{
                              background-color: #67979F;
                              }
                    
                          ')#HTML
                        )#tag$style
                  ),#tag$head
                  
                  #-----------------------------------------------------------
                  #Expander Tab!
                  tabItems(
                        tabItem(
                              tabName = "expander",
                              fluidRow(
                                    box(
                                          width = 12,
                                          status = "primary",
                                          color = "black",
                                          solidHeader = T,
                                          
                                          fluidRow(
                                                box( # Expander options
                                                      title = "Expander Options",
                                                      width = 2,
                                                      solidHeader = T,
                                                      status = "success",
                                                      collapsible = T,
                                                      
                                                      checkboxGroupInput("ExOptions", "Select Expander View:",
                                                                         c("Show All", "By Name"),
                                                                           selected = "Show All"),
                                                      selectInput("searchName", "Select Name:", choices = c(tableauPersonnel$ClarityName), selected = "All"),
                                                      textInput("ex_download", "Download As: ", value = "Untitled"),
                                                      HTML('<div class="btn-group" aria-label="Basic example">'),
                                                      actionButton("display", "Display"),
                                                      actionButton("selected", "Run Expander"),
                                                      downloadButton("downloadAs", "Download"),
                                                      HTML('</div>'),
                                                      hr(),
                                                      checkboxGroupInput("checked", "Filter by column: ", choices = 
                                                                               c("ClarityName","Months", "busDays", "actualDays",
                                                                                              "fte", "Role",
                                                                                              "Team", "Director", "VP"), 
                                                                         selected = c("ClarityName", "Months", "busDays", "actualDays",
                                                                                      "fte",  "Role",
                                                                                      "Team", "Director", "VP"))
                                                ),#box
                                                
                                                box( # expander View
                                                      title = "Monthly Personnel Expander View",
                                                      width = 10,
                                                      solidHeader = T,
                                                      status = "warning",
                                                      collapsible = T,
                                                      fluidRow(
                                                            box(
                                                                  width = 2,
                                                                  solidHeader = T,
                                                                  status = "info",
                                                                  selectInput("expand_director", label = "Filter by Director: ", choices = c("All", 
                                                                        unique(as.character(tableauPersonnel$Director))), selected = NULL, multiple = FALSE)
                                                            ),#box
                                                            box(
                                                                  width = 2,
                                                                  solidHeader = T,
                                                                  status = "warning",
                                                                  selectInput("expand_team", label = "Filter by Team: ", choices = c("All", 
                                                                        unique(as.character(tableauPersonnel$Team))), selected = NULL, multiple = FALSE)
                                                            ),#box
                                                            box(
                                                                  width = 2,
                                                                  solidHeader = T,
                                                                  status = "danger",
                                                                  selectInput("expand_role", "Search by Role: ", choices = c("All", 
                                                                        unique(as.character(tableauPersonnel$Role))), selected = NULL, multiple = FALSE)
                                                            ),#box
                                                            box(
                                                                  width = 2,
                                                                  solidHeader = T,
                                                                  status = "primary",
                                                                  checkboxInput("expand_full", "Full-Time", value = F),
                                                                  checkboxInput("expand_part", "Part-Time", value = F)
                                                            ),#box
                                                            box(
                                                                  width = 2,
                                                                  solidHeader = T,
                                                                  status = "success",
                                                                  radioButtons("before_", "Before this Date:", c("Before", "All"), selected = "All", inline = T),
                                                                  dateInput("beforeDate", label = NULL, value = NULL, format = "yyyy-mm-dd")
                                                                  
                                                            ),#box
                                                            box(
                                                                  width = 2,
                                                                  solidHeader = T,
                                                                  status = "success",
                                                                  radioButtons("after_", "After this Date:", c("After", "All"), selected = "All", inline = T),
                                                                  dateInput("afterDate", label = NULL, value = NULL, format = "yyyy-mm-dd")
                                                            )#box  
                                                      ),#fluidRow
                                                      DT::dataTableOutput("ex_table")
                                                )#box
                                          )#fluid Row
                                    )#box
                              )#fluidRow
                        ),#tabItem
                  #----------------------------------------------------------------------------------------
                  #Download files tab
                        tabItem(
                              tabName = "files",
                              fluidRow(
                                    infoBox(
                                          title = "",
                                          value = "CSV!",
                                          subtitle = "Download CSV Files.",
                                          icon = shiny::icon("file-excel-o"),
                                          color = "purple",
                                          width = 4,
                                          href = NULL, 
                                          fill = FALSE
                                    ),#infoBox
                                    infoBox(
                                          title = "",
                                          value = "TSV!",
                                          subtitle = "Download PDF Files.",
                                          icon = shiny::icon("file-code-o"),
                                          color = "red",
                                          width = 4,
                                          href = NULL, 
                                          fill = FALSE
                                    ),#infoBox
                                    infoBox(
                                          title = "",
                                          value = "EXCEL!",
                                          subtitle = "Download Excel Files.",
                                          icon = shiny::icon("file-excel-o"),
                                          color = "green",
                                          width = 4,
                                          href = NULL, 
                                          fill = FALSE
                                    )#infoBox
                              ),#fluidRow
                              fluidRow(
                                    box(
                                          status = "info",
                                          solidHeader = T,
                                          width = 2,
                                          height = 900,
                                          checkboxGroupInput("check", "Filter by column: ", choices = 
                                                                  c(unique(as.character(names(tableauPersonnel)))), 
                                                                  selected = names(tableauPersonnel)),
                                          hr(),
                                          radioButtons("start_level", "Filter by Start Date", choices = c("Before", "After", "All"),
                                                       selected = "All"),
                                          dateInput("searchDate", label = NULL, value = NULL, format = "yyyy-mm-dd"),
                                          hr(),
                                          radioButtons("end_level", "Filter by End Date", choices = c("Before", "After", "All"),
                                                       selected = "All"),
                                          dateInput("search_endDate", label = NULL, value = NULL, format = "yyyy-mm-dd"),
                                          hr(),
                                          radioButtons("filetype", "File type:",
                                                       choices = c("csv", "tsv")),
                                          textInput("fileName", "Download file name as:"),
                                          downloadButton("downloadData", "Download")
                                          
                                    ),#box
                                    box(
                                         status = "primary",
                                         width = 10,
                                         height = 900,
                                         collapsible = TRUE,
                                         uiOutput("download_page"),
                                         DT::dataTableOutput("downloadables"),
                                         hr()
                                    )#box
                              )#fluidRow
                        ),#tabItem
                        
                        #---------------------------------------------------------------
                        #Dashboard Tab
                        tabItem(
                              tabName = "dashboard",
                              fluidRow(
                                    infoBox(title = "Hey there!", 
                                            value = "Welcome!", 
                                            subtitle = "Here, you can easily access the Action Line employee List.",
                                            icon = shiny::icon("handshake-o"), 
                                            color = "aqua", 
                                            width = 4,
                                            href = NULL, 
                                            fill = FALSE
                                    ),#info Box
                                    infoBox(title = "Hey there!", 
                                            value = "Edits!", 
                                            subtitle = "Edit Former Employee data.",
                                            icon = shiny::icon("edit"), 
                                            color = "red", 
                                            width = 4,
                                            href = NULL, 
                                            fill = FALSE
                                    ),#info Box
                                    infoBox(title = "Hey there!", 
                                            value = "New Friends!", 
                                            subtitle = "Add new employees",
                                            icon = shiny::icon("smile-o"), 
                                            color = "green", 
                                            width = 4,
                                            href = NULL, 
                                            fill = FALSE
                                    )#info Box
                              ),#fluidRow
                              fluidRow(
                                    box(
                                          width = 12,
                                          status = "primary",
                                          callapsible = TRUE, 
                                          uiOutput("dashboard_record")
                                    )#box  
                              ),#fluidRow
                              fluidRow(
                                    box(
                                         width = 12,
                                         status = "primary",
                                         callapsible = TRUE, 
                                         uiOutput("dashBoard")
                                    )#box
                              )#fluidRow2
                        ),#tabItem
                        
                        #------------------------------------------------------------------
                        #Search Personnel Tab
                        tabItem(
                            tabName = "personnel",
                            uiOutput("search"),
                            fluidRow(
                                  box(
                                        status="success",
                                        width = 2,
                                        solidHeader = T,
                                        height = 800,
                                        color = "black",
                                        collapsible = TRUE,
                                        checkboxGroupInput("filter", "Filter by column: ", choices = 
                                                      c(unique(as.character(names(tableauPersonnel)))), 
                                                      selected = names(tableauPersonnel)),
                                        hr(),
                                        checkboxInput("full", "Full-Time", value = F),
                                        checkboxInput("part", "Part-Time", value = F),
                                       hr(), 
                                       radioButtons("start_level_", "Filter by Start Date", choices = c("Before", "After", "All"),
                                                    selected = "All"),
                                       dateInput("searchDate_", label = NULL, value = NULL, format = "yyyy-mm-dd"),
                                       hr(),
                                       radioButtons("end_level_", "Filter by End Date", choices = c("Before", "After", "All"),
                                                    selected = "All"),
                                       dateInput("search_endDate_", label = NULL, value = NULL, format = "yyyy-mm-dd")
                                  ),#box
                                  box(
                                        title = "Tableau Personnel",
                                        status="primary",
                                        width = 10,
                                        height = 800,
                                        color = "black",
                                        collapsible = TRUE,
                                        DT::dataTableOutput("table_filter"),
                                        hr()
                                  )#box
                            )#fluidRow
                        )#tabitem1
                  )#tabItems
            )#dashboardBody
      )#dashboardPage
)#shinyUI

#---------------------------------------------------------------------------------------------------------------------------------------

server <- shinyServer(function(input,output,session){

      #----------------------------------------------------------------   
      table_ <-  tableauPersonnel #table for everything in server to reference from

      #Expander Options
      #----------------------------------------------------------------
      #collapse side bar
 
      output$Semi_collapsible_sidebar=renderMenu({
            sidebarMenu(
                  hr(),
                  menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                  menuItem("Search Personnel", tabName = "personnel", icon = icon("id-badge")),
                  menuItem("Download Files", tabName = "files", icon = icon("group")),
                  menuSubItem("Monthly Expander", tabName = "expander", icon = icon("expand")),
                  hr()
            )#sidebarMenu
      })
      #----------------------------------------------------------------
      
      observeEvent(input$expand_expander,{
            
            personnel_List <- vals$Data
            personnel_List$StartDate[is.na(personnel_List$StartDate)] <- '2015-01-01'
            personnel_List$EndDate[is.na(personnel_List$EndDate)] <- '2017-12-31'
            personnel_List$StartDate <- as.Date(personnel_List$StartDate, "%Y-%m-%d")
            personnel_List$EndDate <- as.Date(personnel_List$EndDate, "%Y-%m-%d")
            personnel_List$FTE <- as.numeric(personnel_List$FTE)
            personnel_List <- data.table(personnel_List)
            
            table_1 <- setDT(personnel_List)[, list(Months = seq.Date(as.Date(timeFirstDayInMonth(StartDate, format = "%Y-%m-%d")), 
                                                                      as.Date(timeLastDayInMonth(EndDate, format = "%Y-%m-%d")), by = "month")), 
                                             by = list(ClarityName, StartDate, EndDate, Role, Team, Director, VP)]
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
            
            table_1 = table_1[, fte := round(actualDays/busDays, digits = 2)]
            
            #Create final table with extracted columns
            if (input$expand_expander >= 1){
                  final_table <- select(table_1, ClarityName, Months, busDays, actualDays, fte, Role, Team, Director, VP)
                  final_table <- data.table(final_table)
                  
                  write.csv(
                        final_table,
                        "~/R/Personnel Project/Personnel Expander_new.csv", row.names = F
                  )#csv
                  showModal(
                        modalDialog(title = "Notification", 
                                    "Personnel Expander has been saved.", 
                                    easyClose = T))
            }#if
            
      })#observe Event
      
#----------------------------------------------------------------
      
     observeEvent(input$selected,{
           
           personnel_List <- vals$Data
           personnel_List$StartDate[is.na(personnel_List$StartDate)] <- '2015-01-01'
           personnel_List$EndDate[is.na(personnel_List$EndDate)] <- '2017-12-31'
           personnel_List$StartDate <- as.Date(personnel_List$StartDate, "%Y-%m-%d")
           personnel_List$EndDate <- as.Date(personnel_List$EndDate, "%Y-%m-%d")
           personnel_List$FTE <- as.numeric(personnel_List$FTE)
           personnel_List <- data.table(personnel_List)
           
           table_1 <- setDT(personnel_List)[, list(Months = seq.Date(as.Date(timeFirstDayInMonth(StartDate, format = "%Y-%m-%d")), 
                                                                     as.Date(timeLastDayInMonth(EndDate, format = "%Y-%m-%d")), by = "month")), 
                                            by = list(ClarityName, StartDate, EndDate, Role, Team, Director, VP)]
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
           
           table_1 = table_1[, fte := round(actualDays/busDays, digits = 2)]
           
           if(input$selected >= 1){
                 final_table <- select(table_1, ClarityName, Months, busDays, actualDays, fte, Role, Team, Director, VP)
                 final_table <- data.table(final_table)
           }
           
           table1 <- final_table
         #-------------------------------------
           observeEvent(input$display,{
                 
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
                 
                 #-----------------------------------
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
                 # #-----------------------------------
                 # #Filter Full-time and Part-time employees
                 if(input$expand_full == T){
                       table1 <- table1[table1$fte == 1,]
                 }
                 if(input$expand_part == T){
                       table1 <- table1[table1$fte != 1,]
                 }
                 # #-----------------------------------
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
                 
                 output$ex_table <- DT::renderDataTable(DT::datatable(
                       class = "cell-border stripe", filter = "top",{
                             expander_table
                       }))#ex_table
                 
                 
                 output$downloadAs <- downloadHandler(
                       filename = function(){
                             paste(input$ex_download, "csv", sep = ".")
                       },#function
                       content = function(file) {
                             write.csv( expander_table, file, row.names = FALSE)
                       }#file
                 )#download Handler
           })#observe
     })#observe Event

#----------------------------------------------------------------- 
      #Downloadable table filter options  
      datasetInput <- reactive({
            
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
            #Filter Full-time and Part-time employees
            if(input$full_ == T){
                  DFT <- DFT[DFT$FTE == 1,]
            }
            if(input$part_ == T){
                  DFT <- DFT[DFT$FTE != 1,]
            }
            #-----------------------------------
            #Filter who has an End date and who doesnt
            if(input$noEnd == T){
                  DFT <- DFT[is.na(DFT$EndDate)]
            }
            if(input$yesEnd == T){
                  DFT <- DFT[!is.na(DFT$EndDate)]
            }
            #-----------------------------------
            #Filter to show all between radio buttons for Dates
            if (input$start_level == "All"){
                  DFT <- DFT
            }
            if (input$end_level == "All"){
                  DFT <- DFT
            }
            #-----------------------------------
            #Filter by role, name, director, and team
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
      })#datasetInput
      
     
#---------------------------------------------------------  
#download handler to specify file times 
      output$downloadables <- renderDataTable(class = "cell-border stripe", filter = "top",{
            datasetInput()
      })#renderDataTable
      
      output$downloadData <- downloadHandler(
            filename = function(){
                  paste(input$fileName, input$filetype, sep = ".")
            },#function
            content = function(file) {
                  sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
                  
                  write.table(datasetInput(), file, sep = sep,
                              row.names = FALSE)
                  
            }#file
      )#download Handler
      
#-----------------------------------------------------------
#Filtered Table for viewing not download
#Search Personnel
      output$table_filter <- DT::renderDataTable(DT::datatable(
            class = "cell-border stripe", filter = "top",{
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
                 select(ET, input$filter)
                  
            },#table
            options =
                  list(searching = T,paging = TRUE,
                       language = list(
                             zeroRecords = "No records to display")
            )#list
            )#datatable
      )#DT
     
      #---------------------------------------------------------------
      # Word cloud ( From 'https://shiny.rstudio.com/gallery/word-cloud.html')
      terms <- reactive({
            # Change when the "update" button is pressed...
            input$update
            # ...but not for anything else
            isolate({
                  withProgress({
                        setProgress(message = "Processing corpus...")
                        getTermMatrix(input$selection)
                  })#withProgress
            })#isolate
      })#reactive
      # Make the wordcloud drawing predictable during a session
      wordcloud_rep <- repeatable(wordcloud)
      
      output$plot <- renderPlot({
            v <- terms()
            wordcloud_rep(names(v), v, scale=c(4,0.5),
                          min.freq = input$freq, max.words=input$max,
                          colors=brewer.pal(8, "Dark2"))
            
      })#render plot
      
      #-----------------------------------------------------------------------------------  
      #Sudoku puzzle (Google search/Was not created by me)
      solver <- function(puzzle){
            puzzle <- as.vector(t(as.matrix(puzzle))) #expands puzzle into a vector by row
            
            I <- c(rep(0,9^3),0)
            
            for(j in 1:9){
                  for(i in 1:81){
                        I[i+(j-1)*81] <- ifelse(puzzle[i]==j,1,0) #expands puzzle into a length 729 indicator vector
                  }#for
            }#for
            I_0 <- sum(I) #normalization constant needed later
            y <- c(rep(1,27*9+81),I_0)
            L1 <- c(rep(1,9^3),0)
            A <- matrix(0,27*9,9^3+1) #to become the matrix of constraints
            block_id <- matrix(0,9,81)
            
            ##Row constraints
            for(i in 1:9){
                  block_id[i,(9*(i-1)+1):(9*(i-1)+9)] <- rep(1,9)
            }#for
            
            ##column constraints
            block_dot <- matrix(0,9,81)
            
            for(i in 0:8){ #must dot at 1,10,11,etc for column 1
                  indices <- c(1+i,10+i,19+i,28+i,37+i,46+i,55+i,64+i,73+i) #indices for column i
                  block_dot[i+1,indices] <- rep(1,9)
            }#for
            ##end column constraints
            
            ##BOX constraints
            box_dot <- matrix(0,9,81)
            
            for(i in 0:2){
                  box_dot[i+1,(3*i+1):(3*i+3)] <- rep(1,3)
                  box_dot[i+1,(9+3*i+1):(9+3*i+3)] <- rep(1,3)
                  box_dot[i+1,(18+3*i+1):(18+3*i+3)] <- rep(1,3)
            }#for
            
            for(i in 0:2){
                  box_dot[i+4,(27+3*i+1):(27+3*i+3)] <- rep(1,3)
                  box_dot[i+4,(36+3*i+1):(36+3*i+3)] <- rep(1,3)
                  box_dot[i+4,(45+3*i+1):(45+3*i+3)] <- rep(1,3)
            }#for
            
            for(i in 0:2){
                  box_dot[i+7,(54+3*i+1):(54+3*i+3)] <- rep(1,3)
                  box_dot[i+7,(63+3*i+1):(63+3*i+3)] <- rep(1,3)
                  box_dot[i+7,(72+3*i+1):(72+3*i+3)] <- rep(1,3)
            }#for
            
            ##require that every cell be filled
            cell_dot <- rep(0,81*9+1)
            for(j in 0:8){
                  cell_dot[1+81*j] <- 1
            }#for
            cell_mat <- cell_dot
            for(i in 2:81){
                  cell_mat <- rbind(cell_mat,(c(rep(0,i-1),cell_dot[1:(81*9+1-i)],0)))
            }#for
            bigblock<-rbind(block_id,block_dot,box_dot)
            for(i in 0:8){
                  A[(27*i+1):(27+27*i),(81*i+1):(81*i+81)] <- bigblock
            }#for
            
            A <- rbind(A,cell_mat,I)
            
            ##add constraint that the solution must agree with the initial puzzle
            sim_sud <- lp(direction="min",objective.in=L1,const.mat=A,const.dir="==",const.rhs=y,all.int=TRUE)
            ##lp_solve package uses revised simplex method for standard linear programs, and branch and bound for integrality requirements
            z<-sim_sud$solution #the solution as an indicator vector
            ##reconstruction of the solution as a standard puzzle
            solved <- matrix(0,9,9)
            
            for(i in 0:8){ #reconstruction of each number's indicator matrix
                  indic <- z[(81*i+1):(81*i+81)]
                  for(j in 1:81){
                        indic[j] <- ifelse(indic[j]!=0,(i+1),0)
                  }#for
                  indic <- matrix(indic,nrow=9,ncol=9,byrow=TRUE)
                  solved <- solved+indic
            }#for
            
            return(solved)
      }#Function Puzzle
      
      plotSudoku <- function(sol, set, sud) {  
            plot(0:10, 0:10, type="n", axes=F, xlab="Column", ylab="Row")
            
            for (row in 1:9) for (col in 1:9) {
                  backcol = grey(.95)
                  number = sol[row, col]
                  if (sud[row, col] != 0) {
                        backcol = grey(.85) # given
                        number = sud[row, col]
                  } else if (set[row, col] != 0) { # a guess
                        if (sol[row, col] == 0) {
                              grey(.65) # no solution yet
                              number = set[row, col]
                        } else if (sol[row, col] == set[row, col]) {
                              backcol = rgb(0, 1, 0) # correct guess - green
                        } else {
                              backcol = rgb(1, 0, 0) # wrong guess - red
                        }
                  } else if (sol[row, col] != 0) {
                        backcol = rgb(1, 1, 0) # not guessed - yellow
                  }
                  polygon(c(col-.5, col-.5, col+.5, col+.5), 
                          c((10-row)-.5, (10-row)+.5, (10-row)+.5, (10-row)-.5), col=backcol)
                  if (number > 0) text(col, 10-row, number, offset=0)
            }#for
            
            # Add row and column numbers
            for (i in 1:9) {
                  text(.25, 10-i, i, offset=0)    
                  text(9.75, 10-i, i, offset=0)
                  text(i, .1, i, offset=0)        
                  text(i, 9.9, i, offset=0)
            }#for
            
            # Plot thick lines
            for (i in seq(.5,9.5,3)) {
                  lines(c(.5, 9.5), c(i, i), lwd=3)
                  lines(c(i, i), c(.5, 9.5), lwd=3)
            }  #for
      }#Function PlotSudoku
      
      # Use shared variables and side-effects, because the dependency graph is messy
      setMatrix <- matrix(0, nrow=9, ncol=9)
      solutionMatrix <- matrix(0, nrow=9, ncol=9)
      sudokuMatrix <- matrix(0, nrow=9, ncol=9)
      
      set <- reactive({
            input$setButton
            isolate({
                  setMatrix[as.integer(input$row), as.integer(input$col)] <<- as.integer(input$value)
            })#isolate
      })#reactive
      
      restart <- reactive({
            input$newButton
            isolate({
                  sudokuMatrix <<- generateSudoku(input$blanks)
            })#isolate
            solutionMatrix <<- matrix(0, nrow=9, ncol=9) 
            setMatrix <<- matrix(0, nrow=9, ncol=9) 
      })#reactive
      
      solve <- reactive({
            input$solveButton
            if (input$solveButton != 0) {
                  solutionMatrix <<- solver(sudokuMatrix) 
            }#if
      })#reactive
      output$sudoku <- renderPlot({
            # Replot after each action
            set()
            restart()
            solve()
            plotSudoku(solutionMatrix, setMatrix, sudokuMatrix)     
      })#renderPlot 

      #----------------------------------------------------------------
      # Data edit table
      data_edit <- reactive({
            ET = vals$Data
            ET[["Select"]] <- paste0('<input name="row_selected" type="checkbox" value="Row', 1:nrow(vals$Data),'">')
            ET[["Actions"]] <- paste0('
                                      <div class="btn-group" role="group" aria-label="Basic example">
                                      <button class="btn btn-secondary delete" id="delete_',1:nrow(vals$Data),'" type = "button">Delete</button>
                                      </div>
                                      ')
            
            #-----------------------------------
            #Filter Full-time and Part-time employees
            if(input$full_ex == T){
                  ET <- ET[ET$FTE == 1,]
            }
            if(input$part_ex == T){
                  ET <- ET[ET$FTE != 1,]
            }
            
            #-----------------------------------
            #Filter who has an End date and who doesnt
            if(input$noEndex == T){
                  ET <- ET[is.na(ET$EndDate)]
            }
            if(input$yesEndex == T){
                  ET <- ET[!is.na(ET$EndDate)]
            }#if
            
            #select(ET)
            tab_edit <- datatable(ET, escape = F, filter = "top",
                                  options = list(class = 'cell-border stripe',
                                    lengthMenu = c(5, 10, 15,  20), pageLength = 5))
            
      })#reactive
      #-----------------------
      observeEvent(input$expand_save,{
            write.csv(vals$Data, "C:/Users/jgboyor/Documents/R/Personal Project/Personnel Expander.csv", 
                       row.names = F)
      })#observe
      
      output$Main_table_ <- renderDataTable({
                  data_edit()
      })#output
      #-----------------------
      output$Main_table <- renderDataTable({
            data_edit()
      })#ex_table
 
      #-----------------------
      observeEvent(
            input$Add_row_head,{
                  if(input$end.date == T){
                        end_date = input$endD
                  }#if
                  else{
                        end_date = as.Date(NA)
                  }#else
                  
                  new_row = data.frame(
                        SalesforceName = input$name_e,
                        ClarityName = input$name_e,
                        StartDate =  input$startD,
                        EndDate = end_date,
                        FTE = input$fte_e,
                        Role = input$role_e,
                        Team = input$team_e,
                        Director = input$dir_e,
                        VP = input$vp_e
                  )#data.frame
                  
                  new_row$StartDate <- as.Date(new_row$StartDate)
                  new_row$EndDate <- as.Date(new_row$EndDate)
                  vals$Data = rbind(vals$Data, new_row, fill = T)
                  showModal(modalDialog(title = "Notification", "New Employee information has been added!", easyClose = T))
            })#event
      
      #--------------------------------------
      #Save edits made to data table
      observeEvent(input$save_edit,{
            if (input$full_ex == T || input$part_ex == T || input$noEndex == T || input$yesEndex == T){
                  showModal(
                        modalDialog(title = "Notification", 
                                    "Cannot save changes while filters are checked.", 
                                    easyClose = T))
            }else {
                  write.xlsx(vals$Data, "C:/Users/jgboyor/Documents/R/Personnel Project/Tableau Personnel.xlsx", 
                             row.names = F, sheetName = "Personnel", showNA = F)
                  showModal(modalDialog(title = "Notification", "Changes have been saved!", easyClose = T))
            }#else
      })#save_edit
      

      output$download_personnel <- downloadHandler(
            filename = function(){
                  paste(input$personnelName, "csv", sep = ".")
            },#function
            content = function(file) {
                  write.csv(vals$Data, file, row.names = FALSE)
            }#file
      )#download Handler
      
      #--------------------------------------
      observeEvent(input$Del_row_head,{ 
            row_to_del=as.numeric(gsub("Row","",input$checked_rows)) 
            
            vals$Data=vals$Data[-row_to_del]
            showModal(modalDialog(title = "Notification", "Row(s) have been deleted.", easyClose = T))
      })#observe
      
      #---------------------------------------
      observeEvent(input$lastClick,{ 
            if (input$lastClickId%like%"delete"){ 
                  row_to_del=as.numeric(gsub("delete_","",input$lastClickId)) 
                  vals$Data=vals$Data[-row_to_del] 
            } 
            else if (input$lastClickId%like%"modify"){ 
                  showModal(modal_modify) 
            } 
      })#observe
     
      #---------------------------------------
      observeEvent(input$newValue, { 
            newValue=lapply(input$newValue, function(col) { 
                  if (suppressWarnings(all(!is.na(as.numeric(as.character(col)))))) { 
                        as.numeric(as.character(col))
                  } else { 
                        col 
                  }#else 
            })#observeEvent 
            DF=data.frame(lapply(newValue, function(x) t(data.frame(x)))) 
            colnames(DF)=colnames(vals$Data) 
            vals$Data[as.numeric(gsub("modify_","",input$lastClickId))]<-DF 
      }#newValue 
      )#observe 
      
      #-------------------------------------
      #Text on dashboard
      output$hello <- renderUI({
            welcome <- paste0("<h4><u><b><i>Friendly Rules</i></b></u></h4> ")
            sen1 <- paste0("1. You cannot save changes while filters are checked. <br>")
            sen2 <- paste0("2. Only Run Expander after changes have been saved. <br>")
            sen3 <- paste0("3. Only Save expander after running expander. <br>")
            sen4 <- paste0("4. Make sure 'Has End Date' is checked when adding an end date for a new employee information.")
            HTML(paste(welcome, sen1, sen2, sen3, sen4))
      })#render Hello

      #--------------------
      searchResults <- reactive({
            ET <- vals$Data
            select(distinct(ET, input$ColumnChoice))


      })#reactive
      #-----------------------------------------------------------
      #Columns to edit UI
      column_edits <- reactive({
            ET <- vals$Data
                   selectInput("recordChoice", "Where Record Equals: ", choices = (select(vals$Data, one_of(input$ColumnChoice))))
          
      })#reactive
       
      output$selection <- renderUI({
            column_edits()
      })#render UI
      
      #----------------------------------------------
      #condition for record change
      record_edits <- reactive({
            selectInput("recordCondition", "Where Record Equals: ", choices = (select(vals$Data, one_of(input$recordCol))))
      })#reactive
      
      output$recordSelect <- renderUI({
            record_edits()
      })#recordSelect
      #-----------------------------------------
      #Columns to edit UI
      recordCol_edits <- reactive({
            ET <- vals$Data
            selectInput("recordColChoice", "Where Record Equals: ", choices = (select(vals$Data, one_of(input$recordColChoice))))
            
      })#reactive
      
      output$selection2 <- renderUI({
            recordCol_edits()
      })#render UI
      #------------------------------------------
      #Text on Record change
      output$rulesRecord <- renderUI({
            sen1 <- paste0("1. Must refresh page to see changes. <br>")
            sen2 <- paste0("2. Must check 'Change record based on a condition' . <br>")
            sen3 <- paste0("3. Only Save expander after running expander. <br>")
            sen4 <- paste0("4. Make sure 'Has End Date' is checked when adding an end date for a new employee information.")
            HTML(paste(sen1, sen2, sen3, sen4))
      })#render Hello
      #---------------------
      #Columns to edit UI with column Add
      
      column_edits_ <- reactive({
            ET <- vals$Data
                  selectInput("recordChoice_", "Where Record Equals: ", choices = (select(vals$Data, one_of(input$columnChoice_))))
            
      })#reactive
      output$colSelection <- renderUI({
            column_edits_()
      })#render UI
      
      # #--------------------
      #Update a Record Entry
      new.Entry <- reactive({
            vals$Data = vals$Data[get(input$ColumnChoice)== input$recordChoice, input$ColumnChoice := input$new_record_entry]
      })#reactive
  
      # save new record edit
      observeEvent(
            input$recordSave,{
                  new.Entry()
      })#observe column edit]
      #----------------------
      #Record change with condition
   
      new.Entry.Condition <- reactive({
            vals$Data = vals$Data[get(input$recordColChoice)== input$recordColChoice, get(input$recordCol) == input$recordCondition, input$recordCol := input$new_record_entry]
      })#reactive
      
      observeEvent(input$conditionSave,{
            new.Entry.Condition()
      })
      #----------------------
      #new column data types
      new.Col <- reactive({
            ET <- vals$Data
            
            if (input$condition == T){
                  if(input$col_type == "Character"){
                        vals$Data = vals$Data[get(input$columnChoice_) == input$recordChoice_, input$new_col_name := as.character(input$new_column_entry)]
                  }else
                  if(input$col_type == "Integer"){
                        vals$Data = vals$Data[get(input$columnChoice_) == input$recordChoice_, input$new_col_name := as.integer(input$new_column_entry)]
                  }else
                  if(input$col_type == "Numeric"){
                        vals$Data = vals$Data[get(input$columnChoice_) == input$recordChoice_, input$new_col_name := as.numeric(input$new_column_entry)]
                  }else
                  if(input$col_type == "Date"){
                        vals$Data = vals$Data[get(input$columnChoice_) == input$recordChoice_, input$new_col_name := as.Date(input$date_column, format = "%Y/%m/%d")]
                  }
            }else{
                  if(input$col_type == "Character"){
                        vals$Data <<- vals$Data[, input$new_col_name := as.character(input$new_column_entry)]
                  }else
                  if(input$col_type == "Integer"){
                        vals$Data = vals$Data[, input$new_col_name := as.integer(input$new_column_entry)]
                  }else
                  if(input$col_type == "Numeric"){
                        vals$Data = vals$Data[, input$new_col_name := as.numeric(input$new_column_entry)]
                  }else
                  if(input$col_type == "Date"){
                        vals$Data = vals$Data[, input$new_col_name := as.Date(input$date_column, format = "%Y/%m/%d")]
                  }   
            }#else
      })#reactive
      
      observeEvent(input$columnSave,{
            new.Col()
      })
      #------------------------------
      del.Col <- reactive({
            vals$Data[,input$delColumnChoice := NULL]
      })#reactive
     
    observeEvent(input$delColumnSave,{
          del.Col()
      })#observe
      
      #---------------------------------------------------------------------------------------------------------------------
      #Add column/Edit Rows (Part of Dashboard)
      output$dashboard_record <- renderUI({
           tabsetPanel(
                 type = "tabs",
                 tabPanel("Mass Record Change",#---------------------- #Mass Record Change-----------------------------
                          hr(),
                          box(width = 3,
                              status = "success",
                                selectInput("ColumnChoice", "Pick a Column to Edit: ", selected = NULL, choices = names(vals$Data))
                          ),#box
                          box(width = 3,
                              status = "success",
                                uiOutput("selection")
                          ),
                          box(width = 3,
                              status = "success",
                                textInput("new_record_entry", "Enter Record Change: ")
                          ),
                          box(width = 3,
                              status = "success",
                             actionButton("recordSave", "Enter New Record", icon = icon("save"), width = "100%")
                          )
                 ),#tabpanel
                 tabPanel("Record Change with Condition", #-------------------Record Change with condition-------------------
                          hr(),
                          box(width = 2,
                              status = "success",
                                selectInput("recordColChoice", "Pick a Column to Edit: ", selected = NULL, choices = names(vals$Data))
                          ),#box
                          box(width = 2,
                              status = "success",
                               uiOutput("selection2")
                          ),#box
                          box(width = 2,
                              status = "success",
                              selectInput("recordCol", "Where Column equals: ", choices = names(vals$Data))
                          ),#box
                          box(width = 2,
                              status = "success",
                               uiOutput("recordSelect")
                          ),#box
                          box(width = 2,
                              status = "success",
                              textInput("new_record_entry_condition", "Enter Record Change: ")
                          ),#box
                          box(width = 2,
                              status = "success",
                              actionButton("condtionSave", "Enter New Record", icon = icon("save"), width = "100%")
                          )#box
                 ),#tabpanel
                 tabPanel("Add a Column", #--------------------Add a Column-----------------------------------
                          hr(),
                          box(width = 3,
                              status = "success",
                              radioButtons("col_type", "Select Column Type: ", choices = c("Character", "Integer", "Numeric", "Date"),
                                       inline = T)
                          ),#box
                          box(width = 2,
                              status = "success",
                              dateInput("date_column", "Select Date (Only if Date type): ")
                          ),#box
                          box(width = 2,
                              status = "success",
                              textInput("new_col_name", "Enter new Column Name: ")
                          ),#box
                          box(width = 2,
                              status = "success",
                              textInput("new_column_entry", "Enter new Column Entry:")
                          ),#box
                          box(width = 2,
                              status = "success",
                              actionButton("columnSave", "Enter new column", icon = icon("save"), width = "100%")
                          )#box 
                 ),#tabPanel
                 tabPanel("Add Column with Condition", #----------Add Column with Condition--------------------------
                          hr(),
                          box(width = 2,
                              status = "success",
                              checkboxInput("condition", "Check to add new column with a condition")
                          ),#box
                          box(width = 2,
                              status = "success",
                               selectInput("columnChoice_", "Where Column equals: ", selected = NULL, choices = names(vals$Data))
                          ),#box
                          box(width = 2,
                              status = "success",
                              uiOutput("colSelection")
                          )#box
                 ),#tabPanel
                 tabPanel("Delete a Column", #-----------Delete a Column---------------
                          hr(),
                          box(width = 6,
                              status = "success",
                              checkboxGroupInput("delColumnChoice", "Check Column(s) to Delete: ", choices = names(vals$Data), selected = NULL, inline = T)
                          ),#box
                          box(width = 2,
                              status = "success",
                              actionButton("delColumnSave", "Delete Columns", icon = icon("window-close"), width = "100%")  
                          )#box
                 )#tabPanel
           )#tabsetPanel
      })#renderUI
      
      #-----------------------------------
      #Dashboard
      output$dashBoard <- renderUI({
            tabsetPanel(
                  type = "tabs",
                  tabPanel("Add/Delete New Employee",
                           #red, yellow, aqua, blue, light-blue, green, navy, teal, olive, lime, orange, fuchsia, purple, maroon, black.
                           br(),
                           box( solidHeader = T,
                                 width = 2,
                                status = "success",
                                 textInput("name_e", "Name:"),
                                 textInput("role_e", "Role:"),
                                 textInput("team_e", "Team:"),
                                 textInput("dir_e", "Director:"),
                                 textInput("vp_e", "VP: ", value = "Harry Potter"),
                                dateInput("startD", "Start Date:", value = NULL, format = "yyyy-mm-dd"),
                                checkboxInput("end.date", "Has End Date", value = F),
                                dateInput("endD", "End Date:", value =  as.Date(NA), format = "yyyy-mm-dd"),
                                numericInput("fte_e", "FTE:", value = 1),
                                actionButton(inputId = "Add_row_head",label = "Add new Employee"),
                                hr()
                           ),#box
                           box(
                               width = 10,
                               
                               column(
                                     width = 12,
                                     offset = 0,
                                     tabsetPanel(
                                         tabPanel("Rules",
                                                  box(
                                                        width = 4,
                                                        solidHeader = T,
                                                        uiOutput("hello")
                                                  ),#box
                                                  box(solidHeader = T,
                                                      width = 2,
                                                      status = "primary",
                                                      checkboxInput("full_ex", "Full-Time", value = F),
                                                      checkboxInput("part_ex", "Part-Time", value = F),
                                                      hr()
                                                  ),#box
                                                  box(solidHeader = T,
                                                      width = 2,
                                                      status = "success",
                                                      checkboxInput("noEndex", "No End Date", value = F),
                                                      checkboxInput("yesEndex", "Has End Date", value = F),
                                                      hr()
                                                  ),#box
                                                  box(solidHeader = T,
                                                      width = 4,
                                                      status = "warning",
                                                      textInput("personnelName", "Download As:", value = "Untitled"),
                                                      HTML('<div class="btn-group" role="group" aria-label="Basic example">'),
                                                      downloadButton("download_personnel", "Download"),
                                                      actionButton(inputId = "save_edit", label = "Save Changes", icon = icon("save")),
                                                      actionButton(inputId = "expand_expander", label = "Save Expander"),
                                                      HTML('</div>')
                                                  )#box
                                         )#tabPanel
                                     )#tabsetPanel
                               ),#column
                               dataTableOutput("Main_table_"),
                               HTML('<div class="btn-group" role="group" aria-label="Basic example">'),
                               actionButton(inputId = "Del_row_head",label = "Delete selected rows"),
                               HTML('</div>'),
                               
                               tags$script(HTML('$(document).on("click", "input", function () { 
                                       var checkboxes = document.getElementsByName("row_selected"); 
                                       var checkboxesChecked = []; 
                                       for (var i=0; i<checkboxes.length; i++) { 
                                       
                                       if (checkboxes[i].checked) { 
                                       checkboxesChecked.push(checkboxes[i].value); 
                                       } 
                                       } 
                                       Shiny.onInputChange("checked_rows",checkboxesChecked); 
                                    })')), 
                               tags$script("$(document).on('click', '#Main_table_ button', function () { 
                                          Shiny.onInputChange('lastClickId',this.id); 
                                          Shiny.onInputChange('lastClick', Math.random())
                                          });")
                              
                           )#box 
                  ),#tabPanel
                  tabPanel("Sudoku", # Display Soduku Puzzle -------------------------
                           box(solidHeader = T,
                               width = 2,
                               collapsible = TRUE,
                               hr(),
                               sliderInput("blanks", label = "Number of Blanks",
                                           min = 9, max = 81, value = 40),
                               actionButton("newButton", "New Puzzle"),
                               hr(), 
                               h4('Solve Automatically:'),
                               actionButton("solveButton", "Solve"),
                               hr(),
                               h4('Solve Manually:'),
                               p('Use the row/column dropdowns to input your guesses:'),
                               selectInput("row", label = "Row", 
                                           choices = list(1,2,3,4,5,6,7,8,9), 
                                           selected = 5),
                               selectInput("col", label = "Column", 
                                           choices = list(1,2,3,4,5,6,7,8,9), 
                                           selected = 5),     
                               selectInput("value", label = "Value", 
                                           choices = list(1,2,3,4,5,6,7,8,9," "=0), 
                                           selected = 0),
                               actionButton("setButton", "Set"),
                               hr()
                           ),#box
                           box(
                                 solidHeader = T,
                                 width = 5,
                                 plotOutput("sudoku", width = "100%", height = "652px"),
                                 hr()
                           ),#box
                           box(
                                 solidHeader = T,
                                 width = 5,
                                 selectInput("selection", "Choose a book:",
                                             choices = books),
                                 actionButton("update", "Change"),
                                 sliderInput("freq",
                                             "Minimum Frequency:",
                                             min = 1,  max = 50, value = 20),
                                 sliderInput("max",
                                             "Maximum Number of Words:",
                                             min = 1,  max = 300,  value = 125),
                                 
                                 hr(),
                                 plotOutput("plot", width = "100%")
                           )#box
                  )#tabPanel
            )#tabsetPanel
      })#render    
   #-------------------------------------------------
      #Search
      output$search <- renderUI({
            ET <- vals$Data
            fluidRow(
                  box(
                        width = 12,
                        status = "warning",
                        solidHeader = T,
                        box(
                              status="primary",
                              width = 2,
                              color = "black",
                              collapsible = TRUE,
                              selectInput("employee", label = "Search by Name: ", choices = c("All", 
                                    unique(as.character(ET[,SalesforceName]))), selected = NULL, multiple = FALSE),
                              hr()
                        ),#box
                        box(
                              status="success",
                              width = 2,
                              color = "black",
                              collapsible = TRUE,
                              selectInput("director", label = "Search by Director: ", choices = c("All", 
                                     unique(as.character(ET[,Director]))), selected = NULL, multiple = FALSE),
                              hr()
                        ),#box
                        box(
                              status="danger",
                              width = 2,
                              color = "black",
                              collapsible = TRUE,
                              selectInput("team", label = "Search by Team: ", choices = c("All", 
                                     unique(as.character(ET[,Team]))), selected = NULL, multiple = FALSE),
                              hr() 
                        ),#box
                        box(
                              status="warning",
                              width = 2,
                              color = "black",
                              collapsible = TRUE,
                              selectInput("role_", "Search by Role: ", choices = c("All", 
                                     unique(as.character(ET[,Role]))), selected = NULL, multiple = FALSE),
                              hr() 
                        ),#box
                        box(
                              width = 2,
                              status = "primary",
                              checkboxInput("full_s", "Full-Time", value = F),
                              checkboxInput("part_s", "Part-Time", value = F),
                              hr()
                        ),#box
                        box(
                              width = 2,
                              status = "success",
                              checkboxInput("noEnd_s", "No End Date", value = F),
                              checkboxInput("yesEnd_s", "Has End Date", value = F),
                              hr()
                        )#box
                  )#box
            )# fluidRow
      })#render
      #-----------------------------------------------
      output$download_page <- renderUI({
            ET <- vals$Data
            fluidRow(
                  box(
                        width = 2,
                        solidHeader = T,
                        status = "success",
                        selectInput("employee_filter", label = "Filter by Name: ", choices = c("All", 
                                 unique(as.character(ET[,SalesforceName]))), 
                                    selected = "All", multiple = F)
                  ),#box
                  box(
                        width = 2,
                        solidHeader = T,
                        status = "info",
                        selectInput("director_filter", label = "Filter by Director: ", choices = c("All", 
                                 unique(as.character(ET[,Director]))), selected = NULL, multiple = FALSE)
                  ),#box
                  box(
                        width = 2,
                        solidHeader = T,
                        status = "warning",
                        selectInput("team_filter", label = "Filter by Team: ", choices = c("All", 
                                unique(as.character(ET[,Team]))), selected = NULL, multiple = FALSE)
                  ),#box
                  box(
                        width = 2,
                        solidHeader = T,
                        status = "danger",
                        selectInput("role_filter", "Search by Role: ", choices = c("All", 
                                unique(as.character(ET[,Role]))), selected = NULL, multiple = FALSE)
                  ),#box
                  box(
                        width = 2,
                        solidHeader = T,
                        status = "primary",
                        checkboxInput("full_", "Full-Time", value = F),
                        checkboxInput("part_", "Part-Time", value = F)
                  ),#box
                  box(
                        width = 2,
                        solidHeader = T,
                        status = "success",
                        checkboxInput("noEnd", "No End Date", value = F),
                        checkboxInput("yesEnd", "Has End Date", value = F)
                  )#box
            )#fluidRow
      })#render
})#End server

shinyApp(ui = ui, server = server)