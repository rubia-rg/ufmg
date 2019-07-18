// gcc -std=c99 -o main main.c dp.c -lm

//  DCC005 (TW2)n
//  TP3: main.c
//  Rubia Reis Guerra_2013031143

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include "dp.h"

int main(int argc, char *argv[]){
    
    int numThreads = 1; // numero de threads
    int N, M; // dimensoes
    int sol = 0; // pop maxima

    // le as dimensoes do grid
    scanf("%d %d", &N, &M);    

	// aloca memoria
	int *row = calloc((M+2), sizeof(int)); // guarda a linha lida
	int *sum = calloc(((N*M)+2), sizeof(int)); // guarda a soma maxima da linha
	int *col = calloc(((N*M)+2), sizeof(int)); // coluna de somas maximas
    
	// recebe num de threads como parametro
    if (argc > 1)
	numThreads = atoi(argv[1]);
    if (numThreads > N)
        numThreads = N; // numero maximo de threads corresponde ao numero de colunas

	// inicializa threads
	createThreads(row,col,sum,numThreads,N,M);

    // encontra pop maxima utilizando PD
    sol = DP(sum,col,N);

	// libera memoria
	free(row);
	free(col);
	free(sum);

	// imprime o resultado
    printf("%d\n", sol);
    
	return 0;
}
