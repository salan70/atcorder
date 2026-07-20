set shell := ["bash", "-euc"]

# 利用可能なコマンドを表示する
default:
    @just --list

# workspace 全体をビルドする
build:
    cargo build --workspace

# workspace 全体をチェックする
check:
    cargo check --workspace --all-targets

# workspace 全体のテストを実行する
test:
    cargo test --workspace

# Rust コードを整形する
fmt:
    cargo fmt --all

# Rust コードが整形済みか確認する
fmt-check:
    cargo fmt --all -- --check

# Clippy で静的解析する
clippy:
    cargo clippy --workspace --all-targets -- -D warnings

# 提出前の一括検証を実行する
verify: fmt-check check clippy test

# 新しい問題を作成する（例: just new abc456_a）
new bin_name:
    #!/usr/bin/env bash
    set -euo pipefail
    NAME="{{ bin_name }}"
    SRC="rust/src/${NAME}.rs"
    if [ -f "$SRC" ]; then echo "Error: $SRC already exists"; exit 1; fi
    cp templates/main.rs "$SRC"
    mkdir -p "rust/tests/${NAME}"
    touch "rust/tests/${NAME}/input.txt" "rust/tests/${NAME}/output.txt"
    # Cargo.toml に [[bin]] を追加
    printf '\n[[bin]]\nname = "%s"\npath = "src/%s.rs"\n' "$NAME" "$NAME" >> rust/Cargo.toml
    echo "Created rust/src/${NAME}.rs"

# サンプル入力で解答を実行する（例: just run abc456_a）
run bin_name:
    cargo run --quiet -p rust --bin "{{ bin_name }}" < "rust/tests/{{ bin_name }}/input.txt"

# サンプル出力と解答を比較する（例: just sample abc456_a）
sample bin_name:
    #!/usr/bin/env bash
    set -euo pipefail
    actual="$(mktemp)"
    trap 'rm -f "$actual"' EXIT
    cargo run --quiet -p rust --bin "{{ bin_name }}" < "rust/tests/{{ bin_name }}/input.txt" > "$actual"
    diff -u "rust/tests/{{ bin_name }}/output.txt" "$actual"
