% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pgGetGeom.R
\name{pgGetGeomQ}
\alias{pgGetGeomQ}
\title{Load geometries from a full query and return a Spatial* object}
\usage{
pgGetGeomQ(conn, query, name = NULL, ...)
}
\arguments{
\item{query}{character, a full SQL query including a geometry column.}

\item{name}{optional character string specifying
a PostgreSQL schema and view name (e.g., \code{name = c("schema","view")})
to save the query as. If NULL, a temporary view ".rpostgis_TEMPview" is used
temporarily (only within the function scope).}

\item{...}{For \code{pgGetGeomQ}, other arguments as in \code{pgGetGeom}}
}
\description{
Load geometries from a full query and return a Spatial* object
}
\keyword{internal}
