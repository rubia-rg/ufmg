#include "graph.h"

Graph::Graph(const int V){
  num_edge = 0;
	num_vert = V;
	adjM = new int*[num_vert];
	
  for (int i = 0; i < num_vert; ++i){
    adjM[i] = new int[num_vert];
    for (int j = 0; j < num_vert; ++j){    
			adjM[i][j] = 0;
		}
  }
}

Graph::~Graph(){
	for (int i = 0; i < num_vert; ++i)
    	delete [] adjM[i];
	delete [] adjM;
}

const bool Graph::insert(const Edge& E, const int w){
  if(!w || E[0] == E[1]|| E[0] >= num_vert || E[1] >= num_vert){
    return false;
	} else if(this->edge(E)){
    return false;
  } else{	
		adjM[E[0]][E[1]] = adjM[E[1]][E[0]] = w;
		num_edge++;
		return true;
	}
}

const bool Graph::edge(const Edge& E){
	if(E[0] >= num_vert || E[1] >= num_vert || E[0] == E[1]) 
    return false;
  else if (!adjM[E[0]][E[1]])
		return false;
	else
		return true;
}

const bool Graph::remove(const Edge& E){
	if(!this->edge(E)){
		return false;
	} else{	
		adjM[E[0]][E[1]] = adjM[E[1]][E[0]] = 0;
		num_edge--;
		return true;
	}	
}

const int Graph::getNumVertex(){
	return num_vert;
}

const int Graph::getNumEdge(){
	return num_edge;
}

const bool Graph::isComplete(){
	for (int i = 0; i < num_vert; ++i){
		for (int j = 0; j < num_vert; ++j){
			Edge E = {i,j};
      if(i != j && !this->edge(E))
				return false;
		}
	}
	return true;
}

void Graph::print(){
  for (int i = 0; i < num_vert; ++i){
    for (int j = 0; j < num_vert; ++j){
      std::cout << adjM[i][j] << "\t";
    }
    std::cout << std::endl;
  }
}

void Graph::completeGraph(){
  if(!this->isComplete()){
    for (int i = 0; i < num_vert; ++i){
      for (int j = 0; j < num_vert; ++j){
        Edge E = {i,j};
        if(i != j && !this->edge(E)){ 
          adjM[i][j] = adjM[j][i] = 1;
          num_edge++;
        }
      }
    }
  }
}

void Graph::randEdge(){
  srand((unsigned)time(0)); 
  for (int i = 0; i < num_vert; ++i){
    for (int j = 0; j < num_vert; ++j){
      if(i != j){
        adjM[i][j] = adjM[j][i] = (rand()%10)+1;
        num_edge++;
      }
    }
  }
}

void Graph::BFS(const int V){

  // Verifica se o vertice fornecido e valido
  if(V > num_vert || !V){
  	std::cout << "\nVertice invalido!";
  	return;
  }

  int vertex = V;

  // Marca todos os vertices como nao visitados
  bool *visited = new bool[num_vert];
  for(int i = 0; i < num_vert; i++)
      visited[i] = false;

  // Cria uma fila para BFS
  std::list<int> queue;

  // Marca o vertice fornecido como visitado
  // e coloca-o na fila
  visited[vertex] = true;
  queue.push_back(vertex);

  while(!queue.empty())
  {
    // Remove o primeiro vertice da fila
    vertex = queue.front();
    std::cout << vertex << " ";
    queue.pop_front();

    // Encontra todos os vertices adjacentes ao
    // vertice desempilhado.
    // Se o adjacente nao foi visitado, marca-o como
    // visitado e coloca-o na fila

    for(int i = 0; i < num_vert; ++i){
      if(adjM[vertex][i]){
        if(!visited[i]){
          visited[i] = true;
          queue.push_back(i);
      	}
      }
    }
  }
  delete[] visited;
}

void Graph::DFSUtil(int v, bool visited[]){
	// Marca o vertice como visitado e imprime
  visited[v] = true;
  std::cout << v << " ";

  // Recorre para todos os vertices adjacentes a (v)
  for(int i = 0; i < num_vert; ++i){    
  	if(v != i && adjM[v][i])
      if(!visited[i])
        DFSUtil(i, visited);
  }
}

void Graph::DFS(const int V){
	if(V > num_vert || V < 0){
  	std::cout << "DFS error: vertice invalido!" << std::endl;
  	return;
  }

  // Marca todos os vertices como nao visitados
  bool *visited = new bool[num_vert];
  for (int i = 0; i < num_vert; i++)
      visited[i] = false;
	
  // Chama a funcao auxiliar para o vertice V
	DFSUtil(V, visited);

  // Desaloca memoria
  delete[] visited;
}

int Graph::connComponents(){ 
  // retorna # componentes conectados
  int cc = 0;
  // Marca todos os vertices como nao visitados
  bool *visited = new bool[num_vert];
  for(int i = 0; i < num_vert; i++)
      visited[i] = false;

  for (int i = 0; i < num_vert; i++){
    if (visited[i] == false){
        // Imprime todos os vertices alcaveis
        // a partir de (i)
      cc++;
      std::cout << "\n -> Component " << cc <<": ";
      DFSUtil(i, visited);
    }
  } 
  delete[] visited;
  std::cout << "\n -> # of connected components: " << cc << std::endl;
  return cc;
}

void Graph::Dijkstra(const int I, const int F){ //retorna menor caminho por Dijkstra e imprime resultado
  int dist[num_vert]; // Guarda a menor distancia de I ate i
  bool finalizado[num_vert]; // Marca se a menor distancia entre I e i foi encontrada
  
  // Inicializa todas as distancias como infinitas e finalizado[] como falso
  for (int i = 0; i < num_vert; i++){  
    dist[i] = INT_MAX, finalizado[i] = false;
  }
  
  // Distancia de I para I e 0
  dist[I] = 0;
  
  // Encontra o menor caminho para todos os vertices
  for (int i = 0; i < num_vert-1; i++){
    // Escolhe o menor caminho de um conjunto de vertices ainda 
    // nao processados
    // Na primeira iteracao, u = I
    int u = DUtil(dist, finalizado);

    // Marca o vertice como finalizado
    finalizado[u] = true;

    // Atualiza o valor de dist para os vertices adjacentes ao escolhido
    for (int v = 0; v < num_vert; v++){
      if (!finalizado[v] && adjM[u][v] && dist[u] != INT_MAX && dist[u]+adjM[u][v] < dist[v])
        dist[v] = dist[u] + adjM[u][v];
    }
    // Atualiza dist[v] somente se v nao tiver sido processado, se adj[u][v]
    // e valido, e se a distancia total de I para v por u e 
    // menor que dist[v]
  }
  
  // Imprime INF se os vertices estao desconectados
  // ou o menor caminho de I a F se estiver conectado
  if(dist[F] == INT_MAX)
    std::cout << "INF";
  else 
    std::cout << dist[F];
}

int Graph::DUtil(int dist[], bool finalizado[]){
  // Inicializa o minimo com INF
  int min = INT_MAX, min_index;
  
  for (int v = 0; v < num_vert; v++)
    if (!finalizado[v] && dist[v] <= min)
      min = dist[v], min_index = v;
  return min_index;
}

void Graph::AGM(bool pcv){
  std::streambuf *old = std::cout.rdbuf(0); // omite std::cout de connComponents()
  if(this->connComponents() > 1){ // Verifica se todos os vertices sao alcancaveis
    std::cout.rdbuf(old);
    std::cout << "AGM error: grafo possui mais de um componente conectado!" << std::endl;
    return;
  }
  std::cout.rdbuf(old);

  int parent[num_vert]; // Guarda a arvore geradora minima construida
  int minedge[num_vert];   //  Valores de peso utilizados 
  // para escolher a aresta de menor peso no momento da poda
  bool finalizado[num_vert];  // Marca se o vertice i ja foi processado

  int rota[num_vert+1]; // Solucao do PCV

  // Inicializa todas as distancias como infinitas e finalizado[] como falso
  for (int i = 0; i < num_vert; i++)
    minedge[i] = INT_MAX, finalizado[i] = false;

  // Distancia de I para I e 0
  // Incluir primeiro o vertice inicial na AGM
  minedge[0] = 0;    // Faz com ind seja 0 para que i = 0 seja escolhido primeiro
  parent[0] = -1; // Inicializa o primeiro vertice no como raiz
  
  // A AGM tera V vertices
  for (int i = 0; i < num_vert-1; i++){
    // Escolhe o vertice de menor peso a partir do conjunto de vertices
    // ainda nao processados
    int u = AGMUtil(minedge, finalizado);

    // Adiciona o vertice escolhido ao vetor de finalizados
    finalizado[u] = true;
    rota[i] = u;

    // Atualiza minedge e o indice-pai dos vertices adjacentes ao escolhido.
    // Considera apenas os vertices ainda nao finalizados
    for (int v = 0; v < num_vert; v++)
    // Atualiza minedge[v] e parent[v] somente se v nao tiver sido processado, se adj[u][v]
    // e valido, e se a aresta (u,v) for menor que a aresta atual minedge[v]
      if (adjM[u][v] && !finalizado[v] && adjM[u][v] <  minedge[v])
        parent[v] = u, minedge[v] = adjM[u][v];
  }
  // Imprime o resultado
  printAGM(parent);

  if(pcv){ // Resultado do PCV
    int cost = 0;
    rota[num_vert] = 0; // Vertice final = inicial
    for (int j = 0; j < num_vert; ++j) // Encontra vertice faltante da caminhada transversal
    {
      for (int i = 0; i < num_vert; ++i)
      {
        if(j == rota[i])
          break;
        else if(i == num_vert-1)
          rota[i] = j;
      }
    }
    std::cout << "Rota: ";
    for (int i = 0; i < num_vert; ++i){ // Imprime a rota e
      cost += adjM[rota[i]][rota[i+1]]; // calcula a distancia
      std::cout << rota[i] << "->";
    }
    std::cout << rota[num_vert] << std::endl;
    std::cout << "Distância: " << cost << std::endl; // Imprime a distancia
  }
}

int Graph::AGMUtil(int minedge[], bool finalizado[]){
  // Inicializa o minimo com INF
   int min = INT_MAX, min_index;
 
   for (int v = 0; v < num_vert; v++)
     if (!finalizado[v] && minedge[v] < min)
         min = minedge[v], min_index = v;
   return min_index;
}

void Graph::printAGM(int parent[]){ 
  // Funcao auxiliar para imprimir a AGM guardada em parent[]
  printf("Edge   Weight\n");
  for (int i = 1; i < num_vert; i++)
    printf("%d - %d    %d \n", parent[i], i, adjM[i][parent[i]]);
}

void Graph::PCV(){
  //resolve PCV  e imprime resultado
  if(!this->isComplete())
    randEdge();
  std::cout << "Graph: " << std::endl;
  print();
  std::cout << "AGM: " << std::endl;
  this->AGM(true);
}