--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++ Chargement dans Oracle NoSQL
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Création de la variable d'environnement du projet A CHANGER PAR RAPPORT AU VOTRE
export MYTPHOMEORACLE=/vagrant/TPA
-- Compilation de la classe chargeur
javac -g -cp $KVHOME/lib/kvclient.jar:$MYTPHOMEORACLE $MYTPHOMEORACLE/chargeur/Marketing.java
-- Execution de l'import
java -Xmx256m -Xms256m  -cp $KVHOME/lib/kvclient.jar:$MYTPHOMEORACLE chargeur.Marketing
-- Accéder kvStore
java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host localhost
-- Connexion à la base
kv -> connect store -name kvstore
-- Vérification des données
kv -> get table -name M2_DMA_Marketing