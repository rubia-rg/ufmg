library("mlbench")
library("mclust")

data(BreastCancer)
summary(BreastCancer)

X <- data.matrix(BreastCancer[, 2:11])
X[is.na(X)] <- 0



getGroups = function(){
  
  class1 <- matrix(0, nrow = 0, ncol <- dim(X)[2] - 1)
  class2 <- matrix(0, nrow = 0, ncol <- dim(X)[2] - 1)
  
  for(i in 1:dim(BreastCancer)[1]){
    if(X[i, 10] == 1){
      class1 <- rbind(class1, X[i, 1:9])
    }
    else{
      class2 <- rbind(class2, X[i, 1:9])
    }
  }
  
  s1 = sample(dim(class1)[1])
  s2 = sample(dim(class2)[1])
  
  train1 = as.integer(0.7*dim(class1)[1])
  test1 = as.integer(0.3*dim(class1)[1])
  
  
  tr1 = s1[1:train1]
  te1 = s1[(train1 + 1):length(s1)]
  
  
  tr1final = class1[tr1,]
  te1final = class1[te1,]
  
  
  train2 = as.integer(0.7*dim(class2)[1])
  test2 = as.integer(0.3*dim(class2)[1])
  
  
  tr2 = s2[1:train2]
  te2 = s2[(train2 + 1):length(s2)]
  
  
  tr2final = class2[tr2,]
  te2final = class2[te2,]
  
  l = vector("list", 4)
  l[[1]] = tr1final
  l[[2]] = te1final
  l[[3]] = tr2final
  l[[4]] = te2final
  
  l
  
}


myKde = function(treino, teste, treino2, teste2){
  
  
  
  
  N = dim(treino)[1]
  n = dim(treino)[2]
  
  N2 = dim(treino2)[1]
  h = 0.85
  
  pteste = 0
  pteste2 = 0
  pteste3 = 0
  pteste4 = 0
  
  termo1 = 1/(N * ((sqrt(2 * pi) * h) ^ n)) 
  
  termo2 = 1/(N2 * ((sqrt(2 * pi) * h) ^ n)) 
  
  
  
  
  #for(j in 1:dim(teste)[1]){
    for(i in 1:N){
      pteste = pteste + (exp(-1 * (dist((rbind(teste[1,], treino[i, ])), "euclidean")/(2 * (h^2)) )) )
      pteste2 = pteste2 + (exp(-1 * (dist((rbind(teste2[1,], treino[i, ])), "euclidean")/(2 * (h^2)) )) )
    }
    
    pteste = termo1 * pteste
    pteste2 = termo1 * pteste2
    
    print(pteste)
    print(pteste2)
  #}
    
    for(i in 1:N2){
      pteste3 = pteste3 + (exp(-1 * (dist((rbind(teste[1,], treino2[i, ])), "euclidean")/(2 * (h^2)) )) )
      pteste4 = pteste4 + (exp(-1 * (dist((rbind(teste2[1,], treino2[i, ])), "euclidean")/(2 * (h^2)) )) )
    }
    
    pteste3 = termo2 * pteste3
    pteste4 = termo2 * pteste4
    
    print(pteste3)
    print(pteste4)
}

hCalc = function(g1){
  h = 1.06 * sd(g1) * length(g1)^(-0.2)
  h
}
