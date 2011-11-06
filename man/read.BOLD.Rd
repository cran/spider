\name{read.BOLD}
\alias{read.BOLD}
\alias{search.BOLD}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Downloads DNA sequences from the Barcode of Life Database (BOLD)}

\description{These functions allow DNA sequences to be downloaded from the Barcode of Life Database (BOLD).}

\usage{search.BOLD(taxon)
read.BOLD(IDs)}



%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{taxon}{A character vector of the names of the taxa of interest.}
  \item{IDs}{A character vector containing BOLD process ID numbers.}
}

\details{\code{search.BOLD} retrieves BOLD process identification numbers for any given taxon using BOLD's eSearch system.

\code{read.BOLD} downloads the sequences associated with the process identification numbers using the eFetch web service offered by BOLD to enable batch retrieval of records.

}

\value{
\code{search.BOLD} returns a character vector giving the process identification numbers of the specimens found by the search.

\code{read.BOLD} returns an object of class `DNAbin'. This object has the attributes "species", "accession_num", and "gene". 
}

\section{Warning}{
On 26 Oct 2011, attempts to access records using the eFetch system through a web browser resulted in an error, saying that eFetch and eSearch are offline for maintainance. To test if these services are running, check the following URL in a web browser: 

\url{http://services.boldsystems.org/eFetch.php?record_type=specimen&id_type=sampleid&ids=DQ116162&return_type=xml}
}

\references{
BOLD web services:
\url{http://services.boldsystems.org/}.

}

\author{
Samuel Brown <s_d_j_brown@hotmail.com>
}

\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{read.GB}}.
%% ~~objects to See Also as \code{\link{help}}, ~~~
}

\examples{
\dontrun{
nn <- search.BOLD("Pisauridae")
pisaurid <- read.BOLD(nn)

write.dna(pisaurid, "filename.fas", format="fasta")}
}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{Barcoding}
\keyword{Datasets}% __ONLY ONE__ keyword per line
