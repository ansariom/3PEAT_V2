#!/bin/bash

features_pos=$1
peaks_neg=$2
negative_proportion=$3
negative_draw_start=$4
negative_draw_stop=$5
pseudoCounts=$6
roe_fwd=$7
roe_rev=$8
neg_seqs=$9
pwm=${10}
outfile=${11}
exonic_whole_seqs=${12}
ncpu=${13}

outfile_temp=$outfile.tmp

ndraws=`software/calculate_draws.sh $features_pos $peaks_neg $negative_proportion`


java -Xms10G -Xmx100G -jar software/tfbs_scan.jar GenFeatures --pos "Rand $ndraws $negative_draw_start $negative_draw_stop" --pseudoCounts $pseudoCounts -n $ncpu $roe_fwd $roe_rev $neg_seqs $pwm $outfile_temp

pos_examples=$((`wc -l $features_pos | awk '{print $1}'` - 1))
num_examples=$(($pos_examples*$negative_proportion))

neg_features1=$outfile.1
software/select_N_examples.sh $outfile_temp $num_examples $neg_features1

rm -f $outfile_temp

## Generate negative examples (1 neg example per sequence) from  exonic regions (for train) and whole genome ( for test )

java -Xms10G -Xmx100G -jar software/tfbs_scan.jar GenFeatures --pseudoCounts $pseudoCounts -n $ncpu $roe_fwd $roe_rev $exonic_whole_seqs $pwm $outfile_temp

neg_features2=$outfile.2
software/select_N_examples.sh $outfile_temp $pos_examples $neg_features2
rm -f $outfile_temp

cat $neg_features1 > $outfile
tail -n+2 $neg_features2 >> $outfile

rm -f $neg_features1 $neg_features2



