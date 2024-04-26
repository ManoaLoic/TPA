--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++ Chargement dans MongoDB
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- IMPORTATION DES FICHIERS CSV 
-- creation dossier TPA/data dans vagrant
-- importer le fichier Clients_19.csv , Clients_0.csv et Immatriculations.csv dans le dossier

-- CREATION DE LA BASE DE DONNEE ET IMPORTATION DES DONNEES DANS MONGO
MYTPHOME=/vagrant/TPA/data
-- importation des données
[vagrant@oracle-21c-vagrant ~]$ mongoimport --db datatpa --collection M2_DMA_Immatriculations --type csv --headerline --drop --file $MYTPHOME/Immatriculations.csv
[vagrant@oracle-21c-vagrant ~]$ mongoimport --db datatpa --collection M2_DMA_Clients --type csv --headerline --drop --file $MYTPHOME/Clients_0.csv
[vagrant@oracle-21c-vagrant ~]$ mongoimport --db datatpa --collection M2_DMA_Clients --type csv --headerline --file $MYTPHOME/Clients_19.csv


--VERIFICATION DES DONNEES 
-- connection à mongo
[vagrant@oracle-21c-vagrant ~]$ mongo
-- afficher les bases des données existantes
>show dbs
    admin    0.000GB
    datatpa  0.133GB
    local    0.000GB
-- vérification des données
> use datatpa
    switched to db datatpa
> show collections
    M2_DMA_Immatriculations
    M2_DMA_Clients
> db.M2_DMA_Immatriculations.count();
    2000000
> db.M2_DMA_Clients.find({});
    2000000

-- Conversion du type de données de la colonne 'occasion' de string à booléen
>   db.M2_DMA_Immatriculations.updateMany(
        { "occasion": "false" }, 
        { $set: { "occasion": false } } 
    );
    {
        "acknowledged" : true,
        "matchedCount" : 1374510,
        "modifiedCount" : 1374510
    }

>   db.M2_DMA_Immatriculations.updateMany(
        { "occasion": "true" }, 
        { $set: { "occasion": true } } 
    );
    { 
        "acknowledged" : true, "matchedCount" : 625490, 
        "modifiedCount" : 625490 
    }

-- Modification du columnn "2eme voiture en voiture_2"
>   db.M2_DMA_Clients.updateMany({}, {$rename: {"2eme voiture": "voiture_2"}});


