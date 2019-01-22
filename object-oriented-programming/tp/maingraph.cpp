#include <iostream>
#include "graph.h"

// TESTE DA CLASSE GRAPH //
using namespace std;

int main()
{
    cout << "\nDRIVER DA CLASSE GRAPH \n"
         << "Para vizualizar o driver da classe seq, \n"
         << "renomeie este arquivo para maingraph.cpp e o arquivo \n"
         << "mainseq.cpp para main.cpp. \n";

    int cc, V = 6;
    Graph g(V);
    Edge e;

    cout << "\nFollowing inserts edges: \n";
    e[0] = 4, e[1] = 1;
    if(g.insert(e)) cout << *e << *(e+1) << endl;
    e[0] = 1, e[1] = 2;
    if(g.insert(e)) cout << *e << *(e+1) << endl;
    e[0] = 3, e[1] = 1;
    if(g.insert(e)) cout << *e << *(e+1) << endl;
    e[0] = 5, e[1] = 3;
    if(g.insert(e)) cout << *e << *(e+1) << endl;
    e[0] = 2, e[1] = 3;
    if(g.insert(e)) cout << *e << *(e+1) << endl;
 
    cout << "\nFollowing prints the graph: \n";
    g.print();

    cout << "\nFollowing is Breadth First Search"
         << " (starting from vertex 1): ";
    g.BFS(1);
    
    cout << "\nFollowing is Depth First Search"
         << " (starting from vertex 1): ";
    g.DFS(1);
    
    cout << "\nFollowing is distance from "
         << "vertex 0 to 3: ";
    g.Dijkstra(0,3);

    cout << "\nFollowing is distance from "
         << "vertex 3 to 5: ";
    g.Dijkstra(3,5);

    cout << "\nFollowing are connected components: ";
    cc = g.connComponents();

    cout << "Following are: \n -> num_vert: " << g.getNumVertex() 
    << "\n -> num_edge: " << g.getNumEdge();

    cout << "\nFollowing completes graph with weighted edges.";
    g.randEdge();

    cout << "\nFollowing checks if graph is complete: "
    << g.isComplete();
    
    cout << "\nFollowing completes the graph.";
    g.completeGraph();
    
    cout << "\nFollowing checks if graph is complete: " << g.isComplete();

    e[0] = 0, e[1] = 1;
    cout << "\nFollowing removes edge (0,1): " << g.remove(e);
    e[1] = 8;
    cout << "\nFollowing removes edge (0,8): " << g.remove(e);

    cout << "\nFollowing prints the graph: \n";
    g.print();

    cout << "\nFollowing finds MST: \n";
    g.AGM();

    cout << "\nFollowing solves TSP: \n";
    g.PCV();

    return 0;
}