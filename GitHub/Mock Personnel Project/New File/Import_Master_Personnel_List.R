#------------------------------------------------------------------------
#Import excel table

Tableau_Personnel <- read_excel(paste(beginning.path, 'Mock_Personnel_List.xlsx', sep = ''))

tableauPersonnel <- Tableau_Personnel

#------------------------------------------------------------------------
#Data.frame for rHandsonTable
personnel_Table <- data.frame(
      SalesforceName = tableauPersonnel$SalesforceName, ClarityName = tableauPersonnel$ClarityName, StartDate = tableauPersonnel$StartDate,
      EndDate = tableauPersonnel$EndDate, FTE = tableauPersonnel$FTE, Role = tableauPersonnel$Role, Team = tableauPersonnel$Team,
      Director = tableauPersonnel$Director, VP = tableauPersonnel$VP,stringsAsFactors = FALSE)
personnel_Table$StartDate <- as.Date(tableauPersonnel$StartDate, format = "%Y/%m/%d")
personnel_Table$EndDate <- as.Date(tableauPersonnel$EndDate, format = "%Y/%m/%d")
personnel_Table$FTE <- as.numeric(tableauPersonnel$FTE)

#------------------------------------------------------------------------
#Data.table to edit
tableauPersonnel <- data.table(tableauPersonnel)
tableauPersonnel$StartDate <- as.Date(tableauPersonnel$StartDate, format = "%Y/%m/%d")
tableauPersonnel$EndDate <- as.Date(tableauPersonnel$EndDate, format = "%Y/%m/%d")
tableauPersonnel$FTE <- as.numeric(tableauPersonnel$FTE)