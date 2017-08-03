#!/bin/bash

pos_features=$1
peak_file=$2
neg_tags=$3
outfile=$4
nucs_up=$5

if [ $# -lt 5 ]; then
	echo "filter... [pos_features.rdat] [peak_file] [neg_tags] [outfile] [nucs_upstream]"
	exit
fi
pos_tss_ids=tmp1.txt
pos_neg_tags=tmp2.txt

cut -f1 $pos_features > $pos_tss_ids
software/merge_two_sets.R $pos_tss_ids $neg_tags $pos_neg_tags V1 V1 FALSE
rm -f $pos_tss_ids

tmp_peaks=$peak_file.tmp
cat $peak_file | awk -v u=$nucs_up -F "," '{if (NR == 1) {print $0",id"} else { start = $6-u; print $0","$10"_"$1"_"start"_0"}}' > $tmp_peaks

software/filter_peaks_for_negatives.R $tmp_peaks $pos_neg_tags $outfile

rm -f $pos_neg_tags $tmp_peaks

