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
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;

import java.util.StringTokenizer;
import java.util.ArrayList;

/**
 * Cette classe va servir à importer le fichier Marketing.CSV dans Kv Store
 */

public class Marketing {
	private static final String MY_TP_PATH = "/vagrant";
	private static final String AUTOMOBILE_FOLDER = "/TPA";

	private final KVStore store;
	private final String tabMarketing = "M2_DMA_Marketing";

	public static void main(String args[]) {
		try {
			Marketing arb = new Marketing(args);
			arb.dropTableMarketing();
			arb.createTableMarketing();
			arb.loadClientMarketingFromFile(MY_TP_PATH + AUTOMOBILE_FOLDER + "/data/Marketing.csv");
		} catch (RuntimeException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Parses command line args and opens the KVStore.
	 */
	Marketing(String[] argv) {

		String storeName = "kvstore";
		String hostName = "localhost";
		String hostPort = "5000";

		final int nArgs = argv.length;
		int argc = 0;
		store = KVStoreFactory.getStore(new KVStoreConfig(storeName, hostName + ":" + hostPort));
	}

	/**
	 * Méthode de suppression de la table Marketing.
	 */
	public void dropTableMarketing() {
		String statement = null;

		statement = "drop table " + tabMarketing;
		executeDDL(statement);
	}

	/**
	 * Méthode de création de la table Marketing.
	 */

	public void createTableMarketing() {
		String statement = null;
		statement = "Create table " + tabMarketing + "("
				+ "MARKETINGID INTEGER,"
				+ "AGE INTEGER,"
				+ "SEXE STRING,"
				+ "TAUX INTEGER,"
				+ "SITUATIONFAMILIALE STRING,"
				+ "NBENFANTSACHARGE INTEGER,"
				+ "VOITURE2 BOOLEAN,"
				+ "PRIMARY KEY (MARKETINGID))";
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
	 * Cette méthode insère une nouvelle ligne dans la table marketing
	 */

	private void insertAMarketingRow(int marketingId, int age, String sexe, int taux, String situationFamiliale,
			int nbEnfantsAcharge, boolean voiture2) {
		StatementResult result = null;
		String statement = null;
		System.out.println(
				"********************************** Dans : insertAMarketingRow *********************************");

		try {

			TableAPI tableH = store.getTableAPI();
			Table tableCriteres = tableH.getTable(tabMarketing);
			Row critereRow = tableCriteres.createRow();

			critereRow.put("MARKETINGID", marketingId);
			critereRow.put("age", age);
			critereRow.put("sexe", sexe);
			critereRow.put("taux", taux);
			critereRow.put("situationFamiliale", situationFamiliale);
			critereRow.put("nbEnfantsAcharge", nbEnfantsAcharge);
			critereRow.put("VOITURE2", voiture2);

			tableH.put(critereRow, null, null);
		} catch (IllegalArgumentException e) {
			System.out.println("Invalid statement:\n" + e.getMessage());
		} catch (FaultException e) {
			System.out.println("Statement couldn't be executed, please retry: " + e);
		}

	}

	/**
	 * void loadClientMarketingFromFile(String MarketingDataFileName)
	 * cette methodes permet de charger les véhicules depuis le fichier
	 * appelé Marketing.csv
	 */
	void loadClientMarketingFromFile(String MarketingDataFileName) {
		InputStreamReader ipsr;
		BufferedReader br = null;
		InputStream ips;

		String ligne;
		System.out.println(
				"********************************** Dans : loadMarketingDataFromFile *********************************");

		try {
			ips = new FileInputStream(MarketingDataFileName);
			ipsr = new InputStreamReader(ips);
			br = new BufferedReader(ipsr);

			br.readLine(); // On enlève l'entete

			int marketingId = 1;
			while ((ligne = br.readLine()) != null) {

				ArrayList<String> MarketingRecord = new ArrayList<String>();
				StringTokenizer val = new StringTokenizer(ligne, ",");
				while (val.hasMoreTokens()) {
					MarketingRecord.add(val.nextToken().toString());
				}

				int age = Integer.valueOf(MarketingRecord.get(0));
				String sexe = MarketingRecord.get(1);
				int taux = Integer.valueOf(MarketingRecord.get(2));
				String situationFamiliale = MarketingRecord.get(3);
				int nbEnfantsAcharge = Integer.valueOf(MarketingRecord.get(4));
				boolean voiture2 = Boolean.valueOf(MarketingRecord.get(5));

				System.out.println("age = " + age + ", " + "sexe = " + sexe + ", " + "taux = " + taux
						+ ", " + "situationFamiliale = " + situationFamiliale + ", " + "nbEnfantsAcharge = "
						+ nbEnfantsAcharge + ", " + "voiture2 = "
						+ voiture2);
				// Ajout du véhicule dans KVStore
				this.insertAMarketingRow(marketingId, age, sexe, taux, situationFamiliale, nbEnfantsAcharge, voiture2);
				marketingId++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}