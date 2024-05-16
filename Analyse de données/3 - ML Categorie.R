immatrCatalog <- merge(x = Immatriculation, by = c( "puissance", "longueur", "nbplaces", "nbportes", "prix"), y = dataCategorie )
immatrCatalog <- unique(immatrCatalog)
str(immatrCatalog)
