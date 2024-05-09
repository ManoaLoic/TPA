/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.map.reduce.tpa;

import java.io.IOException;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

/**
 *
 * @author rakot
 */
public class MAP extends Mapper<LongWritable, Text, Text, Text> {

    private Text value = new Text();
    private Text marque = new Text();
    private double sommeCO2 = 0;
    private double sommeBonusMalus = 0;
    private double sommeCout = 0;
    private int indice = 0;

    @Override
    protected void map(LongWritable cle, Text valeur, Context context) throws IOException, InterruptedException {
        Configuration conf = context.getConfiguration();
        if (cle.get() > 0) {
            String[] data = valeur.toString().split(",");
            if (!valeur.toString().contains("€") || data.length == 9) {
                marque.set(data[0].toUpperCase());
                value.set("isCataloque;/" + data[1].toUpperCase() + ";/" + data[2] + ";/" + data[3] + ";/" + data[4] + ";/" + data[5] + ";/" + data[6] + ";/" + data[7] + ";/" + data[8]);
            } else if(valeur.toString().contains("€") || data.length == 5) {
                marque.set(data[1].split(" ")[0]);
                String bonusMalus = clearBonusMalus(data[2]);
                String co2 = data[3].replaceAll("[^\\d.-]", "");
                String coutEnergie = data[4].replaceAll("[^\\d.-]", "");
                value.set("isCo2;/" + data[1].split(" ")[1].toUpperCase() + ";/" + bonusMalus + ";/" + co2 + ";/" + coutEnergie);
                this.indice++;
                this.sommeCO2= Double.parseDouble(co2);
                this.sommeCout += Double.parseDouble(coutEnergie);
                double valBonusMalus = Double.parseDouble(bonusMalus);
                this.sommeBonusMalus += valBonusMalus;
            }else{
                System.out.println("Ligne incorrect!");
            }
            context.write(marque, value);
        }
    }

    public static String clearBonusMalus(String val) {
        String noNumerique=val.replaceAll("[^\\d.-]", "");
        if (noNumerique.equals("") || noNumerique.equals("-")) {
            return "0";
        }
        val = val.split("€")[0];
        val = val.replaceAll("[^\\d.-]", "");
        return val;
    }
    
    @Override
    public void cleanup(Context context) throws IOException, InterruptedException {
        String rep = "Total;/" + this.sommeBonusMalus + ";/" + this.sommeCout + ";/" + this.sommeCO2 + ";/" + this.indice;
        context.write(new Text("TOTAL"), new Text(rep));
    }
}
