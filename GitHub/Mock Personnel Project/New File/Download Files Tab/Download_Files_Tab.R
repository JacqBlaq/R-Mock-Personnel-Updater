box( width = 12,
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
           box( #----Filters on the left side-----
                 status = "info",
                 solidHeader = T,
                 width = 2,
                 height = 900,
                 checkboxGroupInput("check", 
                                    "Filter by column: ", 
                                    choices = c(
                                          unique(
                                                as.character(
                                                      names(
                                                            tableauPersonnel)))), 
                                    selected = names(tableauPersonnel)
                                    ),#checkboxGroupInput
                 hr(),
                 radioButtons("start_level", 
                              "Filter by Start Date", 
                              choices = c("Before", 
                                          "After", "
                                          All"
                                          ),#c
                              selected = "All"
                              ),#radoButtons
                 dateInput("searchDate", 
                           label = NULL, 
                           value = NULL, 
                           format = "yyyy-mm-dd"
                           ),#dateInput
                 hr(),
                 radioButtons("end_level", 
                              "Filter by End Date", 
                              choices = c(
                                    "Before", 
                                    "After", 
                                    "All"
                                    ),#c
                              selected = "All"
                              ),#radioButtons
                 dateInput("search_endDate", 
                           label = NULL, 
                           value = NULL, 
                           format = "yyyy-mm-dd"
                           ),#dateInput
                 hr(),
                 radioButtons("filetype", 
                              "File type:",
                              choices = c(
                                    "csv", 
                                    "tsv"
                                    )#c
                              ),#radioButton
                 textInput("fileName", 
                           "Download file name as:"
                           ),#textInput
                 downloadButton("downloadData", 
                                "Download"
                                )#downloadButton
                 
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
)#box