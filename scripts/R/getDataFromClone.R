# read sql queries and get data for the report

# load data
startTime <- Sys.time()

# define which tables to get
tablesToFetch <- c("table1", "table2")

# loop over all tables. Their SQL queries are saved in files named
# tablex.sql. Each table gets asigned the name tablexDatAll since it holds
# all data for all departments within the customer. 
for(Table in tablesToFetch) {
  # print progress
  print(Table)
  startTableTime <- Sys.time()
  print("Time when this table started:")
  print(startTableTime)
  print("Time since script started:")
  print(startTableTime - startTime)
  
  # get sql query
  sqlQuery <- cleanSqlQuery(paste0(Table, ".sql"), "scripts/sql")
  sqlQuery <- paste0(sqlQuery, " '", customer, "'")
    
  # connect to db
  dbCon <- src_mysql(dbname = dbName, 
                     host = dbServer, 
                     port = dbPort, 
                     username = dbUserName, 
                     password = dbPassword)
  
    
    
  # connect to tables
  tmpCon <- tbl(dbCon, sql(sqlQuery))
    
  # import data
  dataName <- paste0(Table, "DatAll")
  assign(x = dataName, value = collect(tmpCon, n = Inf))
    
  # remove duplicates
  assign(dataName, 
         value = filter(get(dataName), !duplicated(get(dataName))))
    
  # close db connection
  rm(dbCon); gc()
    
  
  

  # print progress
  print(paste("table", Table, "took;"))
  print(Sys.time() - startTableTime)
}

elapsedTimeAllTables <- Sys.time() - startTime
print(elapsedTimeAllTables)


  





