--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++ Création table externe HIVE pointant vers les tables physiques Oracle
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- Connexion  HIVE via son client BEELINE
-- On suppose que le serveur beeline a été démarré.

[vagrant@oracle-21c-vagrant ~]$beeline

beeline>   !connect jdbc:hive2://localhost:10000

Enter username for jdbc:hive2://localhost:10000: oracle
Enter password for jdbc:hive2://localhost:10000: ********
(password : welcome1)

-- Créer les tables externes HIVE pointant vers les tables
-- équivalentes oracle Nosql

-- table externe Hive M2_DMA_Catalogue_EXT
0: jdbc:hive2://localhost:10000>drop table M2_DMA_Catalogue_EXT;

0: jdbc:hive2://localhost:10000>CREATE EXTERNAL TABLE M2_DMA_Catalogue_EXT (
    MARQUE string,
    NOM string,
    PUISSANCE int,
    LONGUEUR string,
    NBPLACES int,
    NBPORTES int,
    COULEUR string,
    OCCASION boolean,
    PRIX int,
    co2 double,
    bonusmalus double,
    coutEnergie double
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION 'hdfs:/M2_DMA_New_Catalogue';


-- vérifications

0: jdbc:hive2://localhost:10000>select * from M2_DMA_Catalogue_EXT limit 10 ;
--------------------+-------------------------------+--------------------------------+----------------------------+
| m2_dma_catalogue_ext.marque  | m2_dma_catalogue_ext.nom  | m2_dma_catalogue_ext.puissance  | m2_dma_catalogue_ext.longueur  | m2_dma_catalogue_ext.nbplaces  | m2_dma_catalogue_ext.nbportes  | m2_dma_catalogue_ext.couleur  | m2_dma_catalogue_ext.occasion  | m2_dma_catalogue_ext.prix  |
+------------------------------+---------------------------+---------------------------------+--------------------------------+--------------------------------+--------------------------------+-------------------------------+--------------------------------+----------------------------+
| Volvo                        | S80 T6                    | 272                             | tr�s longue                    | 5                              | 5                              | blanc                         | false                          | 50500                      |
| Volvo                        | S80 T6                    | 272                             | tr�s longue                    | 5                              | 5                              | noir                          | false                          | 50500                      |
| Volvo                        | S80 T6                    | 272                             | tr�s longue                    | 5                              | 5                              | rouge                         | false                          | 50500                      |
| Volvo                        | S80 T6                    | 272                             | tr�s longue                    | 5                              | 5                              | gris                          | true                           | 35350                      |
| Volvo                        | S80 T6                    | 272                             | tr�s longue                    | 5                              | 5                              | bleu                          | true                           | 35350                      |
| Volvo                        | S80 T6                    | 272                             | tr�s longue                    | 5                              | 5                              | gris                          | false                          | 50500                      |
| Volvo                        | S80 T6                    | 272                             | tr�s longue                    | 5                              | 5                              | bleu                          | false                          | 50500                      |
| Volvo                        | S80 T6                    | 272                             | tr�s longue                    | 5                              | 5                              | rouge                         | true                           | 35350                      |
| Volvo                        | S80 T6                    | 272                             | tr�s longue                    | 5                              | 5                              | blanc                         | true                           | 35350                      |
| Volvo                        | S80 T6                    | 272                             | tr�s longue                    | 5                              | 5                              | noir                          | true                           | 35350                      |
+------------------------------+---------------------------+---------------------------------+--------------------------------+--------------------------------+--------------------------------+-------------------------------+--------------------------------+----------------------------+

--++ Création table externe *****
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- CRÉATION DE LA TABLE EXTERNE POUR LA TABLE M2_DMA_Immatriculations
0: jdbc:hive2://localhost:10000> drop table M2_DMA_Immatriculations_ext;
0: jdbc:hive2://localhost:10000> CREATE EXTERNAL TABLE M2_DMA_Immatriculations_ext (
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
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION 'hdfs:/M2_DMA_Immatriculations' TBLPROPERTIES ("skip.header.line.count" = "1");

-- vérification des données
0: jdbc:hive2://localhost:10000> select * FROM M2_DMA_Immatriculations_ext LIMIT 10;
    --------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------+--------------------------------------+---------------------------------------+-----------------------------------+
| m2_dma_immatriculations_ext.idimmatriculation  | m2_dma_immatriculations_ext.immatriculation  | m2_dma_immatriculations_ext.marque  | m2_dma_immatriculations_ext.nom  | m2_dma_immatriculations_ext.puissance  | m2_dma_immatriculations_ext.longueur  | m2_dma_immatriculations_ext.nbplaces  | m2_dma_immatriculations_ext.nbportes  | m2_dma_immatriculations_ext.couleur  | m2_dma_immatriculations_ext.occasion  | m2_dma_immatriculations_ext.prix  |
+------------------------------------------------+----------------------------------------------+-------------------------------------+----------------------------------+----------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------+--------------------------------------+---------------------------------------+-----------------------------------+
| 662bdd5a987a813713f81c8b                       | 3721 QS 49                                   | Volvo                               | S80 T6                           | 272                                    | tr�s longue                           | 5                                     | 5                                     | noir                                 | false                                 | 50500                             |
+------------------------------------------------+----------------------------------------------+-------------------------------------+----------------------------------+----------------------------------------+---------------------------------------+---------------------------------------+---------------------------------------+--------------------------------------+---------------------------------------+-----------------------------------+

-- CRÉATION DE LA TABLE EXTERNE POUR  M2_DMA_Marketing
0: jdbc:hive2://localhost:10000> drop table M2_DMA_Marketing_ext;
0: jdbc:hive2://localhost:10000> CREATE EXTERNAL TABLE  M2_DMA_Marketing_ext (
    MARKETINGID int,
    AGE int, 
    SEXE string,
    TAUX int,
    SITUATIONFAMILIALE string,
    NBENFANTSACHARGE int,
    VOITURE2 boolean
) STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
"oracle.kv.kvstore" = "kvstore",
"oracle.kv.hosts" = "localhost:5000", 
"oracle.kv.hadoop.hosts" = "localhost/127.0.0.1", 
"oracle.kv.tableName" = "M2_DMA_Marketing");

-- vérification des données
0: jdbc:hive2://localhost:10000> select * from M2_DMA_Marketing_ext LIMIT 10;
+---------------------------+----------------------------+----------------------------+------------------------------------------+----------------------------------------+--------------------------------+
| m2_dma_marketing_ext.age  | m2_dma_marketing_ext.sexe  | m2_dma_marketing_ext.taux  | m2_dma_marketing_ext.situationfamiliale  | m2_dma_marketing_ext.nbenfantsacharge  | m2_dma_marketing_ext.voiture2  |
+---------------------------+----------------------------+----------------------------+------------------------------------------+----------------------------------------+--------------------------------+
| 21                        | F                          | 1396                       | C�libataire                              | 0                                      | false                          |
+---------------------------+----------------------------+----------------------------+------------------------------------------+----------------------------------------+-

-- CRÉATION DE LA TABLE EXTERNE POUR LA TABLE M2_DMA_Clients
0: jdbc:hive2://localhost:10000> drop table M2_DMA_Clients_ext;
0: jdbc:hive2://localhost:10000> CREATE EXTERNAL TABLE  M2_DMA_Clients_ext  (
    ID  string, 
    AGE  int,
    SEXE  string,
    TAUX  int,
    SITUATIONFAMILIALE  string,
    NBENFANTSACHARGE  int,
    VOITURE_2  string,
    IMMATRICULATION  string
    )
    STORED BY "com.mongodb.hadoop.hive.MongoStorageHandler"
    WITH SERDEPROPERTIES(
        'mongo.columns.mapping'='{"ID":"_id", "SITUATIONFAMILIALE":"situationFamiliale", "NBENFANTSACHARGE":"nbEnfantsAcharge" }'
    )
    TBLPROPERTIES ("mongo.uri" = "mongodb://localhost:27017/datatpa.M2_DMA_Clients");

-- vérification des données
0: jdbc:hive2://localhost:10000> select * from M2_DMA_Clients_ext limit 3;
-------------------------+-------------------------------+-------------------------------------+
|   m2_dma_clients_ext.id   | m2_dma_clients_ext.age  | m2_dma_clients_ext.sexe  | m2_dma_clients_ext.taux  | m2_dma_clients_ext.situationfamiliale  | m2_dma_clients_ext.nbenfants  | m2_dma_clients_ext.voiture_2  | m2_dma_clients_ext.immatriculation  |
+---------------------------+-------------------------+--------------------------+--------------------------+----------------------------------------+-------------------------------+-------------------------------+-------------------------------------+
| 662bf6e5154e454d6c1cdb24  | 44                      | M                        | 476                      | En Couple                              | NULL                          | false                         | 3176 TS 67                          |
| 662bf6e5154e454d6c1cdb25  | 20                      | M                        | 422                      | En Couple                              | NULL                          | false                         | 3721 QS 49                          |
| 662bf6e5154e454d6c1cdb26  | 49                      | F                        | 221                      | C�libataire                            | NULL                          | false                         | 9099 UV 26                          |
+---------------------------+-------------------------+--------------------------+--------------------------+----------------------------------------+-------------------------------+-------------------------------+-------------------------------------+



--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++ Création table interne
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Table pour stocker les models de prédiction Marketing
0: jdbc:hive2://localhost:10000> CREATE SEQUENCE model_storage_seq;
0: jdbc:hive2://localhost:10000> drop table model_storage;
0: jdbc:hive2://localhost:10000> CREATE TABLE model_storage (
  id INT,
  model_type STRING,
  model STRING
);

-- Résultats des prédictions Marketing
0: jdbc:hive2://localhost:10000> drop table MARKETING_PREDICT_RESULT;
0: jdbc:hive2://localhost:10000> CREATE TABLE  MARKETING_PREDICT_RESULT (
    id int,
    AGE int, 
    SEXE string,
    TAUX int,
    SITUATIONFAMILIALE string,
    NBENFANTSACHARGE int,
    VOITURE2 boolean,
    Categorie string
);