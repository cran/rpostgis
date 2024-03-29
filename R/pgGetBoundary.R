## pgGetBoundary

##' Retrieve bounding envelope of geometries or rasters.
##'
##' Retrieve bounding envelope (rectangle) of all geometries or
##' rasters in a PostGIS table as a \code{sfc} object.
##'
##' @param conn A connection object to a PostgreSQL database
##' @param name A character string specifying a PostgreSQL schema and
##'     table/view name holding the geometry (e.g., \code{name =
##'     c("schema","table")})
##' @param geom A character string specifying the name of the geometry column
##' in the table \code{name} (Default = \code{"geom"}). Note that for raster objects
##' you will need to change the default value
##' @param clauses character, additional SQL to append to modify select
##'     query from table. Must begin with an SQL clause (e.g., "WHERE ...",
##'     "ORDER BY ...", "LIMIT ..."); same usage as in \code{pgGetGeom}.
##' @param returnclass 'sf' by default; 'terra' for \code{SpatVector}; 
##'     or 'sp' for \code{sp} objects.
##' @author David Bucklin \email{david.bucklin@@gmail.com} and Adrian Cidre 
##' González \email{adrian.cidre@@gmail.com}
##' @export
##' @return object of class sfc (list-column with geometries); 
##'     SpatVector or sp object
##' @importFrom sf as_Spatial
##' @examples
##' \dontrun{
##' pgGetBoundary(conn, c("schema", "polys"), geom = "geom")
##' pgGetBoundary(conn, c("schema", "rasters"), geom = "rast")
##' }

pgGetBoundary <- function(conn, name, geom = "geom", clauses = NULL,
                          returnclass = "sf") {
  ## Message
  message("Since version 1.5 this function outputs sfc objects by default.
          Use returnclass = 'sp' to return sp objects.")
  
  dbConnCheck(conn)
  if (!suppressMessages(pgPostGIS(conn))) {
    stop("PostGIS is not enabled on this database.")
  }
  ## Check and prepare the schema.name
  nameque <- paste(dbTableNameFix(conn,name), collapse = ".")
  namechar <- dbQuoteString(conn, 
                paste(dbTableNameFix(conn,name, as.identifier = FALSE), collapse = "."))
  ## prepare clauses
  if (!is.null(clauses)) clauses <- sub("^where", "AND", sub(";$","", sub("\\s+$","",clauses)),
                                        ignore.case = TRUE)
  
  ## Check table exists
  tmp.query <- paste0("SELECT geo FROM\n  (SELECT (gc.f_table_schema||'.'||gc.f_table_name) AS tab,
                      gc.f_geography_column AS geo\n  FROM geography_columns AS gc\n   UNION\n
                      SELECT (gc.f_table_schema||'.'||gc.f_table_name) AS tab,
                      gc.f_geometry_column AS geo\n  FROM geometry_columns AS gc\n   UNION\n   
                      SELECT rc.r_table_schema||'.'||rc.r_table_name AS tab, rc.r_raster_column AS geo\n   
                      FROM raster_columns as rc) a\n  WHERE tab  = ",
                      namechar, ";")
  tab.list <- dbGetQuery(conn, tmp.query)$geo
  if (is.null(tab.list)) {
      stop(paste0("Table/view ", namechar, " is not listed in geometry_columns or raster_columns."))
  } else if (!geom %in% tab.list) {
      stop(paste0("Table/view ", namechar, " geometry/raster column not found.\nAvailable geometry/raster columns: ",
          paste(tab.list, collapse = ", ")))
  }
  geomque <- DBI::dbQuoteIdentifier(conn, geom)
  ## Check data type
  tmp.query <- paste0("SELECT DISTINCT pg_typeof(", geomque , ") AS type FROM ",
      nameque, "\n  WHERE ", geomque , " IS NOT NULL ",clauses,";")
  type <- suppressWarnings(dbGetQuery(conn, tmp.query))
  if (length(type$type) == 0) {
      stop("No records found.")
  } else if (type$type == "raster") {
      func <- "ST_Union"
  } else if (type$type == "geometry") {
      func <- "ST_Collect"
  } else if (type$type == "geography") {
      func <- "ST_Collect"
      geomque <- paste0(DBI::dbQuoteIdentifier(conn, geom),"::geometry")
  } else {
      stop(paste0("Column", geom, " does not contain geometry/geography or rasters"))
  }
  ## Retrieve the SRID
  tmp.query <- paste0("SELECT DISTINCT(ST_SRID(", geomque, ")) FROM ",
      nameque, " WHERE ", geomque, " IS NOT NULL ",clauses,";")
  srid <- dbGetQuery(conn, tmp.query)
  ## Check if the SRID is unique, otherwise throw an error
  if (nrow(srid) > 1) {
    stop("Multiple SRIDs in geometry/raster")
  } else if (nrow(srid) < 1) {
    stop("Database table is empty.")
  }
  p4s <- NA
  tmp.query <- paste0("SELECT proj4text AS p4s FROM spatial_ref_sys WHERE srid = ",
                      srid$st_srid, ";")
  db.proj4 <- dbGetQuery(conn, tmp.query)$p4s
  if (!is.null(db.proj4)) {
    try(p4s <- sf::st_crs(db.proj4), silent = TRUE)
  }
  if (is.na(p4s)) {
    warning("Table SRID not found. Projection will be undefined (NA)")
  }
  ## Retrieve envelope
  tmp.query <- paste0("SELECT ST_Astext(ST_Envelope(", func,
      "(", geomque , "))) FROM ", nameque, " WHERE ", geomque , " IS NOT NULL ",clauses,";")
  wkt <- suppressWarnings(dbGetQuery(conn, tmp.query))
  env <- sf::st_as_sfc(wkt$st_astext, crs = p4s)
  
  # Return class
  if (returnclass == "sf") {
    return(env)
  } else if (returnclass == "sp") {
    return(sf::as_Spatial(env))
  } else if (returnclass == "terra") {
    return(terra::vect(env))
  } else {
    stop("returnclass must be 'sf' or 'sp'")
  }
  
  

}
