% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pgPostGIS.R
\name{pgPostGIS}
\alias{pgPostGIS}
\title{Check and create PostGIS extension.}
\usage{
pgPostGIS(
  conn,
  topology = FALSE,
  tiger = FALSE,
  sfcgal = FALSE,
  raster = FALSE,
  display = TRUE,
  exec = TRUE
)
}
\arguments{
\item{conn}{A connection object (required, even if \code{exec =
FALSE}).}

\item{topology}{Logical. Whether to check/install the Topology
extension.}

\item{tiger}{Logical. Whether to check/install the Tiger Geocoder
extension. Will also install extensions "fuzzystrmatch",
"address_standardizer", and "address_standardizer_data_us" if
all are available.}

\item{sfcgal}{Logical. Whether to check/install the SFCGAL
extension.}

\item{raster}{Logical. Whether to check/install the Raster extension}

\item{display}{Logical. Whether to display the query (defaults to
\code{TRUE}).}

\item{exec}{Logical. Whether to execute the query (defaults to
\code{TRUE}).}
}
\value{
If \code{exec = TRUE}, returns \code{TRUE} if PostGIS is installed.
}
\description{
The function checks for the availability of the PostGIS extension,
and if it is available, but not installed, install
it. Additionally, can also install Topology, Tiger Geocoder,
SFCGAL and Raster extensions.
}
\examples{
## 'exec = FALSE' does not install any extension, but nevertheless
## check for available and installed extensions:
\dontrun{
    pgPostGIS(con, topology = TRUE, tiger = TRUE, sfcgal = TRUE,
        exec = FALSE)
}
}
\author{
Mathieu Basille \email{mathieu@basille.org} and
        Adrián Cidre González \email{adrian.cidre@gmail.com}
}
