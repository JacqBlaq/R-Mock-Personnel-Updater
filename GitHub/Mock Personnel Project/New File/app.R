#-Calling different source files--------------------------------------------------------------
beginning.path <- 'C:/Users/jgboyor/Documents/GitHub/Mock Personnel Project/New File/'

#Source file that contains required packages
source(
      paste(
            beginning.path, 
            'packages.R', 
            sep = '' 
            )#paste
      )#source

#Global File that contains function for word cloud
source(
      paste(
            beginning.path, 
            'global.R', 
            sep = ''
            )#paste
      )#source

#Where Master Personnel File is Imported
source(
      paste(
            beginning.path, 
            'Import_Master_Personnel_List.R', 
            sep = '')#paste
      )#source 


#-Reactive Table Values--------------------
vals = reactiveValues()
vals$Data = data.table(tableauPersonnel)

#-------Start of UI-----------------------------------------------------------------------------------------------------
ui <- shinyUI(
      dashboardPage( 
            dashboardHeader(
                  title = "Action Line",
                  titleWidth = 200),
            dashboardSidebar( 
                  width = 200,
                  sidebarMenuOutput("Semi_collapsible_sidebar")
            ),#dashboardSidebar
            #-----DashboardBody-------------------------------------------------------------------   
            dashboardBody(
                  source(
                        paste(
                              beginning.path, 
                              'HTML.R', 
                              sep = ''), 
                        local = T)$value,
                  #------------Tab Items----------------------------------------------------------
                  tabItems(
                        #----Expander Tab!-------
                        tabItem(
                              tabName = "expander",
                              source(
                                    paste(
                                          monthlyExpander.tab, 
                                          'Expander_Tab.R', 
                                          sep = ''), 
                                    local = T)$value
                        ),#tabItem
                        #------Download files tab-------------------------------------------------
                        tabItem(
                              tabName = "files",
                              source(
                                    paste(
                                          downloadFiles.tab, 
                                          'Download_Files_Tab.R', 
                                          sep = ''), 
                                    local = T)$value
                        ),#tabItem
                        #-------Dashboard Tab-----------------------------------------------------
                        tabItem(
                              tabName = "dashboard",
                              source(
                                    paste(
                                          dashboard.tab, 
                                          'Dashboard_Tab.R', 
                                          sep = ''), 
                                    local = T)$value
                        ),#tabItem
                        #--------Search Personnel Tab----------------------------------------------
                        tabItem(
                              tabName = "personnel",
                              uiOutput("search"),
                              source(
                                    paste(
                                          searchPerssonel.tab, 
                                          'Search_Personnel_Tab.R', 
                                          sep = ''), 
                                    local = T)$value
                        )#tabitem
                  )#tabItems
            )#dashboardBody
      )#dashboardPage
)#shinyUI

#---- Start of Server-----------------------------------------------------------------------------------------------------------------------------------
server <- shinyServer(function(input,output,session){
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #----RHandsOnTable UI---------------
      source(
            paste(
                  dashboard.tab, 
                  'RHandsOnTable_UI.R', 
                  sep = ''), 
            local = T)$value
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #----RHandsOnTable Edit and Save-------------------------------
      source(
            paste(
                  dashboard.tab, 
                  'RHandsOnTable_Edit_Save.R', 
                  sep = ''), 
            local = T)$value
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #---Sidebar UI-------------------------------------------------------------
      source(
            paste(
                  beginning.path, 
                  'SidebarMenu_UI.R', 
                  sep = ''), 
            local = T)$value
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #----Run and Save Expander---------------------------------------------------------------
      observeEvent(input$expand_expander,{
            source(
                  paste(
                        beginning.path, 
                        'Xpander.R', 
                        sep = ''), 
                  local = T)$value
            
            #Display final table with extracted columns
            if (input$expand_expander >= 1){
                  final_table <- select(table_1, 
                                        ClarityName, 
                                        Months, 
                                        busDays, 
                                        actualDays, 
                                        fte, 
                                        Role, 
                                        Team, 
                                        Director, 
                                        VP)#end select
                  final_table <- data.table(final_table)
                  
                  write.csv(
                        final_table,
                        paste(
                              beginning.path, 
                              'Personnel Expander.csv', 
                              sep = ''), 
                        row.names = F
                        )#csv
                  
                  showModal(
                        modalDialog(
                              title = "Notification", 
                                    "Personnel Expander has been saved.", 
                                    easyClose = T)
                        )#showModal
            }#if
      })#observe Event
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #---Display/Download Expander from Monthly Expander Tab-------------------------------
      #Filter by Column, Name, etc
      observeEvent(
            input$selected,{
                  source(
                        paste(
                              beginning.path, 
                              'Xpander.R', 
                              sep = ''), 
                        local = T)$value
                  
                  if(input$selected >= 1){
                        final_table <- select(table_1, 
                                              ClarityName, 
                                              Months, busDays, 
                                              actualDays, 
                                              fte, 
                                              Role, 
                                              Team, 
                                              Director, 
                                              VP)
                        final_table <- data.table(final_table)
                  }#end if
                  
                  table1 <- final_table
                  
                  #Source File to Display/Download expander
                  observeEvent(
                        input$display,{
                              source(
                                    paste(
                                          monthlyExpander.tab, 
                                          'Xpander_Display_Filter_Download.R', 
                                          sep = ''), 
                                    local = T)$value
                        })#observe
            })#observe Event
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #Downloadable table filter options  
      datasetInput <- reactive({
            source(
                  paste(
                        downloadFiles.tab, 
                        'Download_Files_Tab_Datatable_Filters.R', 
                        sep = ''), 
                  local = T)$value
      })#datasetInput
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #download handler to specify file times 
      output$downloadables <- renderDataTable(
            class = "cell-border stripe", 
            filter = "top",{
                  datasetInput()
                  })#renderDataTable
      
      output$downloadData <- downloadHandler(
            filename = function(){
                  paste(
                        input$fileName, 
                        input$filetype, 
                        sep = ".")
            },#function
            content = function(file){
                  sep <- switch(input$filetype, 
                                "csv" = ",", 
                                "tsv" = "\t")
                  
                  write.table(
                        datasetInput(), 
                        file, sep = sep,
                        row.names = FALSE)
            }#content
      )#download Handler
      
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #----Search Personnel Filters-------
      #Search Personnel
      output$table_filter <- DT::renderDataTable(DT::datatable(
            class = "cell-border stripe", 
            filter = "top",{
                  source(
                        paste(
                              searchPerssonel.tab, 
                              'Search_Personnel_Tab_Datatable_Filters.R', 
                              sep = ''), 
                        local = T)$value
            },#table
            options =
                  list(searching = T,
                       paging = TRUE,
                       language = list(
                             zeroRecords = "No records to display")
                  )#list
      )#datatable
      )#DT
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #------Word cloud----------------------
      source(
            paste(
                  beginning.path, 
                  'WordCloud.R', 
                  sep = ''), 
            local = T)$value
      
      #------Sudoku puzzle-------------------
      source(
            paste(
                  beginning.path, 
                  'Soduku.R', 
                  sep = ''), 
            local = T)$value
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #---Dashboard Datatable Display/Filter---------
      data_edit <- reactive({
            source(
                  paste(
                        dashboard.tab, 
                        'Dashboard_Tab_Datatable_Filters.R', 
                        sep = ''), 
                  local = T)$value
      })#reactive
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #---Output Datatable Display on Dashboard-----
      output$Main_table_ <- renderDataTable({
            data_edit()
      })#renderDatatable
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #---Add a New Employee on Dashboard Tab-------
      observeEvent(
            input$Add_row_head,{
                  source(
                        paste(
                              dashboard.tab, 
                              'Dashboard_Tab_Datatable_Add_Employee.R', 
                              sep = ''), 
                        local = T)$value
            })#event
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #---Save Edits Made to Dashboard datatable--------
      #--If filters are checked when save is clicked, file will not save.
      observeEvent(
            input$save_edit,{
                  if (input$full_ex == T || input$part_ex == T || input$noEndex == T || input$yesEndex == T){
                        showModal(
                              modalDialog(title = "Notification", 
                                          "Cannot save changes while filters are checked.", 
                                          easyClose = T))
                  }else {
                        write.xlsx(
                              vals$Data, 
                              paste(
                                    beginning.path, 
                                    "Tableau Personnel.xlsx", 
                                    sep = ""), 
                              row.names = F, 
                              sheetName = "Personnel", 
                              showNA = F
                              )#write.xlsx
                        showModal(
                              modalDialog(
                                    title = "Notification", 
                                    "Changes have been saved!", 
                                    easyClose = T)
                              )#showModal
                  }#else
            })#save_edit
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #----Dashboard Tab Download Datatable------------
      output$download_personnel <- downloadHandler(
            filename = function(){
                  paste(
                        input$personnelName, 
                        "csv", 
                        sep = ".")
            },#function
            content = function(file) {
                  write.csv(
                        vals$Data, 
                        file, 
                        row.names = FALSE)
            }#file
      )#download Handler
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #----Delete Selected Rows from Dashboard Datatable----
      observeEvent(
            input$Del_row_head,{ 
                  row_to_del=as.numeric(gsub("Row",
                                             "",
                                             input$checked_rows)
                                        )#as.numeric 
                  vals$Data=vals$Data[-row_to_del]
                  showModal(
                        modalDialog(
                              title = "Notification", 
                              "Row(s) have been deleted.", 
                              easyClose = T)
                        )#showModal
            })#observe
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #----Get selected rows to delete----
      observeEvent(
            input$lastClick,{ 
                  if (input$lastClickId%like%"delete"){ 
                        row_to_del=as.numeric(gsub("delete_",
                                                   "",
                                                   input$lastClickId)
                                              )#as.numeric
                        vals$Data=vals$Data[-row_to_del] 
                  } 
                  else if (input$lastClickId%like%"modify"){ 
                        showModal(modal_modify) 
                  } 
            })#observe
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      observeEvent(
            input$newValue, { 
                  newValue=lapply(input$newValue, 
                                  function(col) { 
                                        if (suppressWarnings(all(!is.na(as.numeric(as.character(col)))))) { 
                                              as.numeric(as.character(col))
                                        } else { 
                                              col 
                                        }#else 
                                  })#observeEvent 
                  DF=data.frame(lapply(newValue, function(x) t(data.frame(x)))) 
                  colnames(DF)=colnames(vals$Data) 
                  vals$Data[as.numeric(gsub("modify_",
                                            "",
                                            input$lastClickId))]<-DF 
            }#newValue 
      )#observe 
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #---Rules Displayed on Dashboard-----
      output$hello <- renderUI({
            welcome <- paste0("<h4><u><b><i>Friendly Rules</i></b></u></h4> ")
            sen1 <- paste0("1. You cannot save changes while filters are checked. <br>")
            sen2 <- paste0("2. Only Run Expander after changes have been saved. <br>")
            sen3 <- paste0("3. Only Save expander after running expander. <br>")
            sen4 <- paste0("4. Make sure 'Has End Date' is checked when adding an end date for a new employee information.")
            HTML(paste(welcome, sen1, sen2, sen3, sen4))
      })#render Hello
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #----Record and Column Edits----
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #----Mass Record Change----
      #----Select Column to Edit
      searchResults <- reactive({
            ET <- vals$Data
            select(distinct(ET, input$ColumnChoice))
      })#reactive
      
      #----Get Records from selected Column to Edit
      column_edits <- reactive({
            ET <- vals$Data
            selectInput(
                  "recordChoice", 
                  "Where Record Equals: ", 
                  choices = (select(vals$Data, 
                                    one_of(input$ColumnChoice))))
      })#reactive
      
      #-----Display Records from selected Column to Edit
      output$selection <- renderUI({
            column_edits()
      })#render UI
      
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #----Record Change with Condition----
      
      #----Get Records from selected Column to Edit
      record_edits <- reactive({
            selectInput(
                  "recordCondition", 
                  "Where Record Equals: ", 
                  choices = (select(vals$Data, 
                                    one_of(input$recordCol))))
      })#reactive
      
      #-----Display Records from selected Column to Edit
      output$recordSelect <- renderUI({
            record_edits()
      })#recordSelect
      
      #----Get Records from selected Column based on above two paths
      recordCol_edits <- reactive({
            ET <- vals$Data
            selectInput(
                  "recordColChoice", 
                  "Where Record Equals: ", 
                  choices = (select(vals$Data, 
                                    one_of(input$recordColChoice)
                                    )#select
                             )#choices
                  )#selectInput
      })#reactive
      
      #-----Display Records
      output$selection2 <- renderUI({
            recordCol_edits()
      })#render UI
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #----Add Column with Condition----
      
      #----Get Record from selected Column to Edit
      column_edits_ <- reactive({
            ET <- vals$Data
            selectInput(
                  "recordChoice_", 
                  "Where Record Equals: ", 
                  choices = (
                        select(
                              vals$Data, 
                              one_of(input$columnChoice_)
                              )#select
                        )#choices
                  )#selectInput
      })#reactive
      
      #----Display Record from selected Column to Edit
      output$colSelection <- renderUI({
            column_edits_()
      })#render UI
      
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #---Update a Record Entry and Save Button-------
      new.Entry <- reactive({
            vals$Data = vals$Data[get(input$ColumnChoice)== input$recordChoice, 
                                  input$ColumnChoice := input$new_record_entry]
      })#reactive
      
      #---save new record edit
      observeEvent(
            input$recordSave,{
                  new.Entry()
            })#observe column edit]
      
      
      #Record change with condition
      #       selectInput("recordColChoice", "Pick a Column to Edit: ", selected = NULL, choices = names(vals$Data), width = 600)
      # ),#column
      # column(width = 6,
      #        uiOutput("selection2")   
      # ),#column
      # selectInput("recordCol", "Where Column equals: ", choices = names(vals$Data)),
      # uiOutput("recordSelect"),
      # actionButton("condtionSave", "Enter New Record", icon = icon("save"), width = "100%")
      
      
      new.Entry.Condition <- reactive({
            #vals$Data = vals$Data[get(input$recordColChoice)== input$recordColChoice, get(input$recordCol) == input$recordCondition, input$recordCol := input$new_record_entry]
            
            #vals$Data[,input$recordCol == input$recordCondition] = vals$Data[get(input$recordColChoice)== input$recordColChoice, input$recordCol := input$new_record_entry]
      })#reactive
      
      # observeEvent(input$conditionSave,{
      #       new.Entry.Condition()
      # })
      
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #---Enter/Save a New Column----
      new.Col <- reactive({
            source(
                  paste(
                        dashboard.tab, 
                        'New_Column_Entry.R', 
                        sep = ''), 
                  local = T)$value
      })#reactive
      
      #---Save Button to save new Column
      observeEvent(
            input$columnSave,{
                  new.Col()
      })#observe
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #---Delete a Column----
      del.Col <- reactive({
            vals$Data[,
                      input$delColumnChoice := NULL]
            showModal(
                  modalDialog(
                        title = "Notification", 
                        "Column has been Deleted! Refresh Page to see changes.", 
                        easyClose = T))
      })#reactive
      
      #----Button to Delete Column
      observeEvent(input$delColumnSave,{
            del.Col()
      })#observe
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #----Add column/Edit Rows UI (Part of Dashboard)----
      output$dashboard_record <- renderUI({
            source(
                  paste(
                        dashboard.tab, 
                        'Dashboard_Tab_Edit-Add-Delete-Column-Records_UI.R', 
                        sep = ''), 
                  local = T)$value
      })#renderUI
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #----Main Dashboard Tab UI----
      #Dashboard
      output$dashBoard <- renderUI({
            source(
                  paste(
                        dashboard.tab, 
                        'Dashboard_Tab_UI.R', 
                        sep = ''), 
                  local = T)$value
      })#render 
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #----Search Personnel Top Filters UI-----
      output$search <- renderUI({
            source(
                  paste(
                        searchPerssonel.tab, 
                        'Search_Personnel_Tab_Filters_UI.R', 
                        sep = ''), 
                  local = T)$value
      })#render
      
      #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      #----Download File Tab Filters-----
      output$download_page <- renderUI({
            source(
                  paste(
                        downloadFiles.tab, 
                        'Download_Files_Tab_Filters_UI.R', 
                        sep = ''), 
                  local = T)$value
      })#render
})#End server

shinyApp(ui = ui, server = server)