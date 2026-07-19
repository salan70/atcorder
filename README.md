# atcorder

Rust で AtCoder に取り組むための Cargo workspace

## 初期セットアップ

```sh
git clone <repo-url>
cd atcorder
cargo build
```

## 問題に取り組む流れ

### 1. 問題ディレクトリを生成

```sh
./scripts/new.sh abc a 001
```

`contests/abc/a/001/` が作成される。Cargo.toml の workspace members にも自動追加される。

### 2. サンプル入出力をセットアップ

- `contests/abc/a/001/tests/input.txt` に入力を貼る
- `contests/abc/a/001/tests/output.txt` に期待出力を貼る

### 3. 解答を書く

`contests/abc/a/001/src/main.rs` を編集する。

`lib` に共通ユーティリティ関数が用意されている:

| 関数 | 説明 |
|------|------|
| `read_int()` | 整数1つ読み取り |
| `read_ints()` | 整数をスペース区切りで Vec に |
| `read_ints2()` | 整数2つを tuple で |
| `read_ints3()` | 整数3つを tuple で |
| `read_usize()` | usize 1つ読み取り |
| `read_usizes()` | usize を Vec に |
| `read_chars()` | 文字列を Vec<char> に |
| `read_lines(n)` | n 行読み取り |
| `yes()` / `no()` | Yes/No 出力 |
| `yesno(cond)` | bool に応じて Yes/No 出力 |

### 4. 実行・テスト

```sh
# 実行（サンプル入力をパイプで渡す）
cat contests/abc/a/001/tests/input.txt | cargo run -p abc001_a

# 期待出力と比較
cat contests/abc/a/001/tests/input.txt | cargo run -p abc001_a | diff - contests/abc/a/001/tests/output.txt
```

## ディレクトリ構成

```
.
├── lib/                  # 共通ユーティリティ
├── templates/            # 新規問題のテンプレート
├── scripts/              # 新規ディレクトリ生成スクリプト
├── contests/
│   └── abc/              # コンテスト種別 (abc, arc, agc...)
│       ├── a/            # 問題番号
│       │   └── 001/      # 回番号
│       │       ├── Cargo.toml
│       │       ├── src/main.rs
│       │       └── tests/
│       │           ├── input.txt
│       │           └── output.txt
│       ├── b/
│       │   └── 001/
│       │       └── ...
│       └── c/
│           └── ...
└── Cargo.toml            # workspace 定義
```

## ビルド設定

`.cargo/config.toml` で dev ビルドに `opt-level = 1` を設定済み。`--release` なしでも十分な速度で実行できる。
