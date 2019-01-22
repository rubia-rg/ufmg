seqc1 <- sample(50)
xtr <- xc1[seqc1[1:ntrain],]
yc1tr <- matrix(0,nrow=ntrain)

xtr2 <- xc1[seqc1[1:ntrain],]
yc2tr <- matrix(1,nrow=ntrain)

xc1tes <- xc1[seqc1[ntrain+1:50],]
yc1te <- matrix (0,nrow(50-ntrain))
