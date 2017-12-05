data = reactive({
      if (!is.null(input$hot)) {
            DF = hot_to_r(input$hot)
      } else {
            if (is.null(vals[["DF"]]))
                  DF = vals$Data
            else
                  DF = vals[["DF"]]
      }
      vals[["DF"]] = DF
      DF
})#reactive

output$hot <- renderRHandsontable({
      DF = data()
      if (!is.null(DF))
            rhandsontable(
                  DF, 
                  height = 500, 
                  stretchH = "all"
            ) %>%
            hot_col(
                  col = "StartDate", 
                  type = "date"
            ) %>%
            hot_col(
                  col = "EndDate", 
                  type = "date"
            ) %>%
            hot_col(
                  col = "FTE", 
                  type = "numeric"
            ) %>%
            hot_cols(
                  columnSorting = T
            ) %>%
            hot_cols(
                  fixedColumnsLeft = 1
            ) %>%
            hot_table(
                  highlightCol = TRUE,
                  highlightRow = TRUE
            ) %>%
            hot_context_menu(
                  allowColEdit = T,
                  allowRowEdit = T,
                  customOpts = list(
                        search = list(
                              name = "Search",
                              callback = htmlwidgets::JS(
                                    "function (key, options) {
                              var srch = prompt('Search criteria');
                              this.search.query(srch);
                              this.render();
                                                      }"
                              )
                        ))
            )#hotContextMenu
})
#-----------------------------------
observeEvent(input$save_hot, {
      write.xlsx(
            data(),
            paste(
                  beginning.path, 
                  'Tableau Personnel.xlsx', 
                  sep = ''),
            row.names = F
      )#write
      
      showModal(
            modalDialog(
                  title = "Notification",
                  "Changes have been saved!",
                  easyClose = T
                  )#modalDialog
            )#showModal
})     
