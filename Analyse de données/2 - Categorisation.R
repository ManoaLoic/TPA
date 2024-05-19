install.packages("cluster")
library(cluster)

#Liste colonne pour catégorisation
data <- catalogue[, c("puissance", "longueur", "nbplaces", "nbportes", "prix", "co2", "bonusmalus", "coutenergie")]
#View(data)

# Modification du type de la variable en factor
data$longueur <- factor(as.factor(data$longueur))
data$nbplaces <- factor(as.factor(data$nbplaces))
data$nbportes <- factor(as.factor(data$nbportes))

# Caracteristique de nbplaces et nbportes en ordinal ordinale
str(data)

#---------------------#
# MATRICE DE DISTANCE #
#---------------------#

# Calcul de la matrice de distance par la fonction daisy() pour variables heterogenes
dmatrix <- daisy(data)

# Resume de la matrice
summary(dmatrix)

#---------------------------------#
# CLUSTERING PAR PARTITIONNEMENT  #
#---------------------------------#

# Split pour 5 catégories
km4 <- kmeans(dmatrix, 4)

# Ajout de la colonne du numero de cluster
data_km4 <- data.frame(data)
data_km4$Cluster <- km4$cluster
#View(data_km4)


table(data_km4$Cluster)
cluster1 <- data_km4[data_km4$Cluster == 1,]
cluster2 <- data_km4[data_km4$Cluster == 2,]
cluster3 <- data_km4[data_km4$Cluster == 3,]
cluster4 <- data_km4[data_km4$Cluster == 4,]

###############################################
#View(cluster1)
table(cluster1)
table(cluster1$puissance) 
table(cluster1$nbplaces)  
table(cluster1$nbportes)
table(cluster1$longueur)
table(cluster1$prix)
nrow(cluster1)
str(cluster1)#Compacte
###############################################

###############################################
#View(cluster2) 
table(cluster2$puissance)  
table(cluster2$nbplaces)
table(cluster2$nbportes) 
table(cluster2$longueur)
table(cluster2$prix)
nrow(cluster2)
str(cluster2)#Coupé
###############################################

###############################################
#View(cluster3) 
table(cluster3$puissance)
table(cluster3$nbplaces)
table(cluster3$nbportes)
table(cluster3$longueur)
table(cluster3$prix)
nrow(cluster3)
str(cluster3)# Familliale
###############################################

###############################################
#View(cluster4) 
table(cluster4$puissance)
table(cluster4$nbplaces)
table(cluster4$nbportes)
table(cluster4$longueur)
table(cluster4$prix)
nrow(cluster4)
str(cluster4)# Berline
###############################################

#ajout de la categorie aux clusters correspondants

data_km4$categorie <- ifelse(data_km4$Cluster == 1 , "Compacte", "autres")
data_km4[data_km4$categorie == "autres" & data_km4$Cluster == 2, c("categorie")] <- "Coupé"
data_km4[data_km4$categorie == "autres" & data_km4$Cluster == 3, c("categorie")] <- "Familliale"
data_km4[data_km4$categorie == "autres" & data_km4$Cluster == 4, c("categorie")] <- "Berline"
table(data_km4$categorie)

#Suppression colonne Cluster
data_km4 <- subset(data_km4, select = -Cluster)

#affectation resultat dans datacategorie
dataCategorie <- data_km4
str(dataCategorie)
#View(dataCategorie)
