install.packages("rJava")
install.packages("RJDBC")
install.packages("DBI")
library("rJava")
library("DBI")
library("RJDBC")

# Load driver & configuration
jdbc_chemin <- "hive-jdbc-2.1.1-standalone.jar"
hadoop_chemin <- "hadoop-common-3.3.5.jar"
drv <- JDBC(driverClass = "org.apache.hive.jdbc.HiveDriver",jdbc_chemin)
drv <- JDBC(driverClass = "org.apache.hive.jdbc.HiveDriver",hadoop_chemin)
user <- "oracle"
password <- "welcome1"
hiveConnectionUrl <- "jdbc:hive2://localhost:10000"

# Connection to hive
conn <- dbConnect( drv, hiveConnectionUrl, user, password)

#Test Connection
dbListTables(conn)

#Retrieve data from database
client <- dbGetQuery(conn, "select * from M2_DMA_Clients_ext")
Immatriculation <- dbGetQuery(conn, "select * from M2_DMA_Immatriculations_ext")
catalogue <- dbGetQuery(conn, "select * from M2_DMA_Catalogue_ext")
Marketing  <- dbGetQuery(conn, "select * from M2_DMA_Marketing_ext")

dbDisconnect(conn)

# Delete table name in each column
names(client) <- gsub("m2_dma_clients_ext.", "", names(client))
names(Immatriculation) <- gsub("m2_dma_immatriculations_ext.", "", names(Immatriculation))
names(catalogue) <- gsub("m2_dma_catalogue_ext.", "", names(catalogue))
names(Marketing) <- gsub("m2_dma_marketing_ext.", "", names(Marketing))


# Verification nom colonne
names(client)
names(Immatriculation)
names(catalogue)
names(Marketing)
