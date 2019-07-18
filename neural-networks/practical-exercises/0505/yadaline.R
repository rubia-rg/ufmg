yadaline <- function(xvec, w, par)
{
  if(par == 1)
    xvec <- cbind(1, xvec)
  y <- xvec %*% w
  return(as.matrix(y))
}