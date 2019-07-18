#ifndef GRAPH
#define GRAPH

#include <iostream>
#include <cstdlib>
#include <cstdbool>
#include <climits>
#include <ctime>
#include <list>

typedef int Edge[2]; 

class Graph{
	int** adjM; // matriz de adjacencia
	int num_vert; // num. de vertices
	int num_edge; // num. de arestas
public:
	Graph(const int V = 3); // construtor, aloca memoria
	~Graph(); // destrutor, desaloca memoria
	const bool insert(const Edge& E, const int w = 1); // insere aresta, true se inserir
	const bool remove(const Edge& E); // remove aresta, true se remover
	const bool edge(const Edge& E); // verifica se aresta pertence ao grafo
	const int getNumVertex(); // retorna num_vert
	const int getNumEdge(); // retorn num_edge
	const bool isComplete(); // verifica se o grafo e completo, true se completo
	void completeGraph(); // completa grafico
	void randEdge(); // completa grafo com pesos nas arestas
	void print();

	void BFS(const int V); // breadth first search
	void DFS(const int V); // depth first search
	void DFSUtil(int v, bool visited[]); // auxiliar de DFS

	int connComponents(); // retorna # componentes conectados
	void Dijkstra(const int I, const int F); //retorna menor caminho por Dijkstra
	void AGM(bool pcv = false); // resolve AGM
	int DUtil(int dist[], bool finalizado[]); // auxiliar de Dijkstra
	int AGMUtil(int minedge[], bool finalizado[]); // auxiliar de AGM
	void printAGM(int parent[]); // Imprime AGM
	void PCV(); //resolve PCV
};



#endif