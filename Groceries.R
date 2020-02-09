# Load the libraries
library(arules)
library(arulesViz)
library(datasets)

# Load the data set
data(Groceries)

# Create an item frequency plot for the top 20 items
itemFrequencyPlot(Groceries,topN=20,type="absolute")

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

# # Eliminating repeating rules
subset.matrix <- is.subset(rules, rules)
subset.matrix[lower.tri(subset.matrix, diag=T)] <- F # Is this matrix really symmetric to allow for nulling lower triangle?
redundant <- colSums(subset.matrix, na.rm=T) >= 1    # >= is used probably because only half of the matrix is looked into.
                                                     # and every 1 there indicates a duplicaded rule
rules.pruned <- rules[!redundant]
rules<-rules.pruned
summary(rules)
plot(rules)
plotly_arules(rules)

#
# # Or alternative approach
# subset.rules <- which(colSums(is.subset(rules, rules)) >= 1) # get subset rules in vector
# rules.pruned <- rules[-subset.rules]
# summary(rules.pruned)
# plot(rules.pruned)

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
plot(rules)

library(tcltk)
plot(rules)
plot(rules,method="graph",engine='interactive',shading=NA)
plot(rules,method="graph",engine = "htmlwidget") # preferred method, no need for tcl/tk
plot(rules, method="paracoord")
