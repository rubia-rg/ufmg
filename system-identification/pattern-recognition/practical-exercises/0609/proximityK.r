proximityK <- function(U,numcluster)
  # U is partition matrix from FCM. Patterns are on rows
  # and clusters on columns. U has N rows and c columns.
  # numcluster contains cluster number for each pattern.
  # P is sorted according to the cluster numbers.
  
{
  dvec<-dim(U)
  Npatt<-dvec[1]
  ncluster<-dvec[2]
  Usort<-rbind(t(U),t(numcluster))
  Usort<-t(Usort)
  Usort<-Usort[ order(Usort[,(ncluster+1)]), ]
  Usort<-Usort[,-(ncluster+1)]
  P<-matrix(nrow=Npatt,ncol=Npatt)
  for(i in 1:Npatt) 
  {
    for(j in 1:Npatt) 
    {
      P[i,j] <- sum(pmin(Usort[i,],Usort[j,]))
    }
  }
  return(P)
}
############################################