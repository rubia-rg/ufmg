//  DCC005 (TW2)
//  TP3: dp.h
//  Rubia Reis Guerra_2013031143

#ifndef DP_H
#define DP_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

#ifndef max
    #define max(a,b) ((a) > (b) ? (a) : (b))
#endif

typedef struct _tParams
{
	int N, M;
	int *row;
	int *sum;
	int *col;
	int tid;
	int size;
	int nthreads;
} _tParams;

int DP(int *sum, int *row, int MAX);
void *maxRow(void *p);
void createThreads(int *row, int *col, int *sum, int nthreads, int N, int M);
pthread_mutex_t lock_row;		
#endif
