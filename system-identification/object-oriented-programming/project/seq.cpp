#include <iostream>
#include "seq.h"

/*********** Class Seq **********/
// Constructor
Seq::Seq(){
}
Seq::Seq(unsigned i){
    gen_elems(i);
}
// Destructor
Seq::~Seq(){
    while(!Seq::elements.empty()){
        Seq::elements.pop_back();
    }
}
// Return number of elements
unsigned Seq::length(){
	return elements.size();
}
// Generate elements until i
void Seq::gen_elems(unsigned i){
	for(unsigned j = length(); j < i; j++){
		Seq::elements.push_back(j);
	}
}
// Return the Element i
unsigned long Seq::elem(unsigned i){
	if (i >  length()){
		gen_elems(i);
	}
	return elements[i];
}

void Seq::print(ostream& os){
    for(unsigned i = 0; i < length(); i++){
		os << elements[i] << " ";
	}
}
// Overdrive operator << to print the entire Seq
ostream& operator<<(ostream& os, Seq& S){
    S.print(os);
	return os;
}

void Seq::printS(unsigned x, unsigned y){
    if (x < 0) x = 0;
    if (y > length()) y = length()-1;
    for(unsigned i = x; i <= y; i++){
		cout << elements[i] << " ";
	}
	cout << endl;
}

void Seq::empty(){
    while(!Seq::elements.empty()){
        Seq::elements.pop_back();
    }
}
/*********** Class Fibonacci **********/
// Constructor
Fibonacci::Fibonacci(){
    Fibonacci::elements.push_back(1);
	Fibonacci::elements.push_back(1);
	//Fibonacci::elements[0] = 1;
	//Fibonacci::elements[1] = 1;
}
Fibonacci::Fibonacci(unsigned i){
    Fibonacci::elements.push_back(1);
	Fibonacci::elements.push_back(1);
    gen_elems(i);
}
// Destructor
Fibonacci::~Fibonacci(){
    while(!Fibonacci::elements.empty()){
        Fibonacci::elements.pop_back();
    }
}
// Return the Element i
unsigned long Fibonacci::elem(unsigned i){
    if (i >  length()){
		Fibonacci::gen_elems(i);
	}
	return elements[i];
}
void Fibonacci::gen_elems(unsigned i){
    if(length() < 2){
        Fibonacci::elements.push_back(1);
        Fibonacci::elements.push_back(1);
    }
	for(unsigned j = Fibonacci::length(); j < i; j++){
		unsigned k = Fibonacci::length();
		unsigned long aux = Fibonacci::elements[k-2] + Fibonacci::elements[k-1];
		Fibonacci::elements.push_back(aux);
	}
}

/*********** Class Lucas **********/
// Constructor
Lucas::Lucas(){
    Lucas::elements.push_back(1);
    Lucas::elements.push_back(3);
	//Lucas::elements[0] = 1;
	//Lucas::elements[1] = 3;
}
Lucas::Lucas(unsigned i){
    Lucas::elements.push_back(1);
    Lucas::elements.push_back(3);
    gen_elems(i);
}
// Destructor
Lucas::~Lucas(){
    while(!Lucas::elements.empty()){
        Lucas::elements.pop_back();
    }
}
// Return the Element i
unsigned long Lucas::elem(unsigned i){
    if (i >  length()){
		Lucas::gen_elems(i);
	}
	return elements[i];
}
void Lucas::gen_elems(unsigned i){
    if(length() < 2){
        Lucas::elements.push_back(1);
        Lucas::elements.push_back(3);
    }
	for(unsigned j = Lucas::length(); j < i; j++){
		unsigned k = Lucas::length();
		unsigned long aux = Lucas::elements[k-2] + Lucas::elements[k-1];
		Lucas::elements.push_back(aux);
	}
}

/*********** Class Pell **********/
// Constructor
Pell::Pell(){
    Pell::elements.push_back(1);
    Pell::elements.push_back(2);
	//Pell::elements[0] = 1;
	//Pell::elements[1] = 2;
}
Pell::Pell(unsigned i){
    Pell::elements.push_back(1);
    Pell::elements.push_back(2);
    gen_elems(i);
}

// Destructor
Pell::~Pell(){
    while(!Pell::elements.empty()){
        Pell::elements.pop_back();
    }
}
// Return the Element i
unsigned long Pell::elem(unsigned i){
    if (i >  length()){
		Pell::gen_elems(i);
	}
	return elements[i];
}
void Pell::gen_elems(unsigned i){
    if(length() < 2){
        Pell::elements.push_back(1);
        Pell::elements.push_back(2);
    }
	for(unsigned j = Pell::length(); j < i; j++){
		unsigned k = Pell::length();
		unsigned long aux = 2*Pell::elements[k-1] + Pell::elements[k-2];
		Pell::elements.push_back(aux);
	}
}

/*********** Class Triangle **********/
// Constructor
Triangle::Triangle(){
    Triangle::elements.push_back(1);
	//Triangle::elements[0] = 1;
	//Triangle::elements[1] = 3;
}
Triangle::Triangle(unsigned i){
    Triangle::elements.push_back(1);
    gen_elems(i);
}
// Destructor
Triangle::~Triangle(){
    while(!Triangle::elements.empty()){
        Triangle::elements.pop_back();
    }
}
// Return the Element i
unsigned long Triangle::elem(unsigned i){
    if (i >  length()){
		Triangle::gen_elems(i);
	}
	return elements[i];
}
void Triangle::gen_elems(unsigned i){
    if(length() < 2){
        Triangle::elements.push_back(1);
    }
	for(unsigned j = Triangle::length(); j < i; j++){
		unsigned k = Triangle::length();
		unsigned long aux = Triangle::elements[k-1]+k+1;
		Triangle::elements.push_back(aux);
	}
}

/*********** Class Square **********/
// Constructor
Square::Square(){
    Square::elements.push_back(1);
    Square::elements.push_back(4);
	//Square::elements[0] = 1;
	//Square::elements[1] = 4;
}
Square::Square(unsigned i){
    gen_elems(i);
}
// Destructor
Square::~Square(){
    while(!Square::elements.empty()){
        Square::elements.pop_back();
    }
}
// Return the Element i
unsigned long Square::elem(unsigned i){
    if (i >  length()){
		Square::gen_elems(i);
	}
	return elements[i];
}
void Square::gen_elems(unsigned i){
	for(unsigned j = Square::length(); j < i; j++){
		unsigned k = Square::length();
		unsigned long aux = (k+1)*(k+1);
		Square::elements.push_back(aux);
	}
}

/*********** Class Pentagon **********/
// Constructor
Pentagon::Pentagon(){
    Pentagon::elements.push_back(1);
    Pentagon::elements.push_back(4);
	//Pentagon::elements[0] = 1;
	//Pentagon::elements[1] = 5;
}
Pentagon::Pentagon(unsigned i){
    gen_elems(i);
}
// Destructor
Pentagon::~Pentagon(){
    while(!Pentagon::elements.empty()){
        Pentagon::elements.pop_back();
    }
}
// Return the Element i
unsigned long Pentagon::elem(unsigned i){
    if (i >  length()){
		Pentagon::gen_elems(i);
	}
	return elements[i];
}
void Pentagon::gen_elems(unsigned i){
	for(unsigned j = Pentagon::length(); j < i; j++){
		unsigned k = Pentagon::length();
		unsigned long aux = (k+1)*(3*k+2)/2;
		Pentagon::elements.push_back(aux);
	}
}

/*********** Class Container **********/
// Constructor
Container::Container(){}
// Destructor
Container::~Container(){
    while(!Container::sequences.empty()){
        Container::sequences.pop_back();
    }
}
// Insert sequence into container
 void Container::insert(Seq S){
    Container::sequences.push_back(S);
}
unsigned Container::length(){
    return sequences.size();
}
// Print Container
void Container::print(){
    for(unsigned i = 0; i < length(); i++){
        std::cout << sequences[i] << std::endl;
    }
}

void Container::printS(unsigned x, unsigned y){
    for(unsigned i = 0; i < length(); i++){
        sequences[i].printS(x,y);
    }
}

void Container::printE(unsigned x){
    for(unsigned i = 0; i < length(); i++){
        cout << sequences[i].elements[x] << endl;
    }
}
