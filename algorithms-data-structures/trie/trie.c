//  DCC005 (TW2)
//  TP0: trie.c
//  Rubia Reis Guerra_2013031143

#include "trie.h"

// Calcula indices do array-alfabeto
int cIndex(char c)
{
    return ((int)c - (int)'a');
}

// Retorna novo no
Node *newTrie()
{
    // Novo no
    Node *node = NULL;
    // Aloca memoria
    node = (Node*)calloc(1, sizeof(Node));

    if (node)
    {
        int i;
        // Marca no como interno
        node->leaf = 0;
        // Inicializa filhos como null
        for (i = 0; i < ALPHABET_SIZE; i++) //O(c)
            node->branches[i] = NULL;
    }
    
    return node;
}

// Se a chave esta presente, ignora
// Senao, marca o no-folha
void insert(Node *root, const char *word)
{
    Node *tWalk = root; // Ponteiro que percorre a trie a partir da raiz

    int length = (int)strlen(word); // Distancia max. que o ponteiro percorre
    int index; // Indice no array-alfabeto
    int depth = 0; // Altura em relacao a raiz
        
    while (depth < length) //O(length)
    {
        index = cIndex(word[depth]);
        if (index < 0 || index > (ALPHABET_SIZE - 1))
            index = ALPHABET_SIZE - 1;

        // Se nao existe no correspondente ao indice
        // Cria novo no
        if (!tWalk->branches[index])
            tWalk->branches[index] = newTrie(); //O(c)
        
        // Segue novo no ou no existente
        tWalk = tWalk->branches[index];
        depth++;
    }
    
    // Marca a ocorrencia da palavra como 0
    tWalk->occurrence = 0;

    // Sinaliza o no-folha
    tWalk->leaf = 1;
}

// Retorna verdadeiro se a palavra esta na trie
void search(Node *root, const char *word)
{
    Node *tWalk = root; // Ponteiro que percorre a trie a partir da raiz

    int length = (int)strlen(word); // Distancia max. que o ponteiro percorre
    int index; // Indice no array-alfabeto
    int depth = 0; // Altura em relacao a raiz
    
    while(depth < length)
    {
        index = cIndex(word[depth]);
        if (index < 0 || index > (ALPHABET_SIZE - 1))
               index = ALPHABET_SIZE - 1;

        // Se nao existe no correspondente no indice
        // Sai do loop, palavra nao encontrada
        if (!tWalk->branches[index])
            break;
        
        // Em caso de match, continua a percorrer
        tWalk = tWalk->branches[index];
        
        depth++;
    }
    
    // Se a palavra for encontrada, incrementa a ocorrencia
    if(tWalk != NULL && tWalk->leaf)
        tWalk->occurrence += 1;
}

// Retorna a ocorrencia de uma palavra
int occurrence(Node *root, const char *word)
{
    Node *tWalk = root; // Ponteiro que percorre a trie a partir da raiz

    int length = (int)strlen(word); // Distancia max. que o ponteiro percorre
    int index; // Indice no array-alfabeto
    int depth = 0; // Altura em relacao a raiz
    
    while(depth < length)
    {
        index = cIndex(word[depth]);
        if (index < 0 || index > (ALPHABET_SIZE - 1))
               index = ALPHABET_SIZE - 1;
        
        // Se nao existe no correspondente no indice
        // Sai do loop, palavra nao encontrada
        if (!tWalk->branches[index])
            return 0;
        
        // Em caso de match, continua a percorrer
        tWalk = tWalk->branches[index];
        
        depth++;
    }
    
    // Se a palavra for encontrada, retorna a ocorrencia
    if(tWalk != NULL && tWalk->leaf)
        return tWalk->occurrence;
    else
        return 0;
}

// Libera memoria alocada
void freeTrie(Node *node)
{
   // Libera todos os nos filhos
   if (!node->leaf)
   {
        int i = 0;
        while(i < ALPHABET_SIZE)
        {
            if (node->branches[i])
            {
                freeTrie(node->branches[i]);
                node->branches[i] = NULL;
            }
            i++;
        }
    }
    // Libera no
    if (node != NULL)
    free(node);
    node = NULL;
}

void freeRoot(Node *root)
{
    if(root)    
        freeTrie(root);
}