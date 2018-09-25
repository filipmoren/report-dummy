# this scripts reads environment variables used to 

## RStudio server does not have acces to the global envs defined in the 
## stack.yml, so while developing the envs must be set.
if(test & interactive()) {
  Sys.setenv(REPORT_DATE = "2018-06-01")
  }

## read envs
reportDate <- Sys.getenv("REPORT_DATE") %>% 
  ymd()

if(!is.Date(reportDate)) {
  reportDate <- Sys.Date()
}

# database credentials
dbServer <- Sys.getenv("DB_SERVER")
dbUserName <- Sys.getenv("DB_USERNAME")
dbPassword <- Sys.getenv("DB_PASSWORD")
dbName <- Sys.getenv("DB_NAME")

dbPort <- Sys.getenv("DB_PORT") %>% 
  as.integer()

if(is.na(dbPort)) {dbPort <- 3306L}


