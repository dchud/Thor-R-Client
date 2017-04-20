## Link to the Thor MATLAB client.
source("../../thor_client/thor.client.R", chdir = TRUE)

## Authenticate with the Thor server.
auth.token <- '$2b$12$.wA/rDDnUeNFoXOxBcJ6ze2ZzIF16ThQMM8hPfvuTwtTwZYVDlpXK'
## Create experiment.
name <- "2-D Parabola (R)"
dims <- data.frame("name"=c("x", "y"),"dim_type"=c("linear", "linear"), "low"=c(-1., -1.), "high"=c(1., 1.))
exp <- create.experiment(auth.token, name, dims)

## Main optimization loop.
for (i in 1:30) {
  ## Request parameter recommendation.
  rec <- create.recommendation(exp$id, auth.token)
  c <- rec$config
  ## Evaluate the parameter recommendation.
  v <- -(c$x^2 + c$y^2)
  ## Submit the parameter recommendation's value.
  submit.recommendation(rec$id, auth.token, v)
}
