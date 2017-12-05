fluidRow(
      box(
            width = 12,
            status = "primary",
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
