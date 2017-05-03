#' Thor Client Methods
#' 
#' The purpose of this module is to allow Python users to utilize the Thor 
#' utility for Bayesian optimization of machine learning systems. This module
#' in particular is intended to properly authenticate with Thor and to create
#' experiments.


create.experiment <- function(auth.token, name, dimensions, acq.func, overwrite) {
  #' Create an experiment.
  #' 
  #' @param auth.token String containing a user's specific API key provided by 
  #' the Thor server. This is used to authenticate with the Thor server as a 
  #' handshake that these experiments belong to a user and can be viewed and 
  #' edited by them.
  #' @param name String containing the name of the experiment to create.
  #' @param dimensions A list of dictionaries that specify the hyperparameters
  #'  of the machine learning system.
  #' @param acq.func A string containing the name of the acquisition function 
  #' to use. This can be one of "hedge", "upper_confidence_bound", 
  #' "expected_improvement", or "improvement_probability".
  #' @param overwrite An indicator variable which will overwrite existing 
  #' experiments with the given name if they already exist on Thor Server.
  #' @export
  url <- base.url("create_experiment")
  if (missing(acq.func))
    acq.func <- "hedge"
  if (missing(overwrite))
    overwrite <- FALSE
  data <- list(
    auth_token = auth.token,
    name = name,
    acq_func = acq.func,
    dimensions = dimensions,
    overwrite = overwrite
  )
  exp <- content(POST(url = url, body = data, encode = "json"))
  if ("error" %in% names(exp))
    stop(exp$error)
  return(exp)
}

experiment.for.name <- function(auth.token, name) {
  #' Get an experiment with a given name.
  #' 
  #' @param auth.token String containing a user's specific API key provided by 
  #' the Thor server. This is used to authenticate with the Thor server as a 
  #' handshake that these experiments belong to a user and can be viewed and 
  #' edited by them.
  #' @param name String containing the name of the experiment that should be 
  #' obtained.
  #' @return  corresponding experiment with the provided name. The object returned 
  #' by this method is identical in functionality to the object that is
  #' returned by the function `create_experiment`.
  #' @export
  url <- base.url("experiment_for_name")
  data <- list(auth_token = auth.token, name = name)
  exp <- content(POST(url = url, body = data, encode = "json"))
  if ("error" %in% names(exp))
    stop(exp$error)
  return(exp)
}

for.name.or.create <- function(auth.token, name, dimensions, acq.func, overwrite) {
  #' Query for an experiment and return it if it exists. Otherwise, if the
  #' experiment does not exist, create it.
  #' 
  #' @param auth.token String containing a user's specific API key provided by 
  #' the Thor server. This is used to authenticate with the Thor server as a 
  #' handshake that these experiments belong to a user and can be viewed and 
  #' edited by them.
  #' @param name String containing the name of the experiment to create.
  #' @param dimensions A list of dictionaries that specify the hyperparameters
  #'  of the machine learning system.
  #' @param acq.func A string containing the name of the acquisition function 
  #' to use. This can be one of "hedge", "upper_confidence_bound", 
  #' "expected_improvement", or "improvement_probability".
  #' @param overwrite An indicator variable which will overwrite existing 
  #' experiments with the given name if they already exist on Thor Server.
  #' @export
  if (missing(acq.func))
    acq.func <- "hedge"
  if (missing(overwrite))
    overwrite <- FALSE
  tryCatch(return(experiment.for.name(auth.token, name)), 
           error = function(e) {
             return(create.experiment(auth.token, name, dimensions, acq.func, overwrite))
           })
}
