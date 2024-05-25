[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -mkdir /M2_DMA_New_Catalogue



hadoop jar /vagrant/TPA/MAP-REDUCE-TPA-1.0-SNAPSHOT.jar com.mycompany.map.reduce.tpa.MAPREDUCETPA /M2_DMA_Catalogue/Catalogue.csv /CO2/CO2.csv /M2_DMA_New_Catalogue/newCatalogue

[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -ls /M2_DMA_New_Catalogue

hadoop fs -cat /M2_DMA_New_Catalogue/newCatalogue/* | sed 's/\t/,/g' > /vagrant/TPA/data/newCatalogue.csv
*/

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
    bonusmalus double,
co2 double,
coutEnergie double
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE LOCATION 'hdfs:/M2_DMA_New_Catalogue/newCatalogue';
0: jdbc:hive2://localhost:10000>select * from M2_DMA_Catalogue_EXT limit 10 ;