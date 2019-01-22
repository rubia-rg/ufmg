CC = gcc
CFLAGS = -Wall -Wextra -Werror -std=c99 -pedantic -pthread -Wno-error=unused-parameter
DEPS = dp.h
OBJ = tp3.o dp.o

%.o: %.c $(DEPS)
	$(CC) $(CFLAGS) -c -o $@ $<

tp3: $(OBJ)
	gcc $(CFLAGS) -o $@ $^
