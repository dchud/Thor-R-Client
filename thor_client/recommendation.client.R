library("httr")
library("jsonlite")
source("base.url.R")


submit.recommendation <- function(value, recommendation.id, auth.token) {
  ## Submit the returned metric value for a point that was recommended by the Bayesian optimization routine.
  url <- base.url("submit_recommendation")
  data <- list(auth_token = auth.token, experiment_id = experiment.id, value = value)
  res <- content(POST(url = url, body = data, encode = "json"))
  return(res)
}