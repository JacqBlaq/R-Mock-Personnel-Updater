ET = vals$Data
ET[["Select"]] <- paste0('<input name="row_selected" type="checkbox" value="Row', 1:nrow(vals$Data),'">')
ET[["Actions"]] <- paste0('
                          <div class="btn-group" role="group" aria-label="Basic example">
                          <button class="btn btn-secondary delete" id="delete_',1:nrow(vals$Data),'" type = "button">Delete</button>
                          </div>
                          ')

#----Filter Full-time and Part-time employees-------------------------------
if(input$full_ex == T){
      ET <- ET[ET$FTE == 1,]
}
if(input$part_ex == T){
      ET <- ET[ET$FTE != 1,]
}

#----Filter who has an End date and who doesnt-------------------------------
if(input$noEndex == T){
      ET <- ET[is.na(ET$EndDate)]
}
if(input$yesEndex == T){
      ET <- ET[!is.na(ET$EndDate)]
}#if

tab_edit <- datatable(ET, 
                      escape = F, 
                      filter = "top",
                      options = list(class = 'cell-border stripe',
                                     lengthMenu = c(5, 10, 15,  20), 
                                     pageLength = 5)
                      )#datatable