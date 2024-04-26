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

-- table externe Hive CATALOGUE
0: jdbc:hive2://localhost:10000>drop table CATALOGUE;

0: jdbc:hive2://localhost:10000>create external table CATALOGUE (
  CatalogueId int, 
  Marque string, 
  NOM string, 
  Puissance integer,
  Longueur string,
  NbPlaces  integer,
  NbPortes  integer,
  Couleur string,
  Occasion boolean,
  Prix integer
)STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES
("oracle.kv.kvstore" = "kvstore",
"oracle.kv.hosts" = "localhost:5000", 
"oracle.kv.hadoop.hosts" = "localhost/127.0.0.1", 
"oracle.kv.tableName" = "CATALOGUE");

-- vérifications

0: jdbc:hive2://localhost:10000>select * from CATALOGUE ;

