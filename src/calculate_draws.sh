#!/bin/bash

pos_feature_file=$1
neg_feature_file=$2
neg_proportion=$3

pos_nexamples=$((`wc -l $pos_feature_file | awk '{print $1}'` - 1))
neg_nexamples=$((`wc -l $neg_feature_file | awk '{print $1}'` - 1))

ndraws=$(($pos_nexamples*$neg_proportion/$neg_nexamples))
let "ndraws=ndraws+1"

echo $ndraws
