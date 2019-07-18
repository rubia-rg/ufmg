rm(list=ls())
library("RSNNS")
library("kernlab")
#gender_sub <- read.csv(file="gender_submission.csv",header=TRUE,sep=",")
train <- read.csv(file="train.csv",header=TRUE,sep=",")
test <- read.csv(file="test.csv",header=TRUE,sep=",")

titanic <- data.matrix(train[,c(-4,-9,-11)])
titanic[is.na(titanic)] <- 0

titanic <- titanic[sample(1:nrow(titanic),length(1:nrow(titanic))),1:ncol(titanic)]

titanicValues <- titanic[,-2]
titanicTargets <- decodeClassLabels(titanic[,2])

titanic <- splitForTrainingAndTest(titanicValues, titanicTargets, ratio=0.30)
titanic <- normTrainingAndTestSet(titanic)

# Treino
rede<-mlp(titanic$inputsTrain, titanic$targetsTrain, size=5, maxit=40, 
          inputsTest=titanic$inputsTest, targetsTest=titanic$targetsTest,
          initFunc="Randomize_Weights", 
          initFuncParams=c(-0.3, 0.3), 
          learnFunc="Rprop",
          learnFuncParams=c(0.1, 0.1), 
          updateFunc="Topological_Order",
          updateFuncParams=c(0), 
          hiddenActFunc="Act_Logistic",
          shufflePatterns=TRUE, linOut=FALSE)

yhat <- (predict(rede,titanic$inputsTest) >= 0.5)*1 # Teste

mean(sqrt((yhat-titanic$targetsTest)^2)) # MSE

summary(rede)
rede
