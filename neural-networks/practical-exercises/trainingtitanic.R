
#for(i in 1:nIter){
# Amostragem de dados #
titanic <- titanic[sample(1:nrow(titanic),length(1:nrow(titanic))),1:ncol(titanic)]
titanicValues <- data.matrix(titanic[,-1])
titanicTargets <- decodeClassLabels(as.numeric(titanic$Survived))

# Divisão dos conjuntos de treino e teste #
titanic <- splitForTrainingAndTest(titanicValues, titanicTargets, ratio=0.30)
titanic <- normTrainingAndTestSet(titanic)

# Treinamento
# RProp #
rprop<-mlp(titanic$inputsTrain, titanic$targetsTrain, size=2, maxit=100, 
           inputsTest=titanic$inputsTest, targetsTest=titanic$targetsTest,
           initFunc="Randomize_Weights", 
           learnFunc="Rprop",
           updateFunc="Topological_Order",
           updateFuncParams=c(0), 
           hiddenActFunc="Act_Logistic",
           shufflePatterns=TRUE, linOut=FALSE)
# SCG #
scg<-mlp(titanic$inputsTrain, titanic$targetsTrain, size=2, maxit=40, 
         inputsTest=titanic$inputsTest, targetsTest=titanic$targetsTest,
         initFunc="Randomize_Weights", 
         learnFunc="SCG",
         updateFunc="Topological_Order",
         updateFuncParams=c(0), 
         hiddenActFunc="Act_Logistic",
         shufflePatterns=TRUE, linOut=FALSE)

# Backpropagation com Weight Decay #
bpwd<-mlp(titanic$inputsTrain, titanic$targetsTrain, size=2, maxit=40, 
          inputsTest=titanic$inputsTest, targetsTest=titanic$targetsTest,
          initFunc="Randomize_Weights", 
          learnFunc="BackpropWeightDecay",
          updateFunc="Topological_Order",
          updateFuncParams=c(0), 
          hiddenActFunc="Act_Logistic",
          shufflePatterns=TRUE, linOut=FALSE)
# Teste #
yrprop <- predict(rprop,titanic$inputsTest)
yrprop <- ifelse(max(yrprop[,1],yrprop[,2])==yrprop[,1],1,2)
yscg <- predict(scg,titanic$inputsTest)
yscg <- ifelse(max(yscg[,1],yscg[,2])==yscg[,1],1,2)
ybpwd <- predict(bpwd,titanic$inputsTest)
ybpwd <- ifelse(max(ybpwd[,1],ybpwd[,2])==ybpwd[,1],1,2)

titanic$targetsTest <- ifelse(max(titanic$targetsTest[,1],titanic$targetsTest[,2])==titanic$targetsTest[,1],1,2)

rocrprop <- roc(yrprop,titanic$targetsTest)
#rocscg <- roc(yscg,titanic$targetsTest)
#rocbpwd <- roc(ybpwd,titanic$targetsTest)

# AUC #
aucrprop <- auc(rocrprop)
#aucscg <- auc(rocscg)
#aucbpwd <- auc(rocbpwd)
#}
