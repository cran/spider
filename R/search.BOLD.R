search.BOLD <- 
function(taxon){
	taxon <- paste(taxon, collapse=",")
	URL <- paste("http://services.boldsystems.org/eSearch.php?taxon_inc=(", taxon, ")&return_type=text", sep="")
	res <- scan(file = URL, what = "", sep = "\n", quiet = TRUE)
	IDs <- sapply(strsplit(res, "\\t"), function(x) x[1])[-1]
	if(length(IDs) == 0) stop("No taxa with that name found on BOLD") else IDs
}