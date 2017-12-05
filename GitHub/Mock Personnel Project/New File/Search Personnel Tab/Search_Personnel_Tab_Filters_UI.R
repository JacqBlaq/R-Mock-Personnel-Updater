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