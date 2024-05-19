# Fusion dataset immatrCatalog et client
newClients <- merge(x = client, by = "immatriculation",  y = immatrCatalog)
str(newClients)
#table(newClients$categorie)