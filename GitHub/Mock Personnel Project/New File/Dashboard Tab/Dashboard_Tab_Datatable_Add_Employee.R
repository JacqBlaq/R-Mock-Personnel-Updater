if(input$end.date == T){
      end_date = input$endD
}else{
      end_date = as.Date(NA)
}#else

new_row = data.frame(
      SalesforceName = input$name_e,
      ClarityName = input$name_e,
      StartDate =  input$startD,
      EndDate = end_date,
      FTE = input$fte_e,
      Role = input$role_e,
      Team = input$team_e,
      Director = input$dir_e,
      VP = input$vp_e
)#data.frame

new_row$StartDate <- as.Date(new_row$StartDate)
new_row$EndDate <- as.Date(new_row$EndDate)
vals$Data = rbind(vals$Data, 
                  new_row, 
                  fill = T)
showModal(
      modalDialog(
            title = "Notification", 
            "New Employee information has been added!", 
            easyClose = T)
      )#showModal