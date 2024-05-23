install.packages("base64enc")
install.packages("R.utils")
library(base64enc)
library(R.utils)

getNextId <- function(conn, tableName) {
  query <- sprintf("SELECT COALESCE(MAX(id), 0) + 1 AS next_id FROM %s", tableName)
  result <- dbGetQuery(conn, query)
  next_id <- result$next_id[[1]]
  return(next_id)
}

conn <- dbConnect( drv, hiveConnectionUrl, user, password)
model_hive <- dbGetQuery(conn, "SELECT * FROM model_storage ORDER BY id DESC LIMIT 1")
names(model_hive) <- gsub("model_storage.", "", names(model_hive))
model_type <- model_hive$model_type
model_base64 <- model_hive$model
model_raw <- base64decode(model_base64)
temp_file <- tempfile(fileext = ".rds")
writeBin(model_raw, temp_file)
model <- readRDS(temp_file)

class_result <- predict(model, Marketing, type="class")
class_result
table(class_result)

#---------------------------------#
# ENREGISTREMENT DES PREDICTIONS  #
#---------------------------------#

# Ajout des resultat dans une colonne Prediction au data frame Marketing
Marketing$categorie <- class_result
View(Marketing)

# Creation requete sql
sql <- "INSERT INTO MARKETING_PREDICT_RESULT VALUES "
next_id <- getNextId(conn, "MARKETING_PREDICT_RESULT")
for (i in 1:nrow(Marketing)) {
  values <- sprintf("(%d, %d, '%s', %d, '%s', %d, '%s', '%s'),", next_id, 
                    Marketing$age[i], Marketing$sexe[i], Marketing$taux[i], 
                    Marketing$situationfamiliale[i], Marketing$nbenfantsacharge[i], 
                    Marketing$voiture_2[i], Marketing$categorie[i])
  sql <- paste(sql, values)
  next_id <- next_id + 1
}
sql <- substr(sql, 1, nchar(sql) - 1)
print(sql)

#Execution requete sql
dbSendUpdate(conn, sql)

#Deconnexion
dbDisconnect(conn)
