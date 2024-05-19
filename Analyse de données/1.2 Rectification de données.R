#Rectification Client
#sexe
client[client$sexe == 'F�minin', c('sexe')] <- 'F'
client[client$sexe == 'Femme', c('sexe')] <- 'F'
table(client$sexe)

client[client$sexe == 'Masculin', c('sexe')] <- 'M'
client[client$sexe == 'Homme', c('sexe')] <- 'M'
table(client$sexe)

client[client$sexe == '', c('sexe')] <- 'N/D'
client[client$sexe == '?', c('sexe')] <- 'N/D'
client <- client[client$sexe != 'N/D', ]
table(client$sexe)

#situationfamiliale
client[client$situationfamiliale == 'Divorc�e', c('situationfamiliale')] <- 'C�libataire'
client[client$situationfamiliale == 'Seul', c('situationfamiliale')] <- 'C�libataire'
client[client$situationfamiliale == 'Seule', c('situationfamiliale')] <- 'C�libataire'
client[client$situationfamiliale == 'C�libataire', c('situationfamiliale')] <- 'Celibataire'
table(client$situationfamiliale)

client[client$situationfamiliale == 'Mari�(e)', c('situationfamiliale')] <- 'En Couple'
table(client$situationfamiliale)

client[client$situationfamiliale == '', c('situationfamiliale')] <- 'N/D'
client[client$situationfamiliale == '?', c('situationfamiliale')] <- 'N/D'
client <- client[client$situationfamiliale != 'N/D', ]
table(client$situationfamiliale)

#age
client <- client[client$age != '', ]
client <- client[client$age != '?', ]
client <- client[client$age != -1, ]
table(client$age)

#nbenfantsacharge
client <- client[client$nbenfantsacharge != '', ]
client <- client[client$nbenfantsacharge != '?', ]
client <- client[client$nbenfantsacharge != -1, ]
table(client$nbenfantsacharge)

#voiture2
client <- client[client$voiture_2 != '', ]
client <- client[client$voiture_2 != '?', ]
table(client$voiture_2)

#taux
#-1,   " " , ?
client <- client[client$taux != '', ]
client <- client[client$taux != '?', ]
client <- client[client$taux != -1, ]
table(client$taux)


#Immatriculation
#Suppression doublon de ligne
Immatriculation <- Immatriculation[!duplicated(Immatriculation), ]
Immatriculation <- unique(Immatriculation, by = "immatriculation")
nrow(Immatriculation)


# Marketing
names(Marketing)[names(Marketing) == "voiture2"] <- "voiture_2"
Marketing[Marketing$situationfamiliale == 'C�libataire', c('situationfamiliale')] <- 'Celibataire'
