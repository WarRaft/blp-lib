# Makefile for compiling blp-lib usage examples

CC = gcc
CFLAGS = -Wall -Wextra -std=c99
INCLUDES = -I. -Iinclude
LIBDIR = target/release
LIBS = -L$(LIBDIR) -lblp_lib

# Platform detection
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    # macOS
    LDFLAGS = -ldl
    LIB_EXT = dylib
else ifeq ($(UNAME_S),Linux)
    # Linux
    LDFLAGS = -ldl -lpthread
    LIB_EXT = so
else
    # Windows (assuming MinGW)
    LDFLAGS = 
    LIB_EXT = dll
endif

EXAMPLE_DIR = examples
BUILD_DIR = build

# Targets
.PHONY: all clean rust examples test

all: rust examples

# Compile Rust library
rust:
	@echo "Compiling Rust library..."
	cargo build --release

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Compile C examples
examples: $(BUILD_DIR) rust examples/blp_test examples/encode_file examples/decode_file examples/encode_dir examples/decode_dir
	@echo "All C examples built."

examples/blp_test: $(EXAMPLE_DIR)/blp_test.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $(BUILD_DIR)/blp_test $(EXAMPLE_DIR)/blp_test.c $(LIBS) $(LDFLAGS)
	@echo "Built: $(BUILD_DIR)/blp_test"

examples/encode_file: $(EXAMPLE_DIR)/encode_file.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $(BUILD_DIR)/encode_file $(EXAMPLE_DIR)/encode_file.c $(LIBS) $(LDFLAGS)
	@echo "Built: $(BUILD_DIR)/encode_file"

examples/decode_file: $(EXAMPLE_DIR)/decode_file.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $(BUILD_DIR)/decode_file $(EXAMPLE_DIR)/decode_file.c $(LIBS) $(LDFLAGS)
	@echo "Built: $(BUILD_DIR)/decode_file"

examples/encode_dir: $(EXAMPLE_DIR)/encode_dir.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $(BUILD_DIR)/encode_dir $(EXAMPLE_DIR)/encode_dir.c $(LIBS) $(LDFLAGS)
	@echo "Built: $(BUILD_DIR)/encode_dir"

examples/decode_dir: $(EXAMPLE_DIR)/decode_dir.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $(BUILD_DIR)/decode_dir $(EXAMPLE_DIR)/decode_dir.c $(LIBS) $(LDFLAGS)
	@echo "Built: $(BUILD_DIR)/decode_dir"

# Testing
test: rust
	@echo "Running Rust tests..."
	cargo test

# Clean
clean:
	@echo "Cleaning..."
	cargo clean
	rm -rf $(BUILD_DIR)

# Install library system-wide (optional)
install: rust
	@echo "Installing library..."
	sudo cp $(LIBDIR)/libblp_lib.$(LIB_EXT) /usr/local/lib/
	sudo cp include/blp_lib.h /usr/local/include/
	@echo "Library installed to /usr/local/"

# Help
help:
	@echo "Available commands:"
	@echo "  make all      - Compile everything (Rust + examples)"
	@echo "  make rust     - Compile only Rust library"
	@echo "  make examples - Compile C examples"
	@echo "  make test     - Run tests"
	@echo "  make clean    - Clean build files"
	@echo "  make install  - Install library system-wide"
	@echo "  make help     - Show this help"