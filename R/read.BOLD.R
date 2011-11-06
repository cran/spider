read.BOLD <- function(IDs){
	#Split IDs into batches of 300....
	numVec <- 1:length(IDs)
	top <- ceiling(length(numVec)/300)
	breaks <- seq(1, by=300, length.out=top+1)
	nums <- findInterval(numVec, breaks)
	#Retrieve the sequences
	allSeqs <- list()
	for(i in 1:top){
		urlID <- paste(IDs[which(nums==i)], collapse=",")
		URL <- paste("http://services.boldsystems.org/eFetch.php?record_type=full&id_type=processid&ids=(", urlID, ")&return_type=text", sep="")
		res <- scan(file = URL, what = "", sep = "\n", quiet = TRUE)
		res <- strsplit(res, "\\t")
		recID <- sapply(res, function(x) x[1])[-1]
		species <- sapply(res, function(x) x[24])[-1]
		species <- gsub(" ", "_", species)
		nam <- paste(recID, species, sep="|")
		seqs <- as.DNAbin(sapply(res, function(x) tolower(unlist(strsplit(x[55], split=""))))[-1])
		names(seqs) <- nam
		attr(seqs, "species") <- species
		attr(seqs, "accession_num") <- recID
		allSeqs[[i]] <- seqs
	}
	collSeqs <- do.call(c, allSeqs)
	attr(collSeqs, "species") <- unlist(lapply(allSeqs, function(x) attr(x, "species")))
	attr(collSeqs, "accession_num") <- unlist(lapply(allSeqs, function(x) attr(x, "accession_num")))
	attr(collSeqs, "gene") <- rep("cytochrome oxidase I (COI)", length(collSeqs))
	collSeqs
}