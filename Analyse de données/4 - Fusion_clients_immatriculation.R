# Fusionner les données des clients avec les données des immatriculations catégorisées
clients_immatriculations <- merge(client, immatriculations_categorisees, by = "immatriculation")

# Afficher la structure des données fusionnées
str(clients_immatriculations)

# Sauvegarder les résultats de la fusion dans un fichier CSV
write.csv(clients_immatriculations, "clients_immatriculations.csv", row.names = FALSE)
