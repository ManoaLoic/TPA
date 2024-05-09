/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.map.reduce.tpa;

import java.io.IOException;
import java.util.*;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.io.Text;

/**
 *
 * @author Soa
 */
public class REDUCE extends Reducer<Text, Text, Text, Text> {

    @Override
    protected void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
        double totalBonusMalus = 0;
        double totalCo2 = 0;
        double totalCoutEnergie = 0;
        int total = 0;
        double totalBonusMalusMarque = 0;
        double totalCo2Marque = 0;
        double totalCoutEnergieMarque = 0;
        int totalMarque = 0;
        Iterator<Text> i = values.iterator();
        List<String> listeModeleMarqueCatalogue = new ArrayList<String>();
        while (i.hasNext()) {
            Text valeur = i.next();
            String[] data = valeur.toString().split(";/");
            if (data[0].equals("Total")) {
                if (Double.parseDouble(data[4]) > 0) {
                    totalBonusMalus = Double.parseDouble(data[1]);
                    totalCo2 = Double.parseDouble(data[2]);
                    totalCoutEnergie = Double.parseDouble(data[3]);
                    total = Integer.parseInt(data[4]);
                }
            }
            if (data[0].equals("isCataloque")) {
                listeModeleMarqueCatalogue.add(data[1] + "," + data[2] + "," + data[3] + "," + data[4] + "," + data[5] + "," + data[6] + "," + data[7] + "," + data[8]);
            } else if (data[0].equals("isCo2")) {
                try {
                    totalBonusMalusMarque += Double.parseDouble(data[2]);
                    totalCo2Marque += Double.parseDouble(data[3]);
                    totalCoutEnergieMarque += Double.parseDouble(data[4]);
                    totalMarque++;
                } catch (NumberFormatException e) {
                    System.out.println(" erreur " + e.getMessage());
                    continue;
                }
            }
        }
        double moyenneBonusMalus = (totalMarque == 0) ? totalBonusMalus / total : totalBonusMalusMarque / totalMarque;
        double moyenneCo2 = (totalMarque == 0) ? totalCo2 / total : totalCo2Marque / totalMarque;
        double moyenneCoutEnergie = (totalMarque == 0) ? totalCoutEnergie / total : totalCoutEnergieMarque / totalMarque;

        for (String modeleMarqueCatalogue : listeModeleMarqueCatalogue) {
            modeleMarqueCatalogue += "," + String.format("%.2f", moyenneBonusMalus) + "," + String.format("%.2f", moyenneCo2) + "," + String.format("%.2f", moyenneCoutEnergie);
            context.write(key, new Text(modeleMarqueCatalogue));
        }
    }
}
