--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++ Chargement dans MongoDB
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++ Chargement dans Oracle NoSQL
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Création de la variable d'environnement du projet A CHANGER PAR RAPPORT AU VOTRE
export MYTPHOME=/vagrant/TPA
-- Compilation de la classe chargeur
javac -g -cp $KVHOME/lib/kvclient.jar:$MYTPHOME $MYTPHOME/chargeur/Catalogue.java
-- Execution de l'import
java -Xmx256m -Xms256m  -cp $KVHOME/lib/kvclient.jar:$MYTPHOME chargeur.Catalogue
-- Accéder kvStore
java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host localhost
-- Connexion à la base
kv -> connect store -name kvstore
-- Vérification des données
kv -> get table -name catalogue 


--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++ Chargement dans HDFS
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- IMPORTATION DES FICHIERS CSV 
-- importer le fichier Marketing.csv et CO2.csv dans le dossier  tpa/data
[vagrant@oracle-21c-vagrant ~]$ MYTPHOME=/vagrant/TPA/data

-- ajout de  Marketing.csv, C02.csv DANS HDFS
-- Création d'une directorie hadoop
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -mkdir /M2_DMA_Marketing
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -mkdir /CO2

-- Ajout des fichiers
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -put $MYTPHOME/Marketing.csv /M2_DMA_Marketing
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -put $MYTPHOME/CO2.csv /CO2

-- Vérification
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -ls /M2_DMA_Marketing
-rw-r--r--   1 vagrant supergroup        638 2024-04-26 20:07 /M2_DMA_Marketing/Marketing.csv
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -ls /CO2
-rw-r--r--   1 vagrant supergroup      38916 2024-04-26 21:03 /CO2/CO2.csv

