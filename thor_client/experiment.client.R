library("httr")
library("jsonlite")
source("base.url.R")


create.recommendation <- function(experiment.id, auth.token) {
  ## Get a recommendation for a point to evaluate next.
  url <- base.url("create_recommendation")
  data <- list(auth_token = auth.token, experiment_id = experiment.id)
  rec <- content(POST(url = url, body = data, encode = "json"))
  rec$config <- fromJSON(rec$config)
  return(rec)
}

best.configuration <- function(experiment.id, auth.token) {
  ## Get the configuration of parameters that produced the best value of the objective function.
  url <- base.url("best_configuration")
  data <- list(auth_token = auth.token, experiment_id = experiment.id)
  obs <- content(POST(url = url, body = data, encode = "json"))
  obs$config <- fromJSON(obs$config)
  return(obs)
}

submit.observation <- function(config, target, experiment.id, auth.token) {
  ## Upload a pairing of a configuration alongside an observed target variable.
  url <- base.url("submit_observation")
  data <- list(auth_token = auth.token, experiment_id = experiment.id, configuration = config, target = target)
  res <- content(POST(url = url, body = data, encode = "json"))
  return(res)
}

pending.recommendations <- function(experiment.id, auth.token) {
  ## Query for pending recommendations that have yet to be evaluated.
  ## Upload a pairing of a configuration alongside an observed target variable.
  url <- base.url("pending_recommendations")
  data <- list(auth_token = auth.token, experiment_id = experiment.id)
  res <- content(POST(url = url, body = data, encode = "json"))
  for (i in 1:length(res)) {
    res[[i]]$config <- fromJSON(res[[i]]$config)
  }
  return(res)
}

