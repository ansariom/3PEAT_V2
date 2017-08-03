#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: ./select_N_examples.sh [INPUT.RDat] [NUM_EXAMPLES] [OUTPUT.RDat]"
    echo "Creates a new RDat file with NUM_EXAMPLES examples randomly selected from INPUT.RDat."
    exit 1
fi

input_file=$1
num_examples=$2
output_file=$3

total_examples=$((`wc -l $input_file | awk '{print $1}'` - 1))

if [ $total_examples -lt $num_examples ]; then
    echo "Not enough examples in file. Asking to select $num_examples, but file only has $total_examples examples."
    exit 1
fi

# add the header line first
head -n1 $input_file > $output_file

# select everything but the first header line, shuffle, then take last NUM_EXAMPLES lines
tail -n+2 $input_file | shuf | tail -n$num_examples >> $output_file

