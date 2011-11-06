chaoHaplo <- function(DNAbin){
	haplo <- haplotype(DNAbin)
	i <- if(length(grep("[-|?|r|y|m|k|w|s|b|d|h|v|n]", DNAbin)) > 0) message("There are missing or ambiguous data, which may cause an overestimation of the number of haplotypes")
	nums <- sapply(attr(haplo, "index"), length)
	h <- length(nums)
	s <- length(which(nums == 1))
	d <- length(which(nums == 2))
	if(d > 0) est <- h + ((s^2)/(2 * d)) else est <- h + ((s * (s - 1))/2)
	ceiling(est)
}
	

