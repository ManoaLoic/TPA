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
-- Création d'une répertoire hadoop
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
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -ls /M2_DMA_Immatriculations