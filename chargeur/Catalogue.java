package chargeur;

import oracle.kv.KVStore;
import java.util.List;
import java.util.Iterator;
import oracle.kv.KVStoreConfig;
import oracle.kv.KVStoreFactory;
import oracle.kv.FaultException;
import oracle.kv.StatementResult;
import oracle.kv.table.TableAPI;
import oracle.kv.table.Table;
import oracle.kv.table.Row;
import oracle.kv.table.PrimaryKey;
import oracle.kv.ConsistencyException;
import oracle.kv.RequestTimeoutException;
import java.lang.Integer;
import oracle.kv.table.TableIterator;
import oracle.kv.table.EnumValue;
import java.io.File;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;

import java.util.StringTokenizer;
import java.util.ArrayList;
import java.util.List;

/**
 * Cette classe va servir à importer le fichier Catalogue.CSV dans Kv Store
 */

public class Catalogue {
	private static final String MY_TP_PATH = "/vagrant";
	private static final String AUTOMOBILE_FOLDER = "/Delivrance_TPA/TPA";

	private final KVStore store;
	private final String tabCatalogue = "CATALOGUE";

	public static void main(String args[]) {
		try {
			Catalogue arb = new Catalogue(args);
			arb.dropTableCatalogue();
			arb.createTableCatalogue();
			arb.loadClientCatalogueFromFile(MY_TP_PATH + AUTOMOBILE_FOLDER + "/data/Catalogue.csv");
		} catch (RuntimeException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Parses command line args and opens the KVStore.
	 */
	Catalogue(String[] argv) {

		String storeName = "kvstore";
		String hostName = "localhost";
		String hostPort = "5000";

		final int nArgs = argv.length;
		int argc = 0;
		store = KVStoreFactory.getStore(new KVStoreConfig(storeName, hostName + ":" + hostPort));
	}

	/**
	 * Méthode de suppression de la table Catalogue.
	 */
	public void dropTableCatalogue() {
		String statement = null;

		statement = "drop table " + tabCatalogue;
		executeDDL(statement);
	}

	/**
	 * Méthode de création de la table client.
	 */

	public void createTableCatalogue() {
		String statement = null;
		statement = "create table " + tabCatalogue + " ("
				+ "CatalogueId INTEGER,"
				+ "Marque STRING,"
				+ "NOM STRING,"
				+ "Puissance INTEGER,"
				+ "Longueur STRING,"
				+ "NbPlaces INTEGER,"
				+ "NbPortes INTEGER,"
				+ "Couleur STRING,"
				+ "Occasion BOOLEAN,"
				+ "Prix INTEGER,"
				+ "PRIMARY KEY(CatalogueId))";
		executeDDL(statement);
	}

	/**
	 * Méthode générique pour executer les commandes DDL
	 */
	public void executeDDL(String statement) {
		TableAPI tableAPI = store.getTableAPI();
		StatementResult result = null;

		System.out.println("****** Dans : executeDDL ********");
		try {
			/*
			 * Add a table to the database.
			 * Execute this statement asynchronously.
			 */

			result = store.executeSync(statement);
			displayResult(result, statement);
		} catch (IllegalArgumentException e) {
			System.out.println("Invalid statement:\n" + e.getMessage());
		} catch (FaultException e) {
			System.out.println("Statement couldn't be executed, please retry: " + e);
		}
	}

	/**
	 * Affichage du résultat pour les commandes DDL (CREATE, ALTER, DROP)
	 */

	private void displayResult(StatementResult result, String statement) {
		System.out.println("===========================");
		if (result.isSuccessful()) {
			System.out.println("Statement was successful:\n\t" +
					statement);
			System.out.println("Results:\n\t" + result.getInfo());
		} else if (result.isCancelled()) {
			System.out.println("Statement was cancelled:\n\t" +
					statement);
		} else {
			/*
			 * statement was not successful: may be in error, or may still
			 * be in progress.
			 */
			if (result.isDone()) {
				System.out.println("Statement failed:\n\t" + statement);
				System.out.println("Problem:\n\t" +
						result.getErrorMessage());
			} else {

				System.out.println("Statement in progress:\n\t" +
						statement);
				System.out.println("Status:\n\t" + result.getInfo());
			}
		}
	}

	/**
	 * Cette méthode insère une nouvelle ligne dans la table CATALOGUE
	 */

	private void insertACatalogueRow(int catalogueId, String Marque, String NOM, int Puissance, String Longueur, int NbPlaces,
			int NbPortes, String Couleur, boolean Occasion, int Prix) {
		StatementResult result = null;
		String statement = null;
		System.out.println(
				"********************************** Dans : insertACatalogueRow *********************************");

		try {

			TableAPI tableH = store.getTableAPI();
			Table tableCriteres = tableH.getTable(tabCatalogue);
			Row critereRow = tableCriteres.createRow();

			critereRow.put("catalogueId", catalogueId);
			critereRow.put("Marque", Marque);
			critereRow.put("NOM", NOM);
			critereRow.put("Puissance", Puissance);
			critereRow.put("Longueur", Longueur);
			critereRow.put("NbPlaces", NbPlaces);
			critereRow.put("NbPortes", NbPortes);
			critereRow.put("Couleur", Couleur);
			critereRow.put("Occasion", Occasion);
			critereRow.put("Prix", Prix);

			tableH.put(critereRow, null, null);
		} catch (IllegalArgumentException e) {
			System.out.println("Invalid statement:\n" + e.getMessage());
		} catch (FaultException e) {
			System.out.println("Statement couldn't be executed, please retry: " + e);
		}

	}

	/**
	 * void loadClientCatalogueFromFile(String catalogueDataFileName)
	 * cette methodes permet de charger les véhicules depuis le fichier
	 * appelé Catalogue.csv
	 */
	void loadClientCatalogueFromFile(String catalogueDataFileName) {
		InputStreamReader ipsr;
		BufferedReader br = null;
		InputStream ips;

		String ligne;
		System.out.println(
				"********************************** Dans : loadCatalogueDataFromFile *********************************");

		try {
			ips = new FileInputStream(catalogueDataFileName);
			ipsr = new InputStreamReader(ips);
			br = new BufferedReader(ipsr);

			br.readLine(); // On enlève l'entete

			int categorieId = 1;
			while ((ligne = br.readLine()) != null) {

				ArrayList<String> catalogueRecord = new ArrayList<String>();
				StringTokenizer val = new StringTokenizer(ligne, ",");
				while (val.hasMoreTokens()) {
					catalogueRecord.add(val.nextToken().toString());
				}

				String Marque = catalogueRecord.get(0);
				String NOM = catalogueRecord.get(1);
				int Puissance = Integer.parseInt(catalogueRecord.get(2));
				String Longueur = catalogueRecord.get(3);
				int NbPlaces = Integer.parseInt(catalogueRecord.get(4));
				int NbPortes = Integer.parseInt(catalogueRecord.get(5));
				String Couleur = catalogueRecord.get(6);
				boolean Occasion = Boolean.parseBoolean(catalogueRecord.get(7));
				int Prix = Integer.parseInt(catalogueRecord.get(8));

				System.out.println("Marque = " + Marque + ", " + "NOM = " + NOM + ", " + "Puissance = " + Puissance
						+ ", " + "Longueur = " + Longueur + ", " + "NbPlaces = " + NbPlaces + ", " + "NbPortes = "
						+ NbPortes + ", " + "Couleur = " + Couleur + ", " + "Occasion = " + Occasion + ", " + "Prix = "
						+ Prix + "");
				// Ajout du véhicule dans KVStore
				this.insertACatalogueRow(categorieId, Marque, NOM, Puissance, Longueur, NbPlaces, NbPortes, Couleur, Occasion, Prix);
				categorieId++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}