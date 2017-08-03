#!/bin/bash

if [ $# -ne 4 ]; then
    echo "Usage: ./select_N_examples.sh [neg_features.rdat] [pos_features.rdat] [neg_proportion] [outfile.rdat]"
    echo "Creates a new RDat file with NUM_EXAMPLES examples randomly selected from INPUT.RDat."
    exit 1
fi

input_file=$1
pos_features=$2
neg_proportion=$3
output_file=$4

pos_examples=$((`wc -l $pos_features | awk '{print $1}'` - 1))
num_examples=$(($pos_examples*neg_proportion))
total_examples=$((`wc -l $input_file | awk '{print $1}'` - 1))


if [ $total_examples -lt $num_examples ]; then
    echo "Not enough examples in file. Asking to select $num_examples, but file only has $total_examples examples."
    exit 1
fi

# add the header line first
head -n1 $input_file > $output_file

# select everything but the first header line, shuffle, then take last NUM_EXAMPLES lines
tail -n+2 $input_file | shuf | tail -n$num_examples >> $output_file

