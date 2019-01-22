//  DCC005 (TW2)
//  TP0: trie.h
//  Rubia Reis Guerra_2013031143

#ifndef TRIE_H
#define TRIE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Máximo de palavras do dicionario
#define MAX_DIC 100000
// Máximo de palavras do texto
#define MAX_TEXT 10000000
// Máximo de caracteres de uma palavra
#define MAX_CHAR 16
// Tamanho do alfabeto
#define ALPHABET_SIZE 27

typedef struct Node
{
    struct Node *branches[ALPHABET_SIZE]; // Array-alfabeto
    int leaf; // Sinaliza no-folha, 1 folha, 0 interno
    int occurrence; // Conta a ocorrencia da palavra
} Node;

// Retorna novo no
Node *newTrie();

// Calcula o indice
int cIndex(char c);

// Insere a chave 
void insert(Node *root, const char *word);

// Pesquisa no dicionario
void search(Node *root, const char *word);

// Retorna ocorrencia da palavra
int occurrence(Node *root, const char *word);

// Libera memoria alocada
void freeTrie(Node *node);
void freeRoot(Node *root);

#endif