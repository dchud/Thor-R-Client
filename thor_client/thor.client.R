library("httr")
library("jsonlite")
source("base.url.R")

create.experiment <- function(name, dimensions, acq.func, auth.token) {
  ## Create an experiment.
  url <- base.url("create_experiment")
  data <- list(auth_token = auth.token, name = name, acq_func = acq.func, dimensions = dimensions)
  exp <- content(POST(url = url, body = data, encode = "json"))
  return(exp)
}

experiment.for.name <- function(name, auth.token) {
  ## Get an experiment with a given name.
  url <- base.url("experiment_for_name")
  data <- list(auth_token = auth.token, name = name)
  exp <- content(POST(url = url, body = data, encode = "json"))
  return(exp)
}