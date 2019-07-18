#include <iostream>
#include <vector>
#include "seq.h"

using namespace std;

int main(){
    cout << "\nDRIVER DA CLASSE SEQ \n"
         << "Para vizualizar o driver da classe graph, \n"
         << "renomeie este arquivo para mainseq.cpp e o arquivo \n"
         << "maingraph.cpp para main.cpp. \n";

    Container C;
    Seq S;
    Fibonacci F;
    Lucas L;
    Pell P;
    Triangle T;
    Square Q;
    Pentagon G;
    int select1, select2, select3;
    unsigned n, x, y;
    cout << "**********Sequences Generator**********" << endl;
    while(1){
        cout << "Select what to do:" << endl;
        cout << "1 - Add Sequence\n";
        cout << "2 - Print Sequences\n";
        cout << "3 - Exit" << endl;
        cin >> select1;
        switch(select1){
            case 1:
                cout << "Which Sequence:" << endl;
                cout << "1 - Naturals\n";
                cout << "2 - Fibonacci\n";
                cout << "3 - Lucas\n";
                cout << "4 - Pell\n";
                cout << "5 - Triangle\n";
                cout << "6 - Square\n";
                cout << "7 - Pentagon\n";
                cin >> select2;
                cout << "Enter the number of elements: ";
                cin >> n;
                switch(select2){
                    case 1:
                        S.empty();
                        S.elem(n);
                        C.insert(S);
                        break;
                    case 2:
                        F.empty();
                        F.elem(n);
                        C.insert(F);
                        break;
                    case 3:
                        L.empty();
                        L.elem(n);
                        C.insert(L);
                        break;
                    case 4:
                        P.empty();
                        P.elem(n);
                        C.insert(P);
                        break;
                    case 5:
                        T.empty();
                        T.elem(n);
                        C.insert(T);
                        break;
                    case 6:
                        Q.empty();
                        Q.elem(n);
                        C.insert(Q);
                        break;
                    case 7:
                        G.empty();
                        G.elem(n);
                        C.insert(G);
                        break;
                }
                break;
            case 2:
                cout << "1 - Print everything\n";
                cout << "2 - Print section\n";
                cout << "3 - Print element" << endl;
                cin >> select3;
                switch(select3){
                    case 1:
                        C.print();
                        break;
                    case 2:
                        cout << "Enter the section:\n";
                        cout << "Start: ";
                        cin >> x;
                        cout << "Stop: ";
                        cin >> y;
                        C.printS(x,y);
                        break;
                    case 3:
                        cout << "Enter Element" << endl;
                        cin >> x;
                        C.printE(x);
                        break;
                }
                break;
            case 3:
                return 0;
                break;
            default:
                break;
        }
    }
}

