#include "index.h"
#include "pes.h"
#include "object.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INDEX_FILE ".pes/index"

int index_load(Index *idx) {

    idx->count = 0;

    FILE *f = fopen(INDEX_FILE, "rb");
    if (!f) return 0;

    fread(idx, sizeof(Index), 1, f);

    fclose(f);
    return 0;
}

int index_save(const Index *idx) {

    FILE *f = fopen(INDEX_FILE, "wb");
    if (!f) return -1;

    fwrite(idx, sizeof(Index), 1, f);

    fclose(f);
    return 0;
}

int index_add(Index *idx, const char *path) {

    // read file content
    FILE *f = fopen(path, "rb");
    if (!f) return -1;

    fseek(f, 0, SEEK_END);
    size_t size = ftell(f);
    rewind(f);

    void *data = malloc(size);
    fread(data, 1, size, f);
    fclose(f);

    // store as blob
    ObjectID id;
    object_write(OBJ_BLOB, data, size, &id);

    free(data);

    // check if exists
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
