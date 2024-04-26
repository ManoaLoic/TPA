--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++ Création table externe *****
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Demarrage HIVE
--- start hadoop
[vagrant@oracle-21c-vagrant ~]$ start-dfs.sh
[vagrant@oracle-21c-vagrant ~]$ start-yarn.sh

-- start hive
[vagrant@oracle-21c-vagrant ~]$nohup hive --service metastore > hive_metastore.log 2>&1 &
[vagrant@oracle-21c-vagrant ~]$nohup hiveserver2 > /dev/null &

-- hive connection
-- connect hive
[vagrant@oracle-21c-vagrant ~]$ beeline
beeline>  !connect jdbc:hive2://localhost:10000

 -- CRÉATION DE LA TABLE EXTERNE POUR LA TABLE M2_DMA_Immatriculations
0: jdbc:hive2://localhost:10000> drop table M2_DMA_Immatriculations_ext
0: jdbc:hive2://localhost:10000>CREATE EXTERNAL TABLE M2_DMA_Immatriculations_ext (
    IDIMMATRICULATION string,
    IMMATRICULATION string,
    MARQUE string,
    NOM string,
    PUISSANCE int,
    LONGUEUR string,
    NBPLACES int,
    NBPORTES int,
    COULEUR string,
    OCCASION boolean,
    PRIX int
)    
STORED BY "com.mongodb.hadoop.hive.MongoStorageHandler"
WITH SERDEPROPERTIES(
    'mongo.columns.mapping'='{"IDIMMATRICULATION":"_id","NBPLACES":"nbPlaces","NBPORTES":"nbPortes"}'
)
TBLPROPERTIES ("mongo.uri" = "mongodb://localhost:27017/datatpa.M2_DMA_Immatriculations");

-- vérification des données

0: jdbc:hive2://localhost:10000>select * FROM M2_DMA_Immatriculations_ext
    --------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------+--------------------------------------+---------------------------------------+-----------------------------------+
| m2_dma_immatriculations_ext.idimmatriculation  | m2_dma_immatriculations_ext.immatriculation  | m2_dma_immatriculations_ext.marque  | m2_dma_immatriculations_ext.nom  | m2_dma_immatriculations_ext.puissance  | m2_dma_immatriculations_ext.longueur  | m2_dma_immatriculations_ext.nbplaces  | m2_dma_immatriculations_ext.nbportes  | m2_dma_immatriculations_ext.couleur  | m2_dma_immatriculations_ext.occasion  | m2_dma_immatriculations_ext.prix  |
+------------------------------------------------+----------------------------------------------+-------------------------------------+----------------------------------+----------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------+--------------------------------------+---------------------------------------+-----------------------------------+
| 662bdd5a987a813713f81c8b                       | 3721 QS 49                                   | Volvo                               | S80 T6                           | 272                                    | tr�s longue                           | 5                                     | 5                                     | noir                                 | false                                 | 50500                             |
+------------------------------------------------+----------------------------------------------+-------------------------------------+----------------------------------+----------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------+--------------------------------------+---------------------------------------+-----------------------------------+

 -- CRÉATION DE LA TABLE EXTERNE POUR  M2_DMA_Marketing
0: jdbc:hive2://localhost:10000>drop table M2_DMA_Marketing_ext;
0: jdbc:hive2://localhost:10000>CREATE EXTERNAL TABLE  M2_DMA_Marketing_ext (
    AGE int, 
    SEXE string,
    TAUX int,
    SITUATIONFAMILIALE string,
    NBENFANTSACHARGE int,
    VOITURE2 boolean
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION 'hdfs:/M2_DMA_Marketing' TBLPROPERTIES ("skip.header.line.count" = "1");
-- vérification des données
0: jdbc:hive2://localhost:10000>select * from M2_DMA_Marketing_ext;
+---------------------------+----------------------------+----------------------------+------------------------------------------+----------------------------------------+--------------------------------+
| m2_dma_marketing_ext.age  | m2_dma_marketing_ext.sexe  | m2_dma_marketing_ext.taux  | m2_dma_marketing_ext.situationfamiliale  | m2_dma_marketing_ext.nbenfantsacharge  | m2_dma_marketing_ext.voiture2  |
+---------------------------+----------------------------+----------------------------+------------------------------------------+----------------------------------------+--------------------------------+
| 21                        | F                          | 1396                       | C�libataire                              | 0                                      | false                          |
+---------------------------+----------------------------+----------------------------+------------------------------------------+----------------------------------------+-