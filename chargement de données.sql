--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++ Chargement dans MongoDB
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++ Chargement dans Oracle NoSQL
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++ Chargement dans HDFS
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- IMPORTATION DES FICHIERS CSV 
-- importer le fichier Marketing.csv et CO2.csv dans le dossier  tpa/data
[vagrant@oracle-21c-vagrant ~]$MYTPHOME=/vagrant/TPA/data

-- ajout de  Marketing.csv DANS HDFS
-- Création d'une directorie hadoop
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -mkdir /M2_DMA_Marketing
-- Ajout du fichier
[vagrant@oracle-21c-vagrant ~]$hdfs dfs -put $MYTPHOME/Marketing.csv /M2_DMA_Marketing
-- Vérification
[vagrant@oracle-21c-vagrant ~]$hdfs dfs -ls /M2_DMA_Marketing
-rw-r--r--   1 vagrant supergroup        638 2024-04-26 20:07 /M2_DMA_Marketing/Marketing.csv

