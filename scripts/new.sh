#!/bin/bash
set -e

# Usage: ./scripts/new.sh abc001 a
#   -> abc001_a を作成

if [ $# -lt 2 ]; then
    echo "Usage: $0 <contest> <problem>"
    echo "Example: $0 abc001 a"
    exit 1
fi

CONTEST="$1"
PROBLEM="$2"
DIR="${CONTEST}_${PROBLEM}"

if [ -d "$DIR" ]; then
    echo "Error: $DIR already exists"
    exit 1
fi

# Create directory structure
mkdir -p "$DIR/src"
mkdir -p "$DIR/tests"

# Create Cargo.toml
cat > "$DIR/Cargo.toml" << EOF
[package]
name = "$DIR"
version = "0.1.0"
edition = "2021"

[[bin]]
name = "$PROBLEM"
path = "src/main.rs"

[dependencies]
lib = { path = "../lib" }
EOF

# Create main.rs from template
cp templates/main.rs "$DIR/src/main.rs"

# Create sample test files
touch "$DIR/tests/input.txt"
touch "$DIR/tests/output.txt"

# Add to workspace Cargo.toml
ROOT_TOML="Cargo.toml"
if ! grep -q "\"$DIR\"" "$ROOT_TOML"; then
    # 最後の ] の前に追加
    sed -i.bak "s/\]/, \"$DIR\"]/" "$ROOT_TOML"
    rm -f "$ROOT_TOML.bak"
fi

echo "Created $DIR/"
echo "  cargo run -p $DIR"
