library("arules")
library(dplyr)

set.seed(101)
orders <- data.frame(
  transactionID = sample(1:500, 1000, replace=T),
  item = paste("item", sample(1:50, 1000, replace=T),sep = "")
)

# Using a CSV ####
# Create a temporary directory
dir.create(path = "tmp", showWarnings = FALSE)

# Write our data.frame to a csv
write.csv(orders, "./tmp/tall_transactions.csv")

# Read that csv back in
order_trans <- read.transactions(
  file = "./tmp/tall_transactions.csv",
  format = "single",
  sep = ",",
  cols=c("transactionID","item"),
  rm.duplicates = T,
  header = T
)
summary(order_trans)

# Using split and coercion ####
# using split(what, by) we're splitting items by transactionID
order_trans2 <- as(split(orders[, "item"], orders[, "transactionID"]), "transactions")
summary(order_trans2)
