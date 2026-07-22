# AtCoder practice in Rust

Rust で AtCoder の A・B 問題を解くための練習環境。
コーディングはローカル（Zed / Cursor）で行い、提出はブラウザにコピペする運用。

## 最初の 1 回だけ: セットアップ

[Nix](https://nixos.org/) と [direnv](https://direnv.net/)（推奨）が入っていれば、リポジトリ直下で:

```sh
direnv allow
```

これだけで rustc・rust-analyzer・oj・`just` がすべて使えるようになる。
direnv を使わない場合は、作業のたびに `nix develop` でシェルに入る。

## ふだんの流れ

コンテスト（例: abc300）の A 問題を解くときの流れは 4 ステップ:

```sh
just new abc300       # 1. 問題ファイルを作成（デフォルトで a, b の 2 つ）
                      # 2. src/bin/abc300_a/main.rs をエディタで解く
just test abc300 a    # 3. サンプルケースでテスト（初回は oj が自動ダウンロード）
just done abc300 a    # 4. 提出して AC したら done/ へ移動
```

テストが全部通ったら、ファイルの中身をブラウザの提出フォームにコピペして提出する。
**提出時の言語は Rust (rustc 1.89.0) を選ぶこと。**

AC したら `just done` で `src/bin/done/` に移動する。`src/bin/` 直下には
作業中の問題だけが残る運用。done に移した問題はビルド対象から外れるので、
`just test` や `just run` を使いたくなったら `just undone` でいったん戻す。

### コマンド一覧

| コマンド | 短縮形 | 動作 |
|---|---|---|
| `just new <contest> [problems...]` | `just n` | テンプレートから問題ファイルを作成（省略時は a b） |
| `just test <contest> <problem> [url]` | `just t` | サンプルを取得してテスト実行 |
| `just run <contest> <problem>` | `just r` | ビルドして手入力で実行 |
| `just open <contest> <problem>` | `just o` | 問題ページをブラウザで開く |
| `just done <contest> <problem>` | `just d` | 回答完了した問題を `src/bin/done/` に移動 |
| `just undone <contest> <problem>` | | done の問題を作業中に戻す（再挑戦用） |
| `just` | | レシピ一覧を表示 |

リポジトリ内ならどのディレクトリから実行してもよい（just がプロジェクトルートを自動検出する）。

## ディレクトリ構成

1 問題 = 1 フォルダで、解答とサンプルケースを同じ場所に置く（コロケーション）。

```
src/bin/<contest>_<problem>/     # 作業中の問題
├── main.rs                      # 解答（単一ファイル。そのままコピペで提出できる）
└── tests/                       # oj がダウンロードしたサンプルケース（git 管理外）
src/bin/done/<contest>_<problem>/ # 回答完了済みの問題（just done で移動）
templates/main.rs                # just new が使うテンプレート
justfile                         # just のレシピ定義（new / test / run / open / done / undone）
docs/rust-cheatsheet.md          # 競プロ Rust チートシート（入出力・イテレータ・定石集）
```

Cargo は `src/bin/<name>/main.rs` を自動的にバイナリ `<name>` として認識するので、
Cargo.toml に問題ごとの記述は不要。一段深い `src/bin/done/` 配下は自動認識の
対象外なので、完了済みの問題はビルドされない（作業中の問題だけがビルドされ、
チェックも速いまま保てる）。

## 環境について

- ツールチェーンは `flake.nix` で管理。rustc 1.89.0 = AtCoder ジャッジと同じバージョン
- クレートもジャッジ環境（2025-10 言語アップデート）に合わせている:
  proconio 0.5 / itertools 0.14 / ac-library-rs 0.2
- サンプルの取得・テストは [online-judge-tools (oj)](https://github.com/online-judge-tools/oj) を使用

## エディタ設定

- **Zed**: direnv をネイティブサポートしているので、`direnv allow` 済みならそのまま開けば
  rust-analyzer（flake 内のもの）が有効になる。
- **Cursor**: [direnv 拡張](https://marketplace.visualstudio.com/items?itemName=mkhl.direnv) を入れるか、
  `nix develop` したターミナルから `cursor .` で起動する。

## つまずいたら

- **`just test` でサンプルのダウンロードに失敗する（開催中のコンテスト）**
  → ログインが必要: `oj login https://atcoder.jp/`。過去問は不要。
- **古いコンテスト（abc040 以前など）で 404 になる**
  → タスク ID の形式が違う（例: `abc001_1`）。URL を直接渡す:
  `just test abc001 1 https://atcoder.jp/contests/abc001/tasks/abc001_1`
- **入力の読み方がわからない**
  → まず `docs/rust-cheatsheet.md` を見る。詳細は [proconio のドキュメント](https://docs.rs/proconio/latest/proconio/)。
  対話型問題では `input!` ではなく `input_interactive!` を使う。
