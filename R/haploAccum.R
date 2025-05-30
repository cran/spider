#' Haplotype accumulation curves
#' 
#' \code{haploAccum} identifies the different haplotypes represented in a set
#' of DNA sequences and performs the calculations for plotting haplotype
#' accumulations curves (see \code{\link{plot.haploAccum}}).
#' 
#' Haplotype accumulation curves can be used to assess haplotype diversity in
#' an area or compare different populations, or to evaluate sampling effort.
#' \code{``random''} calculates the mean accumulated number of haplotypes and
#' its standard deviation through random permutations (subsampling of
#' sequences), similar to the method to produce rarefaction curves (Gotelli and
#' Colwell 2001).
#' 
#' @param DNAbin A set of DNA sequences in an object of class `DNAbin'.
#' @param method Method for haplotype accumulation. Method \code{"collector"}
#' enters the sequences in the order that they appear in the sequence alignment
#' and \code{"random"} adds the sequences in a random order.
#' @param permutations Number of permutations for method \code{"random"}.
#' @param ... Other parameters to functions.
#' @return An object of class `haploAccum' with items: \item{call}{Function
#' call.} \item{method}{Method for accumulation.} \item{sequences}{Number of
#' analysed sequences.} \item{n.haplotypes}{Accumulated number of haplotypes
#' corresponding to each number of sequences.} \item{sd}{The standard deviation
#' of the haplotype accumulation curve. Estimated through permutations for
#' \code{method = "random"} and \code{NULL} for \code{method = "collector"}.}
#' \item{perm}{Results of the permutations for \code{method = "random"}.}
#' @note This function is based on the functions \code{haplotype} (E. Paradis)
#' from the package 'pegas' and \code{specaccum} (R. Kindt) from the
#' package'vegan'. Missing or ambiguous data will be detected and indicated by
#' a warning, as they may cause an overestimation of the number of haplotypes.
#' @author Jagoba Malumbres-Olarte <j.malumbres.olarte@@gmail.com>.
#' @references Gotelli, N.J. & Colwell, R.K. (2001). Quantifying biodiversity:
#' procedures and pitfalls in measurement and comparison of species richness.
#' _Ecology Letters_ *4*, 379--391.
#' @keywords Sampling
#' @examples
#' 
#' data(dolomedes)
#' #Generate multiple haplotypes
#' doloHaplo <- dolomedes[sample(37, size = 200, replace = TRUE), ] 
#' dolocurv <- haploAccum(doloHaplo, method = "random", permutations = 100)
#' dolocurv
#' graphics::plot(dolocurv)
#' 
#' @importFrom utils as.roman
#' @importFrom stats sd
#' @importFrom graphics plot
#' @export haploAccum
haploAccum<- function (DNAbin, method = "random", permutations = 100, ...){

    if (is.list(DNAbin)) DNAbin <- as.matrix(DNAbin)	# If seq DNAbin is list, turn it matrix
    i <- (length(grep("[-|?|r|y|m|k|w|s|b|d|h|v|n]", DNAbin))>0)
        message("There are missing or ambiguous data, which may cause an overestimation of the number of haplotypes")

    seq_names<-as.vector(rownames(DNAbin))	# Create a vector of seq name
    nms.dat <- deparse(substitute(DNAbin))		# Create a character object from seq DNAbina
    rownames(DNAbin) <- NULL				# Remove row names
    y <- apply(DNAbin, 1, rawToChar)		# Translate sequences
    n <- length(y)				# Number of sequences
    keep <- nhaplo <- 1L		# To remove?
    no <- list(1L)			# To remove?
    for (i in 2:n) {
        already.seen <- FALSE
        j <- 1L
        while (j <= nhaplo) {
            if (y[i] == y[keep[j]]) {
                no[[j]] <- c(no[[j]], i)
                already.seen <- TRUE
                break
            }
            j <- j + 1L
        }
        if (!already.seen) {
            keep <- c(keep, i)
            nhaplo <- nhaplo + 1L
            no[[nhaplo]] <- i
        }
    }
    obj <- DNAbin[keep, ]
    rownames(obj) <- as.character(as.roman(1:length(keep)))
    class(obj) <- c("haplotype", "DNAbin")
    attr(obj, "index") <- no
    attr(obj, "from") <- nms.dat
    n_haplo<-length(no)
    z<- matrix(nrow=length(seq_names),ncol=n_haplo,0)
    colnames(z)<-as.vector(unlist(attributes(obj)$dimnames[1]))
    rownames(z)<-seq_names
    for (i in c(1:n_haplo)){
	for (j in c(1:length(as.vector(unlist(attributes(obj)$index[i]))))){
		z[unlist(attributes(obj)$index[i])[j],i]<- 1
	}
    }
    z <- z[, colSums(z) > 0, drop=FALSE]
    n <- nrow(z)
    h <- ncol(z)
    sequences <- 1:n
    if (h == 1) {
	  z <- t(z)
        n <- nrow(z)
        h <- ncol(z)
    }
    accumulator <- function(x, sequences) {
        rowSums(apply(x[sequences, ], 2, cumsum) > 0)
    }
    METHODS <- c("collector", "random")
    method <- match.arg(method, METHODS)
    haploaccum <- sdaccum <- perm <- NULL
    if (n == 1)
        message("There is only 1 sequence. No accumulation was possible")
    switch(method, collector = {
        haploaccum <- accumulator(z, sequences) },
	random = {
        perm <- array(dim = c(n, permutations))
        for (i in 1:permutations) {
            perm[, i] <- accumulator(z, sample(n))
        }
        haploaccum <- apply(perm, 1, mean)
        sdaccum <- apply(perm, 1, sd)
    })
    out <- list(call = match.call(), method = method, sequences = sequences,
                n.haplotypes = haploaccum, sd = sdaccum, perm = perm)
    class(out) <- "haploAccum"
    out
}
