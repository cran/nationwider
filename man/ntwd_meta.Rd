% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get.R
\name{ntwd_meta}
\alias{ntwd_meta}
\title{Access object's metadata}
\usage{
ntwd_meta(x)
}
\arguments{
\item{x}{The object that is returned from \code{\link{ntwd_get}}.}
}
\value{
A character vector.
}
\description{
Some datasets in nationwide contain metadata that cannot be displayed in
a dataframe. All metadata are stored as attributes to the dataframe, where it
can be displayed with \code{ntwd_meta}.
}
\details{
Not all objects contain metadata
}
\examples{
\donttest{
x <- ntwd_get("since_1952")
ntwd_meta(x)
}
}
