# AtCoder ヘルパー。`just` だけ打つとレシピ一覧を表示。

alias n := new
alias t := test
alias r := run
alias o := open
alias d := done

_default:
    @just --list --unsorted

# 問題ファイルを作成（省略時は a b）  例: just new abc300 / just n abc300 a b c
new contest +problems="a b":
    #!/usr/bin/env bash
    set -euo pipefail
    for p in {{ problems }}; do
      bin="{{ contest }}_${p}"
      file="src/bin/${bin}/main.rs"
      if [[ -d "src/bin/done/${bin}" ]]; then
        echo "skip: ${bin}（回答完了済み。再挑戦するなら just undone {{ contest }} ${p}）"
      elif [[ -e "$file" ]]; then
        echo "skip: ${file}（すでに存在します）"
      else
        mkdir -p "$(dirname "$file")"
        cp templates/main.rs "$file"
        echo "created: ${file}"
      fi
    done

# サンプルを取得してテスト実行  例: just test abc300 a / just t abc300 a
test contest problem url="":
    #!/usr/bin/env bash
    set -euo pipefail
    url="{{ url }}"
    [[ -n "$url" ]] || url="https://atcoder.jp/contests/{{ contest }}/tasks/{{ contest }}_{{ problem }}"
    bin="{{ contest }}_{{ problem }}"
    testdir="src/bin/$bin/tests"
    if [[ ! -d "$testdir" ]]; then
      echo "downloading samples: $url"
      oj download "$url" -d "$testdir"
    fi
    cargo build --release --bin "$bin"
    oj test -c "target/release/$bin" -d "$testdir"

# ビルドして手入力で実行
run contest problem:
    cargo run --release --bin {{ contest }}_{{ problem }}

# 問題ページをブラウザで開く
open contest problem:
    open "https://atcoder.jp/contests/{{ contest }}/tasks/{{ contest }}_{{ problem }}"

# 回答完了した問題を src/bin/done/ に移動  例: just done abc300 a / just d abc300 a
done contest problem:
    #!/usr/bin/env bash
    set -euo pipefail
    bin="{{ contest }}_{{ problem }}"
    src="src/bin/$bin"
    dst="src/bin/done/$bin"
    [[ -d "$src" ]] || { echo "error: $src がありません"; exit 1; }
    [[ ! -e "$dst" ]] || { echo "error: $dst がすでに存在します"; exit 1; }
    mkdir -p src/bin/done
    mv "$src" "$dst"
    echo "moved: $src -> $dst"

# done の問題を作業中に戻す（再挑戦用）  例: just undone abc300 a
undone contest problem:
    #!/usr/bin/env bash
    set -euo pipefail
    bin="{{ contest }}_{{ problem }}"
    src="src/bin/done/$bin"
    dst="src/bin/$bin"
    [[ -d "$src" ]] || { echo "error: $src がありません"; exit 1; }
    [[ ! -e "$dst" ]] || { echo "error: $dst がすでに存在します"; exit 1; }
    mv "$src" "$dst"
    echo "moved: $src -> $dst"
