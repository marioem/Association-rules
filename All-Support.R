data("Adult")
fsets <- eclat(Adult, parameter = list(support = 0.05), control = list(verbose=FALSE))
singleItems <- fsets[size(items(fsets)) == 1]

## Get the col numbers we have support for
singleSupport <- quality(singleItems)$support 
names(singleSupport) <- unlist(LIST(items(singleItems), decode = FALSE))
head(singleSupport, n = 5)

itemsetList <- LIST(items(fsets), decode = FALSE) 
allConfidence <- quality(fsets)$support / sapply(itemsetList, function(x) max(singleSupport[as.character(x)]))
quality(fsets) <- cbind(quality(fsets), allConfidence)
summary(fsets)
