#' Thor Recommendation Client Methods
#' 
#' The purpose of this class is to provide an interface for interacting with 
#' suggestions provided by the Thor API. In particular, once a recommendation
#' is received, it will be evaluated by the client's local computer. After 
#' this, its value as a configuration will be transmitted back to the Thor 
#' server.

submit.recommendation <- function(recommendation.id, auth.token, value) {
  #' Submit the returned metric value for a point that was recommended by the 
  #' Bayesian optimization routine.
  #' 
  #' @param recommendation.id An integer identifier for this recommendation. 
  #' This allows the Thor server to identify which recommendation was 
  #' associated with a given value of the metric on the client side.
  #' @param auth.token String containing a user's specific API key provided by 
  #' the Thor server. This is used to authenticate with the Thor server as a 
  #' handshake that these experiments belong to a user and can be viewed and 
  #' edited by them.
  #' @param value A number indicating the performance of this configuration of 
  #' model parameters.
  #' @return A dictionary containing the recommendation identifier and a 
  #' boolean indicator that the recommendation was submitted.
  #' @export
  url <- base.url("submit_recommendation")
  data <- list(auth_token = auth.token, recommendation_id = recommendation.id, value = value)
  res <- content(POST(url = url, body = data, encode = "json"))
  return(res)
}