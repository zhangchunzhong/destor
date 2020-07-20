CC ?= gcc
CXX ?= g++

override CFLAGS := -W -Wall -Wextra -pedantic -lm -O3 -Wno-unused-function -fPIC $(shell pkg-config --cflags glib-2.0) -I src/include -I src/ $(CFLAGS) 
override CXXFLAGS := -W -Wall -Wextra -pedantic -O3 -fPIC $(shell pkg-config --cflags glib-2.0) -I src/include -I src/ $(CXXFLAGS)
override LDFLAGS  := $(shell pkg-config --libs glib-2.0) $(shell pkg-config --libs openssl) -lpthread $(LDFLAGS)


DESTORLIB_SRC = src/utils/bloom_filter.c  src/utils/lru_cache.c  src/utils/queue.c  src/utils/sds.c  src/utils/serial.c  src/utils/sync_queue.c src/utils/config.c src/utils/jcr.c \
		src/index/fingerprint_cache.c  src/index/index.c  src/index/kvstore.c  src/index/kvstore_htable.c  \
		src/index/sampling_method.c  src/index/segmenting_method.c  src/index/similarity_detection.c \
		src/chunking/ae_chunking.c  src/chunking/rabin_chunking.c \
		src/fsl/libhashfile.c  src/fsl/read_fsl_trace.c \
		src/recipe/recipestore.c src/storage/containerstore.c src/storage/cma.c \
		src/phase/chunk_phase.c  src/phase/dedup_phase.c  src/phase/filter_phase.c  src/phase/hash_phase.c  src/phase/read_phase.c  src/phase/rewrite_phase.c  src/phase/trace_phase.c \
		src/rewrite/cap_rewrite.c  src/rewrite/cbr_rewrite.c  src/rewrite/cfl_rewrite.c  src/rewrite/har_rewrite.c \
		src/action/do_backup.c  src/action/do_delete.c  src/action/do_restore.c \
		src/restore/assembly_restore.c  src/restore/optimal_restore.c  src/restore/restore_aware.c 

DESTORLIB_OBJ := $(patsubst %.c,obj/%.o,$(DESTORLIB_SRC))
DESTORBIN_SRC := src/cli/destor.c
DESTORBIN_OBJ := $(patsubst %.c,obj/%.o,$(DESTORBIN_SRC))

.PHONY: all  destor-cli libdestor.a libdestor

all: destor-cli libdestor.a libdestor

obj/%.o: %.c
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c $< -o $@

obj/%.o: %.cc
	@mkdir -p `dirname $@`
	$(CXX) $(CXXFLAGS) -c $< -o $@

obj/%.o: %.cpp
	@mkdir -p `dirname $@`
	$(CXX) $(CXXFLAGS) -c $< -o $@

# destor binary
destor-cli: $(DESTORLIB_OBJ) $(DESTORBIN_OBJ)
	$(CC) $^ $(CFLAGS) -o $@ $(LDFLAGS)

# Zopfli shared library
libdestor: $(DESTORLIB_OBJ)
	$(CC) $^ $(CFLAGS) -shared -Wl,-soname,libdestor.so.1 -o libdestor.so.0.0.1 $(LDFLAGS)

# Zopfli static library
libdestor.a: $(DESTORLIB_OBJ)
	ar rcs $@ $^

# Remove all libraries and binaries
clean:
	rm -rf destor-cli $(DESTORLIB_OBJ) $(DESTORBIN_OBJ)  libdestor* obj
