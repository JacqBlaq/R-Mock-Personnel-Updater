### R-Mock-Personnel-Updater
Mock Personnel Updater is meant to be a central location where all your needs may be met pertaining to maintaining personnel information.
Here you can do the following:
* Add new Employee records
* Delete olde employee records
* Save changes made to an Excel file
* Download file in CSV or TSV formats
* Run a monthly expander (will elaborate further down)

#### Requirements
* Download R 3.4.1 or higher from <a href="https://www.r-project.org/">Download R</a>
* Download RStudio from <a href="https://www.rstudio.com/">Download RStudio</a>

#### Install these packages from Packages.R file
##### From CRAN
```
install.packages("shiny")
install.packages("shinydashboard")
install.packages("flexdashboard")
install.packages("shinyjs")
install.packages("shinythemes")
install.packages("htmlwidgets")
install.packages("DT")
install.packages("readxl")
install.packages("data.table")
install.packages("dplyr")
install.packages("rJava")
install.packages("readr")
install.packages("xlsx")
install.packages("lubridate")
install.packages("timeDate")
install.packages("dtplyr")
install.packages("markdown")
install.packages("fun")
install.packages("rhandsontable")
install.packages("plyr")
install.packages("sudoku")
install.packages("lpSolve")
install.packages("devtools")
install.packages("memoise")
install.packages("wordcloud")
```
### In global.R file update lines 1 to 5
#### Update with directory paths to each folder location
```
beginning.path <- 'C:/../../../GitHub/Mock Personnel Project/New File/'
beginning.path <- 'Insert directory path to this folder -----> /New File/'

dashboard.tab <- 'C:/../../../GitHub/Mock Personnel Project/New File/Dashboard Tab/'
dashboard.tab <- 'Insert directory path to this folder ----->/Dashboard Tab/'

downloadFiles.tab <- 'C:/../../../GitHub/Mock Personnel Project/New File/Download Files Tab/'
downloadFiles.tab <- 'Insert directory path to this folder ----->/Download Files Tab/'

monthlyExpander.tab <- 'C:/../../../GitHub/Mock Personnel Project/New File/Monthly Expander Tab/'
monthlyExpander.tab <- 'Insert directory path to this folder ----->/Monthly Expander Tab/'

searchPerssonel.tab <- 'C:/../../../GitHub/Mock Personnel Project/New File/Search Personnel Tab/'
searchPerssonel.tab <- 'Insert directory path to this folder ----->/Search Personnel Tab/'

```
### In app.R file update line 2
#### Update with directory path to folder location
```
beginning.path <- 'C:/../../../../Mock Personnel Project/New File/'
beginning.path <- 'Insert directory path to this folder ----->/New File/'
```

### Expander Tab
<img src="https://image.ibb.co/d2vFFG/4.png" border="1" width="800px">

### Dashboard Tab
<img src="https://image.ibb.co/bxs1pb/5.png" border="1" width="800px"> 

### Dashboard Tab
<img src="https://image.ibb.co/bKJrpb/1.png" border="1" width="870px">

### Search Personnel Tab
<img src="https://image.ibb.co/dDVhvG/2.png" border="1" width="870px">

### Download Files Tab
<img src="https://image.ibb.co/bTn6Nw/3.png" border="1" width="800px">
