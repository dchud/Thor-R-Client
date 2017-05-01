## Link to the Thor MATLAB client.
source("franke.R")
source("../../thor_client/thor.client.R", chdir = TRUE)


## Authenticate with the Thor server.
auth.token <- 'YOUR_AUTH_TOKEN'
## Create experiment.
name <- "Franke Function (R)"
dims <- data.frame("name"=c("x", "y"),"dim_type"=c("linear", "linear"), "low"=c(0., 0.), "high"=c(1., 1.))
exp <- create.experiment(auth.token, name, dims)

## Main optimization loop.
for (i in 1:60) {
  ## Request parameter recommendation.
  rec <- create.recommendation(exp$id, auth.token)
  c <- rec$config
  ## Evaluate the parameter recommendation.
  v <- franke(c$x, c$y)
  ## Submit the parameter recommendation's value.
  submit.recommendation(rec$id, auth.token, v)
}
