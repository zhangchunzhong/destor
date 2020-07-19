CC ?= gcc
CXX ?= g++

override CFLAGS := -W -Wall -Wextra -pedantic -lm -O3 -Wno-unused-function -fPIC $(shell pkg-config --cflags glib-2.0) $(CFLAGS)
override CXXFLAGS := -W -Wall -Wextra -pedantic -O3 -fPIC $(shell pkg-config --cflags glib-2.0) $(CXXFLAGS)
override LDFLAGS  := $(shell pkg-config --libs glib-2.0) $(shell pkg-config --libs openssl) -lpthread $(LDFLAGS)


DESTORLIB_SRC = src/utils/bloom_filter.c  src/utils/lru_cache.c  src/utils/queue.c  src/utils/sds.c  src/utils/serial.c  src/utils/sync_queue.c \
		src/index/fingerprint_cache.c  src/index/index.c  src/index/kvstore.c  src/index/kvstore_htable.c  \
		src/index/sampling_method.c  src/index/segmenting_method.c  src/index/similarity_detection.c \
		src/chunking/ae_chunking.c  src/chunking/rabin_chunking.c \
		src/fsl/libhashfile.c  src/fsl/read_fsl_trace.c \
		src/recipe/recipestore.c src/storage/containerstore.c \
		src/assembly_restore.c src/cbr_rewrite.c src/chunk_phase.c src/config.c src/do_delete.c  \
		src/filter_phase.c src/hash_phase.c src/optimal_restore.c src/restore_aware.c src/trace_phase.c \
		src/cap_rewrite.c src/cfl_rewrite.c src/cma.c src/dedup_phase.c src/do_backup.c src/do_restore.c  \
		src/har_rewrite.c src/jcr.c src/read_phase.c src/rewrite_phase.c
DESTORLIB_OBJ := $(patsubst %.c,obj/%.o,$(DESTORLIB_SRC))
DESTORBIN_SRC := src/destor.c
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
