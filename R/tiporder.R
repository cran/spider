tiporder <- function(phy){
	nn <- length(phy$tip.label) #How many tips on the tree?
	edge <- phy$edge
	nums <- rev(edge[edge[,2] %in% 1:nn, 2])
	phy$tip.label[nums]
}
