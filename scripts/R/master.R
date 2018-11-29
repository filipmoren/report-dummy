# Load packages ----
pkg <- c("flexdashboard", "tidyverse", "lubridate", "plotly", "scales", "XML", "crosstalk",
         "forcats", "DT", "shiny", "stringr", "rmarkdown", "httr", "feather", "stringr", 
         "gsheet")
pkg <- sapply(pkg, require, character.only = TRUE)
if(!all(pkg)) {
  em <- names(!pkg[pkg])
  em <- paste("The following packages did not load:", paste0(em, collapse = ", "))
  stop(em)
}
rm(pkg)
# Load helper functions
## helperFuns is a script containing custom functions used throughout the 
## report
source("/projFiles/scripts/R/helperFuns.R")

# read envs
# read environmental variables 
if(interactive()) {
  Sys.setenv("TESTING" = TRUE)
}
test <- Sys.getenv("TESTING") %>% 
  as.logical()

if(is.na(test)) {
  stop("Plese specify env variable TESTING as TRUE or FALSE")
}

source("/projFiles/scripts/R/readEnvVariables.R")

# Which customers that we generate reports for is 
# specified in customers.R. This script also contains 
# customer specific settings
source("/projFiles/scripts/R/customers.R")

# get email recipiants
emails <- read_csv("/projFiles/scripts/emailRecipients.csv")
    
# loop over all clients
# This loop iterates over all customers and their departmens as defined in 
# customers.R

for(customer in names(customers)) {
  reportLang <- customers[[customer]]$settings$lang
  
  # Get data from database
  startTime <- Sys.time()
  
  # get data from database
  ## theres no database now, so we'll load god old iris instead
  if(FALSE) {source("/projFiles/scripts/R/getDataFromClone.R")}
  data("iris")
  
  # clean data
  ## source("/projFiles/scripts/R/cleanData.R")
  
  elapsedTimeGetData <- Sys.time() - startTime
  print("Loading data took:")
  print(elapsedTimeGetData)

  
  # loop over all departments of costumer
  for(department in customers[[customer]]$departments) {

    print(paste0(customer, ": ", department))
    
    # create html-report
    outFile <- paste0("report_", department, ".html")

    outDir <- file.path("output", "reports", customer)
    
    # render report
    ## i put this in a try catch to avoid that en error stops the report for
    ## all other cutomers
    tryCatch({
      rmarkdown::render("/projFiles/scripts/markdown/rmdMaster.Rmd",
                        output_file = outFile,
                        output_dir = outDir)
      }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
    
    # email reports
    tryCatch({
      # find email addresses to send report to
      rm(recipients)
      emails[emails$shortName == customer & emails$department == department, ] %>% 
        unite(main, main, cc, sep = ";") %>% 
        pull(main) %>% gsub(";", ",", .) -> recipients
      
      # get text for email
      ## the email text is defined in this script
      # source("/projFiles/scripts/R/emailText.R")
      
      # email report
      ## send email.sh is a bash script that creates an email with the generated report
      ## attached. It then uses swaks to send the email
      # we're not sending any emails now
      if(FALSE) {
      sysCall <- paste("/projFiles/send_email.sh",
                       recipients,
                       paste0(outDir, "/"),
                       outFile,
                       subjectText,
                       bodyText,
                       customer,
                       department)
      
      print(sysCall)
     
        sysResponse <- system(sysCall, intern = TRUE, wait = TRUE) 
        print(sysResponse)
      }
      
      
      
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  }
}

