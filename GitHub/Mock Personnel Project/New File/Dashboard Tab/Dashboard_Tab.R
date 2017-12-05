column(
      width = 12,
      fluidRow(
            infoBox(
                  title = "Hey there!", 
                  value = "Welcome!", 
                  subtitle = "Here, you can easily access the Action Line employee List.",
                  icon = shiny::icon("handshake-o"), 
                  color = "aqua", 
                  width = 4,
                  href = NULL, 
                  fill = FALSE
            ),#info Box
            infoBox(
                  title = "Hey there!", 
                  value = "Edits!", 
                  subtitle = "Edit Former Employee data.",
                  icon = shiny::icon("edit"), 
                  color = "red", 
                  width = 4,
                  href = NULL, 
                  fill = FALSE
            ),#info Box
            infoBox(
                  title = "Hey there!", 
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
                  #----Path to UI Output declaration
                  #file.edit(paste(dashboard.tab, "Dashboard_Tab_Edit-Add-Delete-Column-Records_UI.R", sep = ""))
            )#box  
      ),#fluidRow
      fluidRow(
            box(
                  width = 12,
                  status = "primary",
                  callapsible = TRUE, 
                  uiOutput("dashBoard")
                  #----Path to UI Output declaration
                  #file.edit(paste(dashboard.tab, "Dashboard_Tab_UI.R", sep = ""))
            )#box
      )#fluidRow2
)#column