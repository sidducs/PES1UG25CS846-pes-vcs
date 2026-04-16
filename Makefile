CC = gcc
CFLAGS = -Wall -Wextra -O2

all: pes

# Compile object files
object.o: object.c pes.h
	$(CC) $(CFLAGS) -c object.c -o object.o

tree.o: tree.c tree.h pes.h
	$(CC) $(CFLAGS) -c tree.c -o tree.o

index.o: index.c index.h pes.h
	$(CC) $(CFLAGS) -c index.c -o index.o

commit.o: commit.c pes.h
	$(CC) $(CFLAGS) -c commit.c -o commit.o

pes.o: pes.c pes.h
	$(CC) $(CFLAGS) -c pes.c -o pes.o

# Link final executable
pes: object.o tree.o index.o commit.o pes.o
	$(CC) -o pes object.o tree.o index.o commit.o pes.o -lcrypto

# Test targets
test_objects: test_objects.o object.o
	$(CC) -o test_objects test_objects.o object.o -lcrypto

test_tree: test_tree.o object.o tree.o
	$(CC) -o test_tree test_tree.o object.o tree.o -lcrypto

# Compile test files
test_objects.o: test_objects.c
	$(CC) $(CFLAGS) -c test_objects.c -o test_objects.o

test_tree.o: test_tree.c
	$(CC) $(CFLAGS) -c test_tree.c -o test_tree.o

# Clean
clean:
	rm -f pes test_objects test_tree *.o
	rm -rf .pes
