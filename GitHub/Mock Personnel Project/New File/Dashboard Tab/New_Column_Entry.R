ET <- vals$Data #<----Reactive Table data

#If checkbox(Check to add new column with a condition) is checked (T)
if (input$condition == T){
      if(input$col_type == "Character"){
            vals$Data = vals$Data[get(input$columnChoice_) == input$recordChoice_, 
                                  input$new_col_name := as.character(input$new_column_entry)
                                  ]
      }else
            if(input$col_type == "Integer"){
                  vals$Data = vals$Data[get(input$columnChoice_) == input$recordChoice_, 
                                        input$new_col_name := as.integer(input$new_column_entry)
                                        ]
            }else
                  if(input$col_type == "Numeric"){
                        vals$Data = vals$Data[get(input$columnChoice_) == input$recordChoice_, 
                                              input$new_col_name := as.numeric(input$new_column_entry)
                                              ]
                  }else
                        if(input$col_type == "Date"){
                              vals$Data = vals$Data[get(input$columnChoice_) == input$recordChoice_, 
                                                    input$new_col_name := as.Date(input$date_column,
                                                                                  format = "%Y/%m/%d")
                                                    ]
                        }
}else{ #If checkbox(Check to add new column with a condition) is not checked
      if(input$col_type == "Character"){
            vals$Data <<- vals$Data[, 
                                    input$new_col_name := as.character(input$new_column_entry)
                                    ]
      }else
            if(input$col_type == "Integer"){
                  vals$Data = vals$Data[, 
                                        input$new_col_name := as.integer(input$new_column_entry)
                                        ]
            }else
                  if(input$col_type == "Numeric"){
                        vals$Data = vals$Data[, 
                                              input$new_col_name := as.numeric(input$new_column_entry)
                                              ]
                  }else
                        if(input$col_type == "Date"){
                              vals$Data = vals$Data[, 
                                                    input$new_col_name := as.Date(input$date_column, 
                                                                                  format = "%Y/%m/%d")
                                                    ]
                        }   
}#else

#----Notification when new column has been successfully added.
showModal(
      modalDialog(
            title = "Notification", 
            "New Column has been added! Refresh Page to see changes.", 
            easyClose = T)
)#showModal