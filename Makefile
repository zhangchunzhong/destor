CC ?= gcc
CXX ?= g++

override CFLAGS := -W -Wall -Wextra -pedantic -lm -O3 -Wno-unused-function -fPIC $(shell pkg-config --cflags glib-2.0) -I src/include -I src/ $(CFLAGS) 
override CXXFLAGS := -W -Wall -Wextra -pedantic -O3 -fPIC $(shell pkg-config --cflags glib-2.0) -I src/include -I src/ $(CXXFLAGS)
override LDFLAGS  := $(shell pkg-config --libs glib-2.0) $(shell pkg-config --libs openssl) -lpthread -ldl $(LDFLAGS)


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
DESTOR_RUST_RELEASE := target/release/libdestor.a

.PHONY: all destor ${DESTOR_RUST_RELEASE}

all: destor ${DESTOR_RUST_RELEASE}

.PHONY: target/release/libdestor.a
target/release/libdestor.a:
	cargo build --verbose --release

obj/%.o: %.c
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c $< -o $@

# destor binary
destor: ${DESTOR_RUST_RELEASE}
	$(CC) $(CFLAGS) $(DESTORLIB_SRC) $(DESTORBIN_SRC) ${DESTOR_RUST_RELEASE} -o destor $(LDFLAGS)


# Remove all libraries and binaries
clean:
	rm -rf destor $(DESTORLIB_OBJ) $(DESTORBIN_OBJ)  libdestor* obj target
