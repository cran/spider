% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/threshOpt.R
\name{threshOpt}
\alias{threshOpt}
\title{Threshold optimisation}
\usage{
threshOpt(distobj, sppVector, threshold = 0.01)
}
\arguments{
\item{distobj}{Distance matrix.}

\item{sppVector}{Species vector (see \code{\link{sppVector}}).}

\item{threshold}{Threshold distance for delimiting intra- and inter-specific
variation. Default of 0.01.}
}
\value{
A table giving the threshold and number of negative and positive
identifications, number of false negative and false positive
identifications, and the cumulative error.
}
\description{
Determines the positive, negative, false positive and false negative rates
of identification accuracy for a given threshold.
}
\details{
When run over a range of thresholds, this function allows the optimisation
of threshold values based on minimising the identification error rates. See
the example below for more details.
}
\examples{

data(anoteropsis)
anoDist <- ape::dist.dna(anoteropsis)
anoSpp <- sapply(strsplit(dimnames(anoteropsis)[[1]], split="_"), 
    function(x) paste(x[1], x[2], sep="_"))
threshOpt(anoDist, anoSpp)

data(dolomedes)
doloDist <- ape::dist.dna(dolomedes)
doloSpp <- substr(dimnames(dolomedes)[[1]], 1, 5)
threshOpt(doloDist, doloSpp)

#Conduct the analysis over a range of values to determine the optimum threshold
threshVal <- seq(0.001,0.02, by = 0.001)
opt <- lapply(threshVal, function(x) threshOpt(doloDist, doloSpp, thresh = x))
optMat <- do.call(rbind, opt)
graphics::barplot(t(optMat)[4:5,], names.arg=optMat[,1], xlab="Threshold values", 
    ylab="Cumulative error")
graphics::legend(x = 2.5, y = 29, legend = c("False positives", "False negatives"), 
    fill = c("grey75", "grey25"))

}
\references{
Meyer, C. P., and Paulay, G. (2005). DNA barcoding: error rates
based on comprehensive sampling. _PLoS Biology_ *3* (12), 2229-2238.
}
\seealso{
\code{\link{localMinima}}.
}
\author{
Rupert Collins <rupertcollins@gmail.com>
}
\keyword{Barcoding}
