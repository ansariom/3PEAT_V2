#!/usr/bin/env Rscript

split_data <- function(input, percent_train) {
  randomized_features_diffs_wide <- input[order(runif(nrow(input))), ]
  train_index <- as.integer(percent_train * nrow(randomized_features_diffs_wide))
  train_features_diffs_wide <- randomized_features_diffs_wide[seq(1, train_index), ]
  final_test_features_diffs_wide <- randomized_features_diffs_wide[seq(train_index + 1, nrow(randomized_features_diffs_wide)), ]
  ret_list <- list(train_set = train_features_diffs_wide, final_test = final_test_features_diffs_wide)
  return(ret_list)
}

library(data.table)
args <- commandArgs(trailingOnly = TRUE)
input_features <- args[1]
train_outfile <- args[2]
test_outfile <- args[3]

all_features <- read.table(input_features, header = T, sep = "\t", check.names = F, row.names = 1)


ret_list = split_data(all_features, percent_train = 0.8)

write.table(ret_list$train_set, file = train_outfile, quote = F, row.names = T, col.names = T, sep = "\t")
write.table(ret_list$final_test, file = test_outfile, quote = F, row.names = T, col.names = T, sep = "\t")
