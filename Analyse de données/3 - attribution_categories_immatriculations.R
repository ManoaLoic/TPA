# Fusion  données d'immatriculations avec le modèle de catégorisation
immatriculations_categorisees <- merge(Immatriculation, dataCategorie, by = c("puissance", "longueur", "nbplaces", "nbportes", "prix"), all.x = TRUE)

# Suppression des colonnes inutiles après fusion
immatriculations_categorisees <- immatriculations_categorisees[, c("immatriculation", "marque.x", "nom.x", "puissance", "longueur", "nbplaces", "nbportes", "couleur.x", "occasion.x", "prix", "categorie")]

# Renommer les colonnes pour correspondre à la table d'immatriculations
colnames(immatriculations_categorisees) <- c("immatriculation", "marque", "nom", "puissance", "longueur", "nbplaces", "nbportes", "couleur", "occasion", "prix", "categorie")

# Sauvegarde du résultat dans un fichier CSV
write.csv(immatriculations_categorisees, "immatriculations_categorisees.csv", row.names = FALSE)