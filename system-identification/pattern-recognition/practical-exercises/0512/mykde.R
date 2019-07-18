mykdemultivar <- function(xi, X, n, N)
{
  
  px <- matrix(nrow=dim(xi)[1],ncol=dim(xi)[2])
  h <- c()
  for(i in 1:dim(xi)[1])
  { 
    for(j in 1:dim(xi)[2])
    {
      h[j] <- 1.06*sd(X[,j])*(N^(-1/5))
      px[i,j] <- (1/(N*(sqrt(2*pi)*h[j])^n))*
        sum(exp(-((xi[i,j]-X[,j])^2)/((2*h[j])^2)))
    }
  }
  return(px)
}