output$hands <- renderUI({
      fluidRow(
            box(
                  width = 12,
                  rHandsontableOutput("hot"),
                  actionButton("save_hot", 
                               "Save Changes")
            )#box
      )#fluidRow
})#renderUI