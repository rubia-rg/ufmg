CC = g++
CFLAGS = -Wall -Wextra -Werror -std=c99 -pedantic -Wno-error=unused-parameter
DEPS = graph.h seq.h
OBJ = main.o graph.o seq.o

%.o: %.c $(DEPS)
	$(CC) $(CFLAGS) -c -o $@ $<

main: $(OBJ)
	g++ $(CFLAGS) -o $@ $^
