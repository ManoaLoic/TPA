install.packages("rpart")
install.packages("C50")
install.packages("rpart.plot")
library(rpart)
library(rpart.plot)
library(C50)
library(tree)

#Suppression variables inutiles pour prédiction Marketing
newClients <- newClients[ , !(names(newClients) %in% "immatriculation")]
newClients <- newClients[ , !(names(newClients) %in% "puissance")]
newClients <- newClients[ , !(names(newClients) %in% "longueur")]
newClients <- newClients[ , !(names(newClients) %in% "nbplaces")]
newClients <- newClients[ , !(names(newClients) %in% "nbportes")]
newClients <- newClients[ , !(names(newClients) %in% "prix")]
newClients <- newClients[ , !(names(newClients) %in% "marque")]
newClients <- newClients[ , !(names(newClients) %in% "nom")]
newClients <- newClients[ , !(names(newClients) %in% "couleur")]
newClients <- newClients[ , !(names(newClients) %in% "occasion")]
newClients <- newClients[ , !(names(newClients) %in% "co2")]
newClients <- newClients[ , !(names(newClients) %in% "bonusmalus")]
newClients <- newClients[ , !(names(newClients) %in% "coutenergie")]
str(newClients)

#Modification des données pour conformer aux normes imposées par les modèles
newClients[newClients$categorie == 'Coupé', c('categorie')] <- 'Coupe'
newClients[newClients$situationfamiliale == 'Célibataire', c('situationfamiliale')] <- 'Celibataire'

newClients$sexe <- as.factor(newClients$sexe)
newClients$situationfamiliale <- as.factor(newClients$situationfamiliale)
newClients$voiture_2 <- as.factor(newClients$voiture_2)
newClients$categorie <- as.factor(newClients$categorie)

table(newClients$situationfamiliale)
str(newClients)

# Création des données d'apprentissage et des données de test
nrow(newClients)
#197335 || 80/20 || Test: 39467 et test 157868
test_data <- newClients[1:39467, ]
training_data <- newClients[39468:157868, ]



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
test_rpartAuto <- nrow(test_data[test_data$categorie==test_rp1,])/nrow(test_data)
test_rpartAuto

test_rpartgini <- predict(rpartgini, test_data, type="class")
taux_rpartgini <- nrow(test_data[test_data$categorie==test_rpartgini,])/nrow(test_data)
taux_rpartgini

test_rpartinfo <- predict(rpartinfo, test_data, type="class")
taux_rpartinfo <- nrow(test_data[test_data$categorie==test_rpartinfo,])/nrow(test_data)
taux_rpartinfo



# Model à partir de C5.0
c5 <- C5.0(categorie~., training_data)
test_tree2 <- predict(c5, test_data, type="class")
test_data$Tree2 <- test_tree2
taux_succes2 <- nrow(test_data[test_data$categorie==test_data$Tree2,])/nrow(test_data)
taux_succes2

# Model à partir de tree
tree3 <- tree(categorie~., training_data)

tree_tr1 <- tree(categorie~., training_data, split = "deviance", control = tree.control(nrow(training_data)))
plot(tree_tr1)
text(tree_tr1, pretty = 0)

tree_tr3 <- tree(categorie~., training_data, split = "gini", control = tree.control(nrow(training_data),mincut=1000))
plot(tree_tr3)
text(tree_tr3, pretty = 0)

##################################
test_tree3 <- predict(tree3, test_data, type="class")
test_data$Tree3 <- test_tree3
taux_succes3 <- nrow(test_data[test_data$categorie==test_data$Tree3,])/nrow(test_data)
taux_succes3

test_tree_tr1 <- predict(tree_tr1, test_data, type="class")
taux_succes_tr2 <- nrow(test_data[test_data$categorie==test_tree_tr1,])/nrow(test_data)
taux_succes_tr2

test_tree_tr3 <- predict(tree_tr3, test_data, type="class")
taux_succes_tr3 <- nrow(test_data[test_data$categorie==test_tree_tr3,])/nrow(test_data)
taux_succes_tr3