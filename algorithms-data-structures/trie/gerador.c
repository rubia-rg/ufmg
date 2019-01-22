#include <stdio.h>
#include <stdlib.h>
#include <time.h>
 
#define WORD_SIZE 15
#define DICTIONARY_SIZE 100000
#define TEXT_SIZE 10000000
 
char randomString[WORD_SIZE];
 
void make_random_string(int length) {
 
    static char charset[] = "abcdefghijklmnopqrstuvwxyz";
 
    for (int n = 0; n < length; ++n) {
        int key = rand() % (int)(sizeof(charset)-1);
        randomString[n] = charset[key];
    }
 
    randomString[length] = '\0';
 
}
 
int main(){
 
    FILE *arqout;
    arqout = fopen("1k.txt", "w");
 
    srand (time(NULL));
 
    fprintf(arqout, "%d\n", DICTIONARY_SIZE);
    for(int i = 0; i < DICTIONARY_SIZE; ++i){
        if(i != DICTIONARY_SIZE-1){
            make_random_string(WORD_SIZE);
            fprintf(arqout, "%s ", randomString);
        }
        else{
            make_random_string(WORD_SIZE);
            fprintf(arqout, "%s", randomString);
        }
    }
 
    fprintf(arqout, "\n%d\n", TEXT_SIZE);
    for(int i = 0; i < TEXT_SIZE; ++i){
        if(i != TEXT_SIZE-1){
            make_random_string(WORD_SIZE);
            fprintf(arqout, "%s ", randomString);
        }
        else{
            make_random_string(WORD_SIZE);
            fprintf(arqout, "%s", randomString);
        }
    }
 
    fclose(arqout);
    return 0;
}