#' Thor Experiment Client Methods
#' 
#' This object defines a Thor experiment within the Python environment. In
#' particular, an experiment is defined by its name, the date at which it was
#' created, and the dimensions of the machine learning model. Moreover, an
#' authentication token is required for requesting new parameter
#' configurations, for submitting observations of parameters, for viewing
#' pending parameter configurations and for obtaining the best configuration
#' of parameters that has been evaluated so far.

create.recommendation <- function(experiment.id, auth.token, rand.prob, n.model.iters) {
  #' Get a recommendation for a point to evaluate next.
  #' 
  #' The create recommendation utility represents the core of the Thor Bayesian
  #' optimization software. This function will contact the Thor server and 
  #' request a new configuration of machine learning parameters that serve the 
  #' object of maximizing the metric of interest.
  #' 
  #' @param experiment.id A unique identifier that indicates which experiment
  #' on the server-side is being interacted with by the client.
  #' @param auth.token String containing a user's specific API key provided by 
  #' the Thor server. This is used to authenticate with the Thor server as a 
  #' handshake that these experiments belong to a user and can be viewed and 
  #' edited by them.
  #' @param rand.prob This parameter represents that a random point in the input
  #' space is chosen instead of selecting a configuration of parameters using 
  #' Bayesian optimization. As such, this parameter can be used to benchmark 
  #' against random search and otherwise to perform pure exploration of the
  #' parameter space.
  #' @param n.model.iters This parameter determines the number of maximum 
  #' likelihood random restarts are used to isolate the maximum of the Gaussian
  #' process likelihood with respect to the kernel parameters. Setting this to 
  #' a large value will generally provide better probabilistic interpolants of 
  #' the metric as a function of the model parameters. In large-scale problems,
  #' this parameter instead controls the number of training iterations used to 
  #' fit a Bayesian neural network. In particular, 1,000 times this parameter 
  #' epochs are performed.
  #' @return A recommendation client object corresponding to the recommended 
  #' set of parameters.
  #' @export
  url <- base.url("create_recommendation")
  if (missing(rand.prob))
    rand.prob <- NA
  if (missing(n.model.iters))
    n.model.iters <- NA
  data <- list(rand_prob = unbox(rand.prob), n_model_iters = unbox(n.model.iters), auth_token = auth.token, experiment_id = experiment.id)
  rec <- content(POST(url = url, body = data, encode = "json"))
  rec$config <- fromJSON(rec$config)
  return(rec)
}

best.configuration <- function(experiment.id, auth.token) {
  #' Get the configuration of parameters that produced the best value of the 
  #' objective function.
  #' 
  #' @param experiment.id A unique identifier that indicates which experiment
  #' on the server-side is being interacted with by the client.
  #' @param auth.token String containing a user's specific API key provided by 
  #' the Thor server. This is used to authenticate with the Thor server as a 
  #' handshake that these experiments belong to a user and can be viewed and 
  #' edited by them.
  #' @return A dictionary containing a detailed view of the configuration of 
  #' model parameters that produced the maximal value of the metric. This 
  #' includes the date the observation was created, the value of the metric, 
  #' and the configuration itself.
  #' @export
  url <- base.url("best_configuration")
  data <- list(auth_token = auth.token, experiment_id = experiment.id)
  obs <- content(POST(url = url, body = data, encode = "json"))
  obs$config <- fromJSON(obs$config)
  return(obs)
}

submit.observation <- function(experiment.id, auth.token, config, target) {
  #' Upload a pairing of a configuration alongside an observed target variable.
  #' 
  #' @param experiment.id A unique identifier that indicates which experiment
  #' on the server-side is being interacted with by the client.
  #' @param auth.token String containing a user's specific API key provided by 
  #' the Thor server. This is used to authenticate with the Thor server as a 
  #' handshake that these experiments belong to a user and can be viewed and 
  #' edited by them.
  #' @param config A dictionary mapping dimension names to values indicating 
  #' the configuration of parameters.
  #' @param target A number indicating the performance of this configuration 
  #' of model parameters.
  #' @export
  url <- base.url("submit_observation")
  data <- list(auth_token = auth.token, experiment_id = experiment.id, configuration = config, target = target)
  res <- content(POST(url = url, body = data, encode = "json"))
  return(res)
}

pending.recommendations <- function(experiment.id, auth.token) {
  #' Query for pending recommendations that have yet to be evaluated.
  #' Upload a pairing of a configuration alongside an observed target variable.
  #' 
  #' Sometimes client-side computations may fail for a given input
  #' configuration of model parameters, leaving the recommendation in a kind
  #' of "limbo" state in which is not being evaluated but still exists. In
  #' this case, it can be advantageous for the client to query for such
  #' pending observations and to evaluate them. This function returns a list
  #' of pending recommendations which can then be evaluated by the client.
  #' 
  #' @param experiment.id A unique identifier that indicates which experiment
  #' on the server-side is being interacted with by the client.
  #' @param auth.token String containing a user's specific API key provided by 
  #' the Thor server. This is used to authenticate with the Thor server as a 
  #' handshake that these experiments belong to a user and can be viewed and 
  #' edited by them.
  #' @return A list of recommendation client objects, where each element in the
  #' list corresponds to a pending observation.
  #' @export
  url <- base.url("pending_recommendations")
  data <- list(auth_token = auth.token, experiment_id = experiment.id)
  res <- content(POST(url = url, body = data, encode = "json"))
  for (i in 1:length(res)) {
    res[[i]]$config <- fromJSON(res[[i]]$config)
  }
  return(res)
}

