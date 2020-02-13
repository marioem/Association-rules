# Load the libraries
library(arules)
library(arulesViz)
library(datasets)

# Load the data set
data(Groceries)
summary(Groceries)
transactionInfo(Groceries)  # no info
table(itemInfo(Groceries)[["level1"]])
itemsetInfo(Groceries)      # empty

# Create an item frequency plot for the top 20 items
itemFrequencyPlot(Groceries,topN=20,type="absolute", cex.names = 0.7)
inspect(Groceries[is.maximal(Groceries)][1:5])

# Get the rules
rules <- apriori(Groceries, parameter = list(supp = 0.001, conf = 0.8))
# Rules length might be restricted
# rules <- apriori(Groceries, parameter = list(supp = 0.001, conf = 0.8,maxlen=3))

# Show the top 5 rules, but only 2 digits
options(digits=2)
inspect(rules[1:5])

summary(rules)
plot(rules[1:20], method = "grouped")

rules<-sort(rules, by="confidence", decreasing=TRUE)
inspect(rules[1:5])
plot(rules)
inspect(rules[is.closed(generatingItemsets(rules))][1:5])

rules.sub <- subset(rules, subset = rhs %pin% "whole" & lift < 3.5)
length(rules.sub)
inspect(rules.sub[1:5])

# # Eliminating repeating rules
rules.pruned <- rules[!is.redundant(rules)]
rules<-rules.pruned
summary(rules)
plot(rules)
plotly_arules(rules)

# # Targeting items

# What are customers likely to buy before buying whole milk

rules<-apriori(data=Groceries, parameter=list(supp=0.001,conf = 0.08), 
               appearance = list(default="lhs",rhs="whole milk"),
               control = list(verbose=F))
rules<-sort(rules, decreasing=TRUE,by="confidence")
inspect(rules[1:5])
plot(rules)

# What are customers likely to buy if they purchase whole milk?

rules<-apriori(data=Groceries, parameter=list(supp=0.001,conf = 0.15,minlen=2), 
               appearance = list(default="rhs",lhs="whole milk"),
               control = list(verbose=F))
rules<-sort(rules, decreasing=TRUE,by="confidence")
inspect(rules[1:5])
inspect(items(rules[1:5]))
plot(rules)

library(tcltk)
plot(rules)
plot(rules,method="graph",engine='interactive',shading=NA)
plot(rules,method="graph",engine = "htmlwidget") # preferred method, no need for tcl/tk
plot(rules, method="paracoord")

# Which transactions is given rule mined from?

inspect(rules)
# rule 5 has count of 416
length(subset(Groceries, subset = items %ain% unlist(LIST(items(rules[5])))))
# [1] 11 - that's right!

inspect(subset(Groceries, subset = items %ain% unlist(LIST(items(rules[5])))))
