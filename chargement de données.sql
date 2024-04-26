--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++ Chargement dans MongoDB
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++ Chargement dans Oracle NoSQL
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Création de la variable d'environnement du projet A CHANGER PAR RAPPORT AU VOTRE
export MYTPHOME=/vagrant/Delivrance_TPA/TPA
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