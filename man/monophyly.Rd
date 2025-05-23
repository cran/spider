% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/monophyly.R
\name{monophyly}
\alias{monophyly}
\title{Species monophyly over a tree}
\usage{
monophyly(phy, sppVector, pp = NA, singletonsMono = TRUE)
}
\arguments{
\item{phy}{A tree of class `phylo'.}

\item{sppVector}{Species vector. See \code{\link{sppVector}}}

\item{pp}{Object of class `prop.part'. Assists in speeding up the function,
if it has been called already. Default of NA, calling
\code{\link[ape]{prop.part}} internally.}

\item{singletonsMono}{Logical. Should singletons (i.e. only a single
specimen representing that species) be treated as monophyletic? Default of
TRUE. Possible values of FALSE and NA.}
}
\value{
\code{monophyly} returns a logical vector, stating if each species
is monophyletic. Values correspond to the species order given by
\code{unique(sppVector)}.

\code{monophylyBoot} returns a list with the following elements:
\item{results}{A logical vector, stating if each species is monophyletic
with a bootstrap support higher than the given threshold.} \item{BSvalues}{A
numeric vector giving the bootstrap proportions for each node of
\code{phy}.}
}
\description{
Determines if the species given in \code{sppVector} form monophyletic groups
on a given tree.
}
\details{
\code{monophyly} determines if each species is monophyletic.
\code{monophylyBoot} incorporates a bootstrap test to determine the support
for this monophyly. Species with a bootstrap support lower than
\code{"thresh"} are recorded as FALSE.

Rerooting is done on the longest internal edge in the tree returned by
\code{nj(dist.dna(DNAbin))}.
}
\examples{

#Random trees
set.seed(16)
tr <- ape::rtree(15)
spp <- rep(LETTERS[1:5], rep(3,5))
monophyly(tr, spp)

tr2 <- tr
spp2 <- c(rep(LETTERS[1:4], rep(3,4)), LETTERS[5:7])
monophyly(tr2, spp2)

#Empirical data
\dontrun{
data(anoteropsis)
anoTree <- ape::nj(ape::dist.dna(anoteropsis))
anoSpp <- sapply(strsplit(dimnames(anoteropsis)[[1]], split="_"), 
    function(x) paste(x[1], x[2], sep="_"))

monophyly(anoTree, anoSpp)
monophyly(anoTree, anoSpp, singletonsMono=FALSE)
unique(anoSpp)

#To get score for each individual
anoMono <- monophyly(anoTree, anoSpp)
anoMono[match(anoSpp, unique(anoSpp))]

data(woodmouse)
woodTree <- ape::nj(ape::dist.dna(woodmouse))
woodSpp <- c("D", "C", "C", "A", "A", "E", "A", "F", "C", "F", "E", "D", "A", "A", "E")
unique(woodSpp)
monophyly(woodTree, woodSpp)
woodMono <- monophylyBoot(woodTree, woodSpp, woodmouse)
woodMono$results
woodMono$BSvalues

monophylyBoot(woodTree, woodSpp, woodmouse, reroot = FALSE)
monophylyBoot(woodTree, woodSpp, woodmouse, thresh = 0.9, reroot = FALSE)
}


}
\seealso{
\code{\link[ape]{prop.part}}, \code{\link[ape]{root}},
\code{\link[ape]{boot.phylo}}.
}
\author{
Samuel Brown <s_d_j_brown@hotmail.com>
}
