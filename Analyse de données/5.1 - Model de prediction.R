install.packages("rpart")
install.packages("C50")
install.packages("rpart.plot")
install.packages("partykit")
library(rpart)
library(rpart.plot)
library(C50)
library(tree)
library(partykit)

#Suppression variables inutiles pour prédiction Marketing
clients_immatriculations <- clients_immatriculations[ , !(names(clients_immatriculations) %in% "immatriculation")]
clients_immatriculations <- clients_immatriculations[ , !(names(clients_immatriculations) %in% "puissance")]
clients_immatriculations <- clients_immatriculations[ , !(names(clients_immatriculations) %in% "longueur")]
clients_immatriculations <- clients_immatriculations[ , !(names(clients_immatriculations) %in% "nbplaces")]
clients_immatriculations <- clients_immatriculations[ , !(names(clients_immatriculations) %in% "nbportes")]
clients_immatriculations <- clients_immatriculations[ , !(names(clients_immatriculations) %in% "prix")]
clients_immatriculations <- clients_immatriculations[ , !(names(clients_immatriculations) %in% "marque")]
clients_immatriculations <- clients_immatriculations[ , !(names(clients_immatriculations) %in% "nom")]
clients_immatriculations <- clients_immatriculations[ , !(names(clients_immatriculations) %in% "couleur")]
clients_immatriculations <- clients_immatriculations[ , !(names(clients_immatriculations) %in% "occasion")]
clients_immatriculations <- clients_immatriculations[ , !(names(clients_immatriculations) %in% "co2")]
clients_immatriculations <- clients_immatriculations[ , !(names(clients_immatriculations) %in% "bonusmalus")]
clients_immatriculations <- clients_immatriculations[ , !(names(clients_immatriculations) %in% "coutenergie")]
str(clients_immatriculations)

#Modification des données pour conformer aux normes imposées par les modèles
clients_immatriculations[clients_immatriculations$situationfamiliale == 'Célibataire', c('situationfamiliale')] <- 'Celibataire'

clients_immatriculations$sexe <- as.factor(clients_immatriculations$sexe)
clients_immatriculations$situationfamiliale <- as.factor(clients_immatriculations$situationfamiliale)
clients_immatriculations$voiture_2 <- as.factor(clients_immatriculations$voiture_2)
clients_immatriculations$categorie <- as.factor(clients_immatriculations$categorie)

table(clients_immatriculations$situationfamiliale)
str(clients_immatriculations)

# Création des données d'apprentissage et des données de test
nrow(clients_immatriculations)
#196677 || 80/20 || Test: 39336 et apprentissage 157341
test_data <- clients_immatriculations[1:39336, ]
training_data <- clients_immatriculations[39337:196677, ]



# Model à partir de rpart
rpartAuto <- rpart(categorie~., training_data)
prp(rpartAuto, type=4, extra=8, box.palette = "auto")
text(rpartAuto, pretty = 0)


rpartgini <- rpart(categorie~., training_data, parms = list(split = "gini"))
prp(rpartgini, type=4, extra=8, box.palette = "auto")
text(rpartgini, pretty = 0)

rpartinfo <- rpart(categorie~., training_data, parms = list(split = "information"))
prp(rpartinfo, type=4, extra=8, box.palette = "auto")
text(rpartinfo, pretty = 0)

#################
test_rpartAuto <- predict(rpartAuto, test_data, type="class")
taux_rpartAuto <- nrow(test_data[test_data$categorie==test_rpartAuto,])/nrow(test_data)
taux_rpartAuto

test_rpartgini <- predict(rpartgini, test_data, type="class")
taux_rpartgini <- nrow(test_data[test_data$categorie==test_rpartgini,])/nrow(test_data)
taux_rpartgini

test_rpartinfo <- predict(rpartinfo, test_data, type="class")
taux_rpartinfo <- nrow(test_data[test_data$categorie==test_rpartinfo,])/nrow(test_data)
taux_rpartinfo



# Model à partir de C5.0
c5 <- C5.0(categorie~., training_data)
c5_party <- as.party(c5)
plot(c5_party, type = "simple", gp = gpar(fontsize = 10))
test_tree2 <- predict(c5, test_data, type="class")
test_data$Tree2 <- test_tree2
taux_succes2 <- nrow(test_data[test_data$categorie==test_data$Tree2,])/nrow(test_data)
taux_succes2

# Model à partir de tree
treeAuto <- tree(categorie~., training_data)

tree_tr1 <- tree(categorie~., training_data, split = "deviance", control = tree.control(nrow(training_data)))
plot(tree_tr1)
text(tree_tr1, pretty = 0)

tree_tr3 <- tree(categorie~., training_data, split = "gini", control = tree.control(nrow(training_data),mincut=2000))
plot(tree_tr3)
text(tree_tr3, pretty = 0)

##################################
test_treeAuto <- predict(treeAuto, test_data, type="class")
test_data$TreeAuto <- test_treeAuto
taux_succesAuto <- nrow(test_data[test_data$categorie==test_data$TreeAuto,])/nrow(test_data)
taux_succesAuto

test_tree_tr1 <- predict(tree_tr1, test_data, type="class")
taux_succes_tr2 <- nrow(test_data[test_data$categorie==test_tree_tr1,])/nrow(test_data)
taux_succes_tr2

test_tree_3 <- predict(tree_tr3, test_data, type="class")
taux_succes_tr3 <- nrow(test_data[test_data$categorie==test_tree_3,])/nrow(test_data)
taux_succes_tr3
