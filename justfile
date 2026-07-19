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

# 新しい問題ディレクトリを作成する（例: just new abc a 001）
new contest_type problem_letter contest_number:
    ./scripts/new.sh "{{ contest_type }}" "{{ problem_letter }}" "{{ contest_number }}"

# サンプル入力で解答を実行する（例: just run abc a 001）
run contest_type problem_letter contest_number:
    cargo run --quiet -p "{{ contest_type }}{{ contest_number }}_{{ problem_letter }}" < "contests/{{ contest_type }}/{{ problem_letter }}/{{ contest_number }}/tests/input.txt"

# サンプル出力と解答を比較する（例: just sample abc a 001）
sample contest_type problem_letter contest_number:
    #!/usr/bin/env bash
    set -euo pipefail
    actual="$(mktemp)"
    trap 'rm -f "$actual"' EXIT
    cargo run --quiet -p "{{ contest_type }}{{ contest_number }}_{{ problem_letter }}" < "contests/{{ contest_type }}/{{ problem_letter }}/{{ contest_number }}/tests/input.txt" > "$actual"
    diff -u "contests/{{ contest_type }}/{{ problem_letter }}/{{ contest_number }}/tests/output.txt" "$actual"
