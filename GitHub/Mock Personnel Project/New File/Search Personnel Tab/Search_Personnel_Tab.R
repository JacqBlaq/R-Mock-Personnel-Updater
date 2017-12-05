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