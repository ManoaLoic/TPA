# #Verification donnees immatriculation
# nrow(Immatriculation)
# length(unique(Immatriculation$immatriculation))
#   #Suppression doublon immatriculation
#   doublonImmatriculation = subset(Immatriculation, duplicated(Immatriculation$immatriculation) )
#   Immatriculation <- subset(Immatriculation, !Immatriculation$immatriculation %in% doublonImmatriculation$immatriculation)
#   nrow(Immatriculation)

# #verification donnees client
# str(client) 
# nrow(client)
#   #suppression colonne idclient
#   client <- client[ , c(-1)]

#   #correction donnee client
#   #sexe
#   client[client$sexe == 'Féminin', c('sexe')] <- 'F'
#   client[client$sexe == 'Femme', c('sexe')] <- 'F'
#   table(client$sexe)
  
#   client[client$sexe == 'Masculin', c('sexe')] <- 'M'
#   client[client$sexe == 'Homme', c('sexe')] <- 'M'
#   table(client$sexe)
  
#   client[client$sexe == '', c('sexe')] <- 'N/D'
#   client[client$sexe == '?', c('sexe')] <- 'N/D'
#   client <- client[client$sexe != 'N/D', ]
#   table(client$sexe)
  
#   #situationfamiliale
#   celibataire <- "Célibataire"
#   celibataire <- iconv(celibataire, from = "UTF-8", to = "latin1")
  
#   client[client$situationfamiliale == 'Célibataire', c('situationfamiliale')] <- celibataire
#   client[client$situationfamiliale == 'Divorcée', c('situationfamiliale')] <- celibataire
#   client[client$situationfamiliale == 'Seul', c('situationfamiliale')] <- celibataire
#   client[client$situationfamiliale == 'Seule', c('situationfamiliale')] <- celibataire
#   table(client$situationfamiliale)
  
#   client[client$situationfamiliale == 'Marié(e)', c('situationfamiliale')] <- 'En Couple'
#   table(client$situationfamiliale)
  
#   client[client$situationfamiliale == '', c('situationfamiliale')] <- 'N/D'
#   client[client$situationfamiliale == '?', c('situationfamiliale')] <- 'N/D'
#   client <- client[client$situationfamiliale != 'N/D', ]
#   table(client$situationfamiliale)

#   #age
#   client <- client[client$age != '', ]
#   client <- client[client$age != '?', ]
#   client <- client[client$age != -1, ]
#   table(client$age)
  
#   #nbenfantsacharge
#   client <- client[client$nbenfantsacharge != '', ]
#   client <- client[client$nbenfantsacharge != '?', ]
#   client <- client[client$nbenfantsacharge != -1, ]
#   table(client$nbenfantsacharge)
  
#   #voiture2
#   client <- client[client$voiture2 != '', ]
#   client <- client[client$voiture2 != '?', ]
#   table(client$voiture2)
  
#   #taux
#   #-1,   " " , ?
#   client <- client[client$taux != '', ]
#   client <- client[client$taux != '?', ]
#   client <- client[client$taux != -1, ]
#   table(client$taux)
  
#   #immatriculation
#   #Suppression doublon immatriculation
#   length(unique(client$immatriculation))
#   doublonClientImmatriculation = subset(client, duplicated(client$immatriculation) )
#   client <- subset(client, !client$immatriculation %in% doublonClientImmatriculation$immatriculation)
#   str(client)
#   #View(client)  
  

  # Fonction pour créer un histogramme des effectifs pour une variable
create_histogram <- function(data, var_name) {
  hist(data[[var_name]], main = paste("Histogramme de", var_name), xlab = var_name, col = "skyblue", border = "white")
}

# Fonction pour effectuer une analyse exploratoire complète
explore_data <- function(data) {
  # Résumé statistique
  print(summary(data))
  
  # Histogrammes pour les variables numériques
  numeric_vars <- sapply(data, is.numeric)
  numeric_data <- data[, numeric_vars, drop = FALSE]
  lapply(names(numeric_data), function(var) create_histogram(numeric_data, var))
  
  # Nuages de points pour les paires de variables numériques
  if (ncol(numeric_data) > 1) {
    pairs(numeric_data)
  }
  
  # Boîtes à moustaches pour les variables numériques
 if (ncol(numeric_data) > 0) {
    boxplot(numeric_data)
  }  
  # Tableaux de fréquence pour les variables catégorielles
  categorical_vars <- sapply(data, is.factor)
  categorical_data <- data[, categorical_vars, drop = FALSE]
  lapply(names(categorical_data), function(var) 
    print(table(categorical_data[[var]]))
  )
}

# Exploration des données du client
explore_data(client)

# Exploration des données d'immatriculation
explore_data(Immatriculation)

# Exploration des données du catalogue
explore_data(catalogue)

# Exploration des données de marketing
explore_data(Marketing)
