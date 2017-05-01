base.url <- function(end.point) {
  #' Base URL Construction Method
  #'
  #' @param end.point The url that should be used in contact the Thor server. 
  #' When Thor is deployed locally, it make sense to use the localhost 
  #' designation. On the other hand, when deployed remotely, a particular URL 
  #' needs to be provided.
  #' @return A string containing the URL endpoint of the desired API method.
  #' @export
  url <- paste("http://127.0.0.1:5000/api/", end.point, "/", sep="")
  ## url <- paste("http://aa-lnx01.mitre.org:5000/api/", end.point, "/", sep="")
  return(url)
}
