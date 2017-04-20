library("httr")
library("jsonlite")
source("base.url.R")


submit.recommendation <- function(recommendation.id, auth.token, value) {
  ## Submit the returned metric value for a point that was recommended by the Bayesian optimization routine.
  url <- base.url("submit_recommendation")
  data <- list(auth_token = auth.token, recommendation_id = recommendation.id, value = value)
  res <- content(POST(url = url, body = data, encode = "json"))
  return(res)
}