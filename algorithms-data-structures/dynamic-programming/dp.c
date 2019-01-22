//  DCC005 (TW2)
//  TP3: dp.c
//  Rubia Reis Guerra_2013031143

#include "dp.h"

void createThreads(int *row, int *col, int *sum, int nthreads, int N, int M)
{
	int i; // auxiliar

	pthread_t threads[nthreads]; // array de threads
	_tParams *params = (_tParams*) malloc(sizeof(_tParams) * nthreads); // array de parametros

	pthread_mutex_init(&lock_row,NULL);

	// cria threads por fork-join
	for(i = 0; i < nthreads; i++)
	{
		params[i].row = row;
		params[i].col = col;
		params[i].sum = sum;
		params[i].tid = i;
		params[i].size = N;
		params[i].M = M;
		params[i].nthreads = nthreads;
		pthread_create(&threads[i], NULL, maxRow, &params[i]);
	}
	
	// juncao de threads na thread principal
	for(i = 0; i < nthreads; i++)
		pthread_join(threads[i], NULL);

	// libera memoria
	free(params);
}

void *maxRow (void *_p)
{
	_tParams *p = (_tParams *) _p; // inicializa parametros
	int tid = p->tid; // thread id
	int endol = p->M; // fim da linha
	int chunk_size = (p->size / p->nthreads); // parte a ser iterada pela thread 
	int start = tid * chunk_size; // inicio da iteracao
	int end = start + chunk_size; // final da iteracao
	int i, j; // auxiliares


	for(j = start; j < end; j++)
	{
		pthread_mutex_lock(&lock_row);
		// le uma linha do grid
		for(i = 0; i < endol; i++)
			scanf(" %d", &p->row[i]);
		
		pthread_mutex_unlock(&lock_row);		
		// calcula soma maxima para a linha por PD
		p->col[j] = DP(p->sum,p->row,p->M);

	}

	return 0;
}


int DP(int *sum, int *row, int MAX)
{
    int i;

    // inicializa casos base com retorno 0
    sum[MAX] = sum[MAX+1] = 0;
    
    // caso recursivo
    for(i = MAX-1; i >= 0; i--)
        sum[i] = max(sum[i+2] + row[i], sum[i+1]);

    // retorna soma maxima da linha
    return (sum[0]);
}
