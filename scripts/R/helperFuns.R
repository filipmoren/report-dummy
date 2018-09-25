# script containing helper functions used in the project


# clean SQL-query (https://stackoverflow.com/questions/2003663/import-multiline-sql-query-to-single-string)
# This set of functions allows us to read in formatted, commented SQL queries
# Comments must be entire-line comments, not on same line as SQL code, and begun with "--"
# The parsing function, to be applied to each line:
LINECLEAN <- function(x) {
  x = gsub("\t+", "", x, perl=TRUE); # remove all tabs
  x = gsub("^\\s+", "", x, perl=TRUE); # remove leading whitespace
  x = gsub("\\s+$", "", x, perl=TRUE); # remove trailing whitespace
  x = gsub("[ ]+", " ", x, perl=TRUE); # collapse multiple spaces to a single space
  x = gsub("^[--]+.*$", "", x, perl=TRUE); # destroy any comments
  return(x)
}
# PRETTYQUERY is the filename of your formatted query in quotes, eg "myquery.sql"
# DIRPATH is the path to that file, eg "~/Documents/queries"
cleanSqlQuery <- function(PRETTYQUERY,DIRPATH) { 
  A <- readLines(paste0(DIRPATH,"/",PRETTYQUERY)) # read in the query to a list of lines
  B <- lapply(A,LINECLEAN) # process each line
  C <- Filter(function(x) x != "",B) # remove blank and/or comment lines
  D <- paste(unlist(C),collapse=" ") # paste lines together into one-line string, spaces between.
  return(D)
}
  

dropDownDescription <- function(text = "Add text", top = 95, left = 20, width = "20%", title = "About the graph") {
  # each dropdown box needs a unique ID which is made from a timestamp.
  boxName <- Sys.time() %>% as.numeric() %>% as.character() %>% gsub("\\.", "", .)
  boxName <- paste0("box", boxName)
  
  classDefinition <- paste0('<button data-toggle="collapse" data-target="#', 
                            boxName,
                            '" class="btn-block btn-primary">', 
                            title, 
                            '</button>')
  
  x <- absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                draggable = FALSE, top = top, left = left, right = "auto", bottom = "auto",
                width = width, height = 'auto', 
                style = "overflow-y:scroll; max-height: 1000px; opacity: 1; style = z-index: 400",
                
                HTML(classDefinition),
                tags$div(id = boxName, class="collapse",
                         HTML(paste0("<br>",text, "<br><br>"))
                         
                ))
  return(x)
}
 

firs2capital <- function(x) {
  substr(x, 1, 1) <- toupper(substr(x, 1, 1))
  x
}
