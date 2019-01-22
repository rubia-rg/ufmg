// gcc -std=c99 -o main main.c trie.c -lm

//  DCC005 (TW2)
//  TP0: main.c
//  Rubia Reis Guerra_2013031143

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "trie.h"


int main(int argc, char *argv[])
{
    
    int D, T; // Numero de palavras no dicionario e no texto
    long int i, j; // Auxiliares

    // dicionario
    char** dic = calloc(MAX_DIC, sizeof(char*));
    for (i = 0; i < MAX_DIC; i++)
        dic[i] = calloc(MAX_CHAR, sizeof(char));

    // Texto
    char** text = calloc(MAX_TEXT, sizeof(char*));
    for (i = 0; i < MAX_TEXT; i++)
        text[i] = calloc(MAX_CHAR, sizeof(char));
    
    // Arvore Trie
    Node *root = newTrie();
	
    if(root == NULL)
        return 1;
    // Tamanho do dicionario
    scanf("%d\n", &D);

    // Ler palavras e inserir na trie
    for(i = 0; i < D; i++)
    {
        for(j = 0; j < MAX_CHAR; j++)
        {
            scanf("%c", &dic[i][j]);
            if(isalpha(dic[i][j]) == 0)
            {
        		if(j <= (MAX_CHAR - 2))
                {    
                    dic[i][j] = '$';
                    dic[i][++j] = '\0';
                }
                else
                    dic[i][j] = '\0';
                break;
            }
        }
        insert(root, dic[i]);
    }

    // Tamanho do dicionario
    scanf("%d\n", &T);

    // Realoca memoria em caso de T > MAX_TEXT
    if(T > MAX_TEXT)
    {
        text = (char **) realloc(text, T*sizeof(char*));
        if(text == NULL)
            return 1;
    }
    // Pesquisar na arvore
    for(i = 0; i < T; i++)
    {
        for(j = 0; j < MAX_CHAR; j++)
        {
            scanf("%c", &text[i][j]);
            if(isalpha(text[i][j]) == 0)
            {
                if(j <= (MAX_CHAR - 2))
                {    
                    text[i][j] = '$';
                    text[i][++j] = '\0';
                }
                else
                    text[i][j] = '\0';
                break;
            }
        }
        search(root, text[i]);
    }

    // Imprimir o resultado
    for(i = 0; i < D; i++)
    {
        j = occurrence(root, dic[i]);
        if(i < (D - 1))
            printf("%li ", j);
        else
            printf("%li\n", j);
    }
    
    // Liberar memoria alocada
    // Dicionario
    for (i = 0; i < MAX_DIC; i++)
        free(dic[i]);
    free(dic);
    // Texto
    for (i = 0; i < MAX_TEXT; i++)
        free(text[i]);
    free(text);
    // Trie
    freeRoot(root);	
    
    return 0;
}
