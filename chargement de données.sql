--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++ Chargement dans MongoDB
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- IMPORTATION DES FICHIERS CSV 
-- creation dossier TPA/data dans vagrant
-- importer le fichier Clients_19.csv , Clients_0.csv dans le dossier

-- CREATION DE LA BASE DE DONNEE ET IMPORTATION DES DONNEES DANS MONGO
MYTPHOME=/vagrant/TPA/data
-- importation des données
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
> db.M2_DMA_Clients.find({});
    2000000

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++ Chargement dans Oracle NoSQL
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Création de la variable d'environnement du projet A CHANGER PAR RAPPORT AU VOTRE
export MYTPHOME=/vagrant/TPA
-- Compilation de la classe chargeur
javac -g -cp $KVHOME/lib/kvclient.jar:$MYTPHOME $MYTPHOME/chargeur/Marketing.java
-- Execution de l'import
java -Xmx256m -Xms256m  -cp $KVHOME/lib/kvclient.jar:$MYTPHOME chargeur.Marketing
-- Accéder kvStore
java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host localhost
-- Connexion à la base
kv -> connect store -name kvstore
-- Vérification des données
kv -> get table -name M2_DMA_Marketing


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++ Chargement dans HDFS
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- IMPORTATION DES FICHIERS CSV 
-- importer le fichier Catalogue.csv et CO2.csv dans le dossier  TPA/data
[vagrant@oracle-21c-vagrant ~]$ MYTPHOME=/vagrant/TPA/data

-- Demarrage de Hadoop HDFS
[vagrant@oracle-21c-vagrant ~]$start-dfs.sh
-- Demarrage de Hadoop YARN
 [vagrant@oracle-21c-vagrant ~]$start-yarn.sh

-- ajout de  Catalogue.csv, C02.csv DANS HDFS
-- Création d'une directorie hadoop
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -mkdir /M2_DMA_Catalogue
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -mkdir /CO2
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -mkdir /M2_DMA_Immatriculations

-- Ajout des fichiers
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -put $MYTPHOME/Catalogue.csv /M2_DMA_Catalogue
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -put $MYTPHOME/CO2.csv /CO2
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -put $MYTPHOME/Immatriculations.csv /M2_DMA_Immatriculations

-- Vérification
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -ls /M2_DMA_Catalogue
-rw-r--r--   1 vagrant supergroup      14114 2024-05-05 18:11 /M2_DMA_Catalogue/Catalogue.csv
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -ls /CO2
-rw-r--r--   1 vagrant supergroup      38916 2024-04-26 21:03 /CO2/CO2.csv

