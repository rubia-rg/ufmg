#ifndef SEQ
#define SEQ

#include <iostream>
#include <vector>

using namespace std;

/*********** Class Seq **********/
class Seq{
    public:
        std::vector<unsigned long int>elements;
        Seq();
        Seq(unsigned);
        ~Seq();
        unsigned length();
        unsigned long elem(unsigned i);
        void print(ostream&);
        friend ostream& operator<<(ostream&, Seq&);
        void printS(unsigned,unsigned);
        void empty();
    protected:
        void gen_elems(unsigned i);
};

/*********** Class Fibonacci **********/
class Fibonacci: public Seq{
    public:
        unsigned long elem(unsigned i);
        Fibonacci();
        Fibonacci(unsigned);
        ~Fibonacci();
    protected:
        void gen_elems(unsigned i);
};

/*********** Class Lucas **********/
class Lucas: public Seq{
public:
    unsigned long elem(unsigned i);
	Lucas();
	Lucas(unsigned);
	~Lucas();
protected:
	void gen_elems(unsigned i);
};

/*********** Class Pell **********/
class Pell: public Seq{
public:
    unsigned long elem(unsigned i);
	Pell();
	Pell(unsigned);
	~Pell();
protected:
	void gen_elems(unsigned i);
};

/*********** Class Triangle **********/
class Triangle: public Seq{
public:
    unsigned long elem(unsigned i);
	Triangle();
	Triangle(unsigned);
	~Triangle();
protected:
	void gen_elems(unsigned i);
};

/*********** Class Square **********/
class Square: public Seq{
public:
    unsigned long elem(unsigned i);
	Square();
	Square(unsigned);
	~Square();
protected:
	void gen_elems(unsigned i);
};

/*********** Class Pentagon **********/
class Pentagon: public Seq{
public:
    unsigned long elem(unsigned i);
	Pentagon();
	Pentagon(unsigned);
	~Pentagon();
protected:
	void gen_elems(unsigned i);
};
/********** Class Container **********/
class Container{;
public:
    std::vector<Seq>sequences;
    Container();
    ~Container();
    void insert(Seq);
    unsigned length();
    void print();
    void printS(unsigned,unsigned);
    void printE(unsigned);
};

#endif
