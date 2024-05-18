# Installation et chargement des bibliothèques nécessaires
if (!require(cluster)) install.packages("cluster", dependencies = TRUE)
library(cluster)

# Sélection des colonnes pertinentes du catalogue pour le clustering 
data <- catalogue[, c("puissance", "longueur", "nbplaces", "nbportes", "prix", "co2", "bonusmalus", "coutenergie")]

# Conversion de certaines colonnes en facteurs pour le traitement adéquat
data$longueur <- as.factor(data$longueur)
data$nbplaces <- as.factor(data$nbplaces)
data$nbportes <- as.factor(data$nbportes)

# Vérification de la structure des données après conversion
str(data)

# Calcul de la matrice de distance pour les variables hétérogènes
dmatrix <- daisy(data)

# Résumé de la matrice de distance
summary(dmatrix)

# Clustering par partitionnement k-means en 5 clusters
set.seed(42)  # Pour assurer la reproductibilité des résultats
km_result <- kmeans(dmatrix, centers = 5)

# Ajout des numéros de clusters au dataframe initial
data_clustered <- catalogue
data_clustered$Cluster <- km_result$cluster

# Fonction pour analyser les clusters
analyser_cluster <- function(cluster_data) {
  list(
    puissance = table(cluster_data$puissance),
    longueur = table(cluster_data$longueur),
    nbplaces = table(cluster_data$nbplaces),
    nbportes = table(cluster_data$nbportes),
    prix = summary(cluster_data$prix),
    co2 = summary(cluster_data$co2),
    bonusmalus = summary(cluster_data$bonusmalus),
    coutenergie = summary(cluster_data$coutenergie)
  )
}

# Création des clusters pour l'inspection
clusters <- split(data_clustered, data_clustered$Cluster)
resume_clusters <- lapply(clusters, analyser_cluster)

# Affichage des résumés des clusters pour identifier les catégories
print(resume_clusters)

# Attribution des noms de catégories en fonction des caractéristiques analysées
data_clustered$categorie <- ifelse(data_clustered$Cluster == 1, "Citadine", "Autres")
data_clustered[data_clustered$Cluster == 2, "categorie"] <- "Routière"
data_clustered[data_clustered$Cluster == 3, "categorie"] <- "Sportive"
data_clustered[data_clustered$Cluster == 4, "categorie"] <- "Familiale"
data_clustered[data_clustered$Cluster == 5, "categorie"] <- "SUV"

# Vérification des catégories attribuées
table(data_clustered$categorie)

# Suppression de la colonne Cluster
data_clustered <- subset(data_clustered, select = -Cluster)

# Affectation du résultat dans dataCategorie
dataCategorie <- data_clustered
str(dataCategorie)
View(dataCategorie)

# Sauvegarde des résultats
write.csv(dataCategorie, "clustering_results.csv", row.names = FALSE)
