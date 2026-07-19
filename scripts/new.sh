#!/bin/bash
set -e

# Usage: ./scripts/new.sh abc a 001
#   -> contests/abc/a/001/ を作成

if [ $# -lt 3 ]; then
    echo "Usage: $0 <contest-type> <problem-letter> <contest-number>"
    echo "Example: $0 abc a 001"
    exit 1
fi

CONTEST_TYPE="$1"
PROBLEM_LETTER="$2"
CONTEST_NUMBER="$3"
DIR="contests/${CONTEST_TYPE}/${PROBLEM_LETTER}/${CONTEST_NUMBER}"

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
name = "${CONTEST_TYPE}${CONTEST_NUMBER}_${PROBLEM_LETTER}"
version = "0.1.0"
edition = "2021"

[[bin]]
name = "$PROBLEM_LETTER"
path = "src/main.rs"

[dependencies]
lib = { path = "../../../../lib" }
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
echo "  cargo run -p ${CONTEST_TYPE}${CONTEST_NUMBER}_${PROBLEM_LETTER}"
