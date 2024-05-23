install.packages("data.table")
library(data.table)

setDT(Immatriculation)
setDT(dataCategorie)

# Fusion  données d'immatriculations avec le modèle de catégorisation
Immatriculation[, marque := toupper(marque)]
Immatriculation[, nom := toupper(nom)]
immatriculations_categorisees <- merge(Immatriculation, dataCategorie, 
                                       by = c("nom", "couleur", "puissance", "longueur", "nbplaces", "nbportes", 
                                              "prix", "marque", "occasion"), all.x = TRUE, all.y = FALSE)

# Vérification de la structure du dataframe
str(immatriculations_categorisees)

# Sauvegarde résultat dans un fichier CSV
write.csv(immatriculations_categorisees, "immatriculations_categorisees.csv", row.names = FALSE)
