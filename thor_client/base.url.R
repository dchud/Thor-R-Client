base.url <- function(endpoint) {
  url <- paste("http://127.0.0.1:5000/api/", endpoint, "/", sep="")
  return(url)
}