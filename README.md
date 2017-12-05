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
beginning.path <- 'C:/Users/jgboyor/Documents/GitHub/Mock Personnel Project/New File/'
beginning.path <- 'Insert directory path to this folder -----> /New File/'

dashboard.tab <- 'C:/Users/jgboyor/Documents/GitHub/Mock Personnel Project/New File/Dashboard Tab/'
dashboard.tab <- 'Insert directory path to this folder ----->/Dashboard Tab/'

downloadFiles.tab <- 'C:/Users/jgboyor/Documents/GitHub/Mock Personnel Project/New File/Download Files Tab/'
downloadFiles.tab <- 'Insert directory path to this folder ----->/Download Files Tab/'

monthlyExpander.tab <- 'C:/Users/jgboyor/Documents/GitHub/Mock Personnel Project/New File/Monthly Expander Tab/'
monthlyExpander.tab <- 'Insert directory path to this folder ----->/Monthly Expander Tab/'

searchPerssonel.tab <- 'C:/Users/jgboyor/Documents/GitHub/Mock Personnel Project/New File/Search Personnel Tab/'
searchPerssonel.tab <- 'Insert directory path to this folder ----->/Search Personnel Tab/'

```
### In app.R file update line 2
#### Update with directory path to folder location
```
beginning.path <- 'C:/Users/jgboyor/Documents/GitHub/Mock Personnel Project/New File/'
beginning.path <- 'Insert directory path to this folder ----->/New File/'
```


Homepage | Query Results Example
--------- | ----------
<img src="https://preview.ibb.co/gUCx0w/Screenshot_2017_11_10_09_29_13.png" border="1" width="270px"> | <img src="https://preview.ibb.co/dvhanb/Screenshot_2017_11_10_09_29_33.png" border="1" width="270px">

### Landscape mode
<img src="https://preview.ibb.co/cmF6tG/Screenshot_2017_11_10_09_30_31.png" border="1" width="500px">

No Data Message | No Network Connection Message
--------- | ----------
<img src="https://preview.ibb.co/bTjzDG/Screenshot_2017_11_10_09_31_06.png" border="1" width="270px"> | <img src="https://preview.ibb.co/kacx0w/Screenshot_2017_11_10_11_07_05.png" border="1" width="270px">>

#### Disclaimer
```None of the images used in this app belong to me.```
