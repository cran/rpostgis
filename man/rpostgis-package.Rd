% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rposrgis-package.R
\docType{package}
\name{rpostgis-package}
\alias{rpostgis}
\alias{rpostgis-package}
\title{rpostgis: R Interface to a PostGIS Database}
\description{
The \strong{\code{rpostgis}} package provides an interface between \strong{R} and
\strong{PostGIS-enabled PostgreSQL databases}, allowing seamless transfer of spatial data.
It supports both \strong{vector} (points, lines, polygons) and \strong{raster} data for reading and writing.
Additionally, it offers convenience functions to perform common operations within \strong{PostgreSQL/PostGIS}.
}
\section{Features}{

\itemize{
\item \strong{Vector Data Support}: Points, lines, polygons
\item \strong{Raster Data Support}: Read and write raster data
\item \strong{PostGIS Functions}: Convenient wrappers for common PostGIS tasks
\item \strong{PostgreSQL Connectivity}: Interface for database interaction
}
}

\section{Getting Started}{


\strong{1. Loading the package and connecting to a database}
To begin, load the \code{rpostgis} package and establish a connection to a PostgreSQL database:

\if{html}{\out{<div class="sourceCode r">}}\preformatted{library(rpostgis)
con <- dbConnect("PostgreSQL", dbname = "<dbname>", host = "<host>",
                 user = "<user>", password = "<password>")
}\if{html}{\out{</div>}}

Example:

\if{html}{\out{<div class="sourceCode r">}}\preformatted{con <- dbConnect("PostgreSQL", dbname = "rpostgis", host = "localhost",
                 user = "postgres", password = "postgres")
}\if{html}{\out{</div>}}

\strong{2. Checking and Installing PostGIS}
Verify if \strong{PostGIS} is installed on the database. If not, it will attempt to install it:

\if{html}{\out{<div class="sourceCode r">}}\preformatted{pgPostGIS(con)
}\if{html}{\out{</div>}}

This function should return \code{TRUE} invisibly when PostGIS is installed and ready for use.

\strong{3. Closing the Database Connection}
After finishing your work, make sure to close the connection:

\if{html}{\out{<div class="sourceCode r">}}\preformatted{dbDisconnect(con)
}\if{html}{\out{</div>}}
}

\section{List of Functions}{

To view a list of all available functions in \code{rpostgis}, use:

\if{html}{\out{<div class="sourceCode r">}}\preformatted{library(help = "rpostgis")
}\if{html}{\out{</div>}}
}

\section{Additional Notes}{

\itemize{
\item Ensure your \strong{PostgreSQL} instance is \strong{PostGIS-enabled} before using \code{rpostgis} functions.
\item The functions provided simplify working with spatial data and interacting with a PostGIS-enabled database.
}
}

\seealso{
Useful links:
\itemize{
  \item \url{https://cidree.github.io/rpostgis/}
  \item \url{https://github.com/Cidree/rpostgis}
  \item Report bugs at \url{https://github.com/Cidree/rpostgis/issues}
}

}
\author{
\strong{Maintainer}: Adrián Cidre González \email{adrian.cidre@gmail.com} (\href{https://orcid.org/0000-0002-3310-3052}{ORCID})

Authors:
\itemize{
  \item Mathieu Basille \email{mathieu@basille.org} (\href{https://orcid.org/0000-0001-9366-7127}{ORCID})
  \item David Bucklin \email{david.bucklin@gmail.com}
}

}
\keyword{internal}
