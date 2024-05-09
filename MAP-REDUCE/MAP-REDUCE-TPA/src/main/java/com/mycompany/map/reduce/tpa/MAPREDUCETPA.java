/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */
package com.mycompany.map.reduce.tpa;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;
import java.io.IOException;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;


/**
 *
 * @author rakot
 */
public class MAPREDUCETPA {
    public static void main(String[] args) throws IOException, InterruptedException, ClassNotFoundException {
        System.out.println("Traitement du fichier CO2 et Catalogue");
        Configuration conf = new Configuration();
        conf.set("mapred.textoutputformat.separator", ";/");
        Job job = Job.getInstance(conf, "Traitement du fichier CO2 et Catalogue");
        String[] ourArgs = new GenericOptionsParser(conf, args).getRemainingArgs();

        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(Text.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);

        job.setMapperClass(MAP.class);
        job.setReducerClass(REDUCE.class);

        FileInputFormat.addInputPath(job, new Path(ourArgs[0]));
        FileInputFormat.addInputPath(job, new Path(ourArgs[1]));
        FileOutputFormat.setOutputPath(job, new Path(ourArgs[2]));

        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
