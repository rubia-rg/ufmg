library("mlbench")
library("mclust")
library("flexclust")



seqi <- seq(-1, 1, 0.01)
seqj <- seq(0, 8, 0.1)


spirals <- mlbench.spirals(N, cycles = 1.2, sd = 0.08)

cg1 <- spirals$x[which(spirals$classes==1),]

cg2 <- spirals$x[which(spirals$classes==2),]



plot(cg1[,1], cg1[,2], type = 'p', col = 'red', xlim = c(-2,2), ylim = c(-2,2))
par(new=T) 
plot(cg2[,1], cg2[,2], type = 'p', col = 'blue', xlim = c(-2,2), ylim = c(-2,2))



N <- 200
N2 <- 200
n <- 2


termo1 <- 1/(N * ((sqrt(2 * pi) * h) ^ n)) 

termo2 <- 1/(N2 * ((sqrt(2 * pi) * h) ^ n)) 



M1 <- matrix(0, nrow = N, ncol = 2)
M2 <- matrix(0, nrow = N, ncol = 2)


t1 <- 0
t2 <- 0
t3 <- 0
t4 <- 0

h <- 0.1

for(j in 1:N){
  i = 1
  for(i in 1:N){
    t1 <- t1 + (exp(-1 * (dist((rbind(cg1[j,], cg1[i,])), "euclidean")/(2 * (h^2)) )) )
    t2 <- t2 + (exp(-1 * (dist((rbind(cg2[j,], cg1[i,])), "euclidean")/(2 * (h^2)) )) )
    
    t3 <- t3 + (exp(-1 * (dist((rbind(cg1[j,], cg2[i,])), "euclidean")/(2 * (h^2)) )) )
    t4 <- t4 + (exp(-1 * (dist((rbind(cg2[j,], cg2[i,])), "euclidean")/(2 * (h^2)) )) )
  }
  t1 <- t1 * termo1
  t2 <- t2 * termo1
  t3 <- t3 * termo1
  t4 <- t4 * termo1
  
  M1[j, 1] <- t1
  M2[j, 1] <- t2
  M1[j, 2] <- t3
  M2[j, 2] <- t4
}


plot(M1[,1], M1[,2], type = 'p', col = 'red', xlim = c(0,1), ylim = c(0,1))
par(new=T) 
plot(M2[,1], M2[,2], type = 'p', col = 'blue', xlim = c(0,1), ylim = c(0,1))


