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