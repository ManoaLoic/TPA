# Check doublons
check_duplicate <- function(data) {
  duplicate_rows <- duplicated(data)
  duplicate_data <- data[duplicate_rows, ]
  print(duplicate_data)
}

# Fonction pour effectuer une analyse exploratoire complète
explore_data <- function(data) {
  # Histogrammes pour les variables numériques
  numeric_vars <- sapply(data, is.numeric)
  numeric_data <- data[, numeric_vars]
  
  # Boîtes à moustaches pour les variables numériques
  boxplot(numeric_data)
   
  # # Tableaux de fréquence pour les variables catégorielles
  categorical_vars <- sapply(data, function(x) is.factor(x) || is.character(x))
  categorical_data <- data[, categorical_vars]
  lapply(categorical_data, table)
}

# Exploration des données du client
summary(client)
explore_data(client)
check_duplicate(client)

# Exploration des données d'immatriculation
summary(Immatriculation)
explore_data(Immatriculation)
check_duplicate(Immatriculation)

# Exploration des données du catalogue
summary(catalogue)
explore_data(catalogue)
check_duplicate(catalogue)

# Exploration des données de marketing
summary(Marketing)
explore_data(Marketing)
check_duplicate(Marketing)
