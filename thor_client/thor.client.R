library("httr")
library("jsonlite")
source("base.url.R")
source("experiment.client.R")
source("recommendation.client.R")


create.experiment <- function(auth.token, name, dimensions, acq.func) {
  ## Create an experiment.
  url <- base.url("create_experiment")
  if (missing(acq.func))
    acq.func <- "hedge"
  data <- list(auth_token = auth.token, name = name, acq_func = acq.func, dimensions = dimensions)
  exp <- content(POST(url = url, body = data, encode = "json"))
  return(exp)
}

experiment.for.name <- function(auth.token, name) {
  ## Get an experiment with a given name.
  url <- base.url("experiment_for_name")
  data <- list(auth_token = auth.token, name = name)
  exp <- content(POST(url = url, body = data, encode = "json"))
  return(exp)
}