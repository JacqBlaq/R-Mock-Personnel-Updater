tabsetPanel(
      type = "tabs",
      tabPanel("Add/Delete New Employee",
               br(),
               box( #----Add New Employee Box-------------------------------------
                     solidHeader = T,
                     width = 2,
                     status = "success",
                     textInput(
                           "name_e", 
                           "Name:"),
                     textInput(
                           "role_e", 
                           "Role:"),
                     textInput(
                           "team_e", 
                           "Team:"),
                     textInput(
                           "dir_e", 
                           "Director:"),
                     textInput(
                           "vp_e", 
                           "VP: ", 
                           value = "Brenda Cackett"),
                     dateInput(
                           "startD", 
                           "Start Date:", 
                           value = NULL, 
                           format = "yyyy-mm-dd"),
                     checkboxInput(
                           "end.date", 
                           "Has End Date", 
                           value = F),
                     dateInput(
                           "endD", 
                           "End Date:", 
                           value =  as.Date(NA), 
                           format = "yyyy-mm-dd"),
                     numericInput(
                           "fte_e", 
                           "FTE:", 
                           value = 1),
                     actionButton(
                           inputId = "Add_row_head",
                           label = "Add new Employee"),
                     hr()
               ),#box
               box(
                     width = 10,
                     column(
                           width = 12,
                           offset = 0,
                           tabsetPanel(
                                 tabPanel("Data Table",
                                          box(
                                                width = 4,
                                                solidHeader = T,
                                                uiOutput("hello")#----Friendly Rules UI Output-----------------
                                                #file.edit(paste(beginning.path, "app.R", sep = ""))
                                                #---Rules Displayed on Dashboard
                                          ),#box
                                          box(solidHeader = T,
                                              width = 2,
                                              status = "primary",
                                              checkboxInput(
                                                    "full_ex", 
                                                    "Full-Time", 
                                                    value = F),
                                              checkboxInput(
                                                    "part_ex", 
                                                    "Part-Time", 
                                                    value = F),
                                              hr()
                                          ),#box
                                          box(solidHeader = T,
                                              width = 2,
                                              status = "success",
                                              checkboxInput(
                                                    "noEndex", 
                                                    "No End Date", 
                                                    value = F),
                                              checkboxInput(
                                                    "yesEndex", 
                                                    "Has End Date", 
                                                    value = F),
                                              hr()
                                          ),#box
                                          box(solidHeader = T,
                                              width = 4,
                                              status = "warning",
                                              textInput(
                                                    "personnelName", 
                                                    "Download As:", 
                                                    value = "Untitled"),
                                              HTML('<div class="btn-group" role="group" aria-label="Basic example">'),
                                              downloadButton(
                                                    "download_personnel", 
                                                    "Download"),
                                              actionButton(
                                                    inputId = "save_edit", 
                                                    label = "Save Changes", 
                                                    icon = icon("save")),
                                              actionButton(
                                                    inputId = "expand_expander", 
                                                    label = "Save Expander"),
                                              HTML('</div>')
                                          ),#box
                                          
                                          dataTableOutput("Main_table_"),  #----Dashboard DataTable-----------------------------------
                                          #file.edit(paste(beginning.path, "Dashboard_Tab_Datatable_Filters.R", sep = ""))
                                          #------Output Datatable Display on Dashboard
                                          HTML('<div class="btn-group" role="group" aria-label="Basic example">'),
                                          actionButton(
                                                inputId = "Del_row_head",
                                                label = "Delete selected rows"),
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
                                 ),#tabPanel
                                 tabPanel("Inline Editing",
                                          uiOutput("hands")  #----RHandsOnTable UI Output-----------------------------------
                                          
                                 )#tabPanel
                                 
                           )#tabsetPanel
                           
                           
                     )#column
                     
               )#box 
      ),#tabPanel
      tabPanel("Sudoku", #----Sudoku-----------------------------------
               box(solidHeader = T,
                   width = 2,
                   collapsible = TRUE,
                   hr(),
                   sliderInput(
                         "blanks", 
                         label = "Number of Blanks",
                         min = 9, 
                         max = 81, 
                         value = 40),
                   actionButton(
                         "newButton", 
                         "New Puzzle"),
                   hr(), 
                   h4('Solve Automatically:'),
                   actionButton(
                         "solveButton", 
                         "Solve"),
                   hr(),
                   h4('Solve Manually:'),
                   p('Use the row/column dropdowns to input your guesses:'),
                   selectInput(
                         "row", 
                         label = "Row", 
                         choices = list(1,2,3,4,5,6,7,8,9), 
                         selected = 5),
                   selectInput(
                         "col", 
                         label = "Column", 
                         choices = list(1,2,3,4,5,6,7,8,9), 
                         selected = 5),     
                   selectInput(
                         "value", 
                         label = "Value", 
                         choices = list(1,2,3,4,5,6,7,8,9," "=0), 
                         selected = 0),
                   actionButton(
                         "setButton", 
                         "Set"),
                   hr()
               ),#box
               box(
                     solidHeader = T,
                     width = 5,
                     plotOutput(
                           "sudoku", 
                           width = "100%", 
                           height = "652px"),
                     hr()
               ),#box
               box(
                     solidHeader = T,
                     width = 5,
                     selectInput(
                           "selection", 
                           "Choose a book:",
                           choices = books),
                     actionButton(
                           "update", 
                           "Change"),
                     sliderInput("freq",
                                 "Minimum Frequency:",
                                 min = 1,  
                                 max = 50, 
                                 value = 20),
                     sliderInput("max",
                                 "Maximum Number of Words:",
                                 min = 1,  
                                 max = 300,  
                                 value = 125),
                     
                     hr(),
                     plotOutput(
                           "plot", 
                           width = "100%")
               )#box
      )#tabPanel
)#tabsetPanel