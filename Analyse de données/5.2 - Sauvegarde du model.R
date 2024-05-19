install.packages("base64enc")
library(base64enc)

getNextId <- function(conn, tableName) {
  query <- sprintf("SELECT COALESCE(MAX(id), 0) + 1 AS next_id FROM %s", tableName)
  result <- dbGetQuery(conn, query)
  next_id <- result$next_id[[1]]
  return(next_id)
}

type_model <- "C50"
table_name <- "model_storage"
temp_file <- tempfile(fileext = ".rds")
saveRDS(c5, temp_file)
raw_model <- readBin(temp_file, "raw", n = file.info(temp_file)$size)
base64_model <- base64encode(raw_model)

conn <- dbConnect( drv, hiveConnectionUrl, user, password)
next_id <- getNextId(conn, table_name)
dbSendUpdate(conn, sprintf("INSERT INTO %s VALUES (%d, '%s', '%s')", table_name, next_id, type_model, base64_model))
dbDisconnect(conn)
