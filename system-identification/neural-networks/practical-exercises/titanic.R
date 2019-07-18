rm(list=ls())
library(RSNNS)
library(kernlab)
library(caret)
library(RSNNS)
library(pROC)
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

column.types <- c('integer',   # PassengerId
                  'factor',    # Survived 
                  'factor',    # Pclass
                  'character', # Name
                  'factor',    # Sex
                  'numeric',   # Age
                  'integer',   # SibSp
                  'integer',   # Parch
                  'character', # Ticket
                  'numeric',   # Fare
                  'character', # Cabin
                  'factor'     # Embarked
)
train <- read.csv(file="train.csv",header=TRUE,sep=",",colClasses=column.types,na.strings=c('NA',''))
test <- read.csv(file="test.csv",header=TRUE,sep=",",colClasses=column.types[-2],na.strings=c('NA',''))
test$Survived <- NA
titanic <- rbind(train,test)

# Feature Engineering 1: Name #
# Title
titanic$Title <- sapply(titanic$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][2]})
titanic$Title[titanic$Title %in% c(' Capt', ' Don', ' Major', ' Sir', ' Jonkheer')] <- 'Sir'
titanic$Title[titanic$Title %in% c(' Dona', ' Lady', ' Mlle', ' Mme', ' the Countess',' Ms')] <- 'Lady'
titanic$Title <- factor(titanic$Title)

# Marking Brackets and Quotes
#titanic$Bracket <- sapply(titanic$Name, FUN=function(x) {ifelse(!is.na(strsplit(x, split='[(]')[[1]][2]),1,0)})
#titanic$Bracket <- factor(titanic$Bracket)
#titanic$Quote <- sapply(titanic$Name, FUN=function(x) {ifelse(!is.na(strsplit(x, split='["]')[[1]][2]),1,0)})
#titanic$Quote <- factor(titanic$Quote)

# Surname
titanic$Surname <- sapply(titanic$Name, FUN=function(x) {strsplit(x, split='[,.]')[[1]][1]})
famSize <- data.frame(table(titanic$Surname))
smallFam <- famSize[famSize$Freq <= 2,1]
titanic$Surname[titanic$Surname %in% smallFam] <- 'Small'
titanic$Surname <- factor(titanic$Surname)

# Feature Engineering 2: Fare #
# Removing NAs
titanic$Fare[is.na(titanic$Fare)] <- mean(titanic$Fare,na.rm = TRUE)

# Fare Per Person
titanic$FarePP <- sapply(titanic$Fare, FUN=function(x) {ifelse(titanic$SibSp[1]+titanic$Parch[1],x/(titanic$SibSp[1]+titanic$Parch[1]+1),x)})

# Feature Engineering 3: Ticket #
require(stringr)
titanic$Ticket <- sapply(titanic$Ticket, FUN=function(x) {strsplit(str_replace_all(x,' ','.'),'[.]')[[1]][length(strsplit(str_replace_all(x,' ','.'),'[.]')[[1]])]})
#repTicket <- data.frame(table(titanic$Ticket))
#repTicket <- repTicket[which(repTicket$Freq >= 2),]
#titanic$sameTicket <- sapply(titanic$Ticket, FUN = function(x) {ifelse(x %in% repTicket$Var1,repTicket$Freq[which(repTicket$Var1==x)],0)})
#titanic$sameTicket <- factor(titanic$sameTicket)

# Feature Engineering 4: Cabin #
titanic$Cabin[is.na(titanic$Cabin)] <- 'Unknown'
titanic$Cabin <- sapply(titanic$Cabin, FUN=function(x) {strsplit(x,'')[[1]][1]})
titanic$Cabin <- factor(titanic$Cabin)

# Feature Engineering 5: Age #
ageByTitle <- aggregate(titanic$Age[!is.na(titanic$Age)],list(titanic$Title[!is.na(titanic$Age)]),mean)
titanic$Age[is.na(titanic$Age)] <- sapply(titanic$Title[is.na(titanic$Age)], FUN=function(y) {ageByTitle$x[which(list(y)[[1]][1] == ageByTitle$Group.1)]})

# Feature Engineering 6: Embarked #
titanic$Embarked[is.na(titanic$Embarked)] <- 'S'

titanic <- titanic[which(!is.na(titanic$Survived)),]
# test <- titanic[which(is.na(titanic$Survived)),]

aucrprop <- c()
aucscg <- c()
aucbpwd <- c()
nIter <- 10

titanic <- titanic[,-c(1,4,9)]
titanic <- preProcess(titanic[,-1], method = c("center", "scale"))

