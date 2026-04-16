//Phase 3: Initialize index
//Phase 3: Add load/save logic
//Phase 3: Implement index_add
//Phase 3: Add directory handling


#include "index.h"
#include "pes.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INDEX_FILE ".pes/index"

// Load index from file (binary)
int index_load(Index *idx) {

    idx->count = 0;

    FILE *f = fopen(INDEX_FILE, "rb");
    if (!f) return 0;

    fread(idx, sizeof(Index), 1, f);

    fclose(f);
    return 0;
}

// Save index to file (binary)
int index_save(const Index *idx) {

    FILE *f = fopen(INDEX_FILE, "wb");
    if (!f) return -1;

    fwrite(idx, sizeof(Index), 1, f);

    fclose(f);
    return 0;
}

// Add file to index
int index_add(Index *idx, const char *path) {

    FILE *f = fopen(path, "rb");
    if (!f) return -1;

    fseek(f, 0, SEEK_END);
    size_t size = ftell(f);
    rewind(f);

    void *data = malloc(size);
    fread(data, 1, size, f);
    fclose(f);

    ObjectID id;
    object_write(OBJ_BLOB, data, size, &id);

    free(data);

    // update if exists
    for (int i = 0; i < idx->count; i++) {
        if (strcmp(idx->entries[i].path, path) == 0) {
            idx->entries[i].hash = id;
            return 0;
        }
    }

    // new entry
    strcpy(idx->entries[idx->count].path, path);
    idx->entries[idx->count].hash = id;
    idx->entries[idx->count].mode = 0100644;

    idx->count++;

    return 0;
}

// REQUIRED by pes.c (fixes linker error)
int index_status(const Index *idx) {

    printf("Index contains %d entries:\n", idx->count);

    for (int i = 0; i < idx->count; i++) {
        printf("%o %s\n",
               idx->entries[i].mode,
               idx->entries[i].path);
    }

    return 0;
}

