# 競プロ Rust チートシート

AtCoder 用リファレンス。依存クレート: `proconio` / `itertools` / `ac-library-rs`

参考: [AtCoder用Rustチートシート（Zenn / tipstar0125）](https://zenn.dev/tipstar0125/articles/f9c4626cdd4d5b)

---

## 1. 設定

Clippy（リンター）と Rustfmt（フォーマッタ）を導入する。

```sh
rustup component add clippy
rustup component add rustfmt
```

VSCode 設定（`.vscode/settings.json`）。保存時にフォーマットし、保存時チェックを clippy にする。

```json
{
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "rust-lang.rust-analyzer",
    "editor.inlayHints.enabled": "off",
    "rust-analyzer.checkOnSave.command": "clippy",
    "rust-analyzer.checkOnSave.extraArgs": ["--", "-A", "clippy::needless_range_loop"]
}
```

## 2. 事前チートシート（テンプレート）

コンテスト開始前に貼っておくテンプレート。ポイント:

- `#![allow(non_snake_case)]` — 問題文どおり `N` や `A` と書けるようにする
- `max!` / `min!` — 3 つ以上の値を一度に比較できる可変長マクロ
- `#[fastout]` — 出力をバッファリングして高速化
- `main` で別スレッドを立ててスタックサイズを 64MB に拡張（深い再帰対策）

```rust
#![allow(non_snake_case)]
#![allow(unused_imports)]
#![allow(unused_macros)]
#![allow(clippy::comparison_chain)]
#![allow(clippy::nonminimal_bool)]
#![allow(clippy::neg_multiply)]
#![allow(dead_code)]
use proconio::{
    fastout, input,
    marker::{Chars, Usize1},
};

#[macro_export]
macro_rules! max {
    ($x: expr) => ($x);
    ($x: expr, $( $y: expr ),+) => {
        std::cmp::max($x, max!($( $y ),+))
    }
}
#[macro_export]
macro_rules! min {
    ($x: expr) => ($x);
    ($x: expr, $( $y: expr ),+) => {
        std::cmp::min($x, min!($( $y ),+))
    }
}
#[macro_export]
macro_rules! abs {
    ($x: expr) => {
        if $x < 0_isize { $x * (-1) } else { $x }
    };
}
#[macro_export]
macro_rules! absf {
    ($x: expr) => {
        if $x < 0.0 { $x * (-1.0) } else { $x }
    };
}

#[derive(Default)]
struct Solver {}
impl Solver {
    #[fastout]
    fn solve(&mut self) {
        input! {
            // ここに入力を書く
        }
    }
}

fn main() {
    std::thread::Builder::new()
        .stack_size(64 * 1024 * 1024)
        .spawn(|| Solver::default().solve())
        .unwrap()
        .join()
        .unwrap();
}
```

> 元記事には自前実装の UnionFind も含まれるが、このリポジトリは `ac-library-rs` を導入済みなので `ac_library::Dsu` を使う（§7 参照）。

## 3. 入出力

### 入力（proconio）

**単一入力** — 1 行に並んだ値はそのまま並べて書く。

```rust
input! {
    N: usize,
    M: isize,
    S: String,
}
```

**Usize1 / Isize1** — 1-indexed の入力を読むと同時に 0-indexed へ変換する。

```rust
use proconio::marker::{Usize1, Isize1};
input! {
    N: Usize1,
    M: Isize1,
}
```

**配列（Vec）** — 先に読んだ `N` を長さに使える。

```rust
input! {
    N: usize,
    A: [usize; N],
}
```

**タプルの配列** — 「l r」が N 行続く形式。

```rust
input! {
    N: usize,
    LR: [(usize, usize); N],
}

for &(l, r) in &LR {
    // 処理
}
```

**2 次元配列** — H 行 W 列のグリッド。

```rust
input! {
    H: usize,
    W: usize,
    X: [[usize; W]; H],
}
```

**Chars** — 文字列を `Vec<char>` として受け取り、1 文字ずつ処理する。

```rust
input! {
    S: Chars,
}

for c in &S {
    match c {
        '(' => { /* 処理 */ }
        ')' => { /* 処理 */ }
        _ => unreachable!(),
    }
}
```

**可変で受け取る** — その場でソートや破壊的更新をしたいとき。

```rust
input! {
    mut N: usize,
    mut A: [usize; N],
}
```

**可変長の入力** — 行ごとに長さが変わる場合は `input!` を複数回呼ぶ。

```rust
input! {
    N: usize,
}

let mut a = vec![];
for _ in 0..N {
    input! {
        L_i: usize,
        a_i: [usize; L_i],
    }
    a.push(a_i);
}
```

- インタラクティブ問題は `input_interactive!` を使う（都度フラッシュされる）。

### 出力

**高速出力** — 出力回数が多い問題では `#[fastout]` を関数に付ける（テンプレートの `solve` には付与済み）。

```rust
#[fastout]
fn solve(&mut self) { }
```

**基本**

```rust
println!("{}", ans);
println!("{} {}", a, b);
println!("{}", if ok { "Yes" } else { "No" });
println!("{:.10}", x);      // 小数（誤差問題は桁数多めに）
println!("{{{}}}", ans);    // 中括弧を出力したいとき → {ans} と表示される
```

**join** — 配列を区切り文字付きで 1 行に出力する。

```rust
use itertools::Itertools;
println!("{}", A.iter().join(" "));
println!("{}", A.iter().join("\n"));
```

## 4. 嵌りがちなエラー

### subtract with overflow

`usize` は負になれないため、引き算が負になると実行時 panic する。

```rust
// 負の値になるような計算をさせない
if a - b > 0 {}            // NG（a < b で panic）
if a > b {}                // OK

// 負にならないことを確認してから index 指定する
if A[a - b] > c {}         // NG
if a > b && A[a - b] > c {}  // OK

// index を isize で計算した場合は as で usize に変換
A[d as usize];
```

### 型推論による型の不一致

初期値 `0` のままだと `i32` に推論されて溢れたり、`usize` の変数と比較できなかったりする。明示的に型を指定する。

```rust
let mut ans: usize = 0;
let mut ans = 0_usize;    // サフィックスでも可
let mut ans = 0_i64;      // 答えが大きくなるなら i64（i32 は 2×10^9 で溢れる）
```

## 5. よく使う Rust な記法

**タプルの分割代入**

```rust
let (l, r) = LR[i];
let (mut l, mut r) = LR[i];    // 可変で取り出す
std::mem::swap(&mut a, &mut b);
```

**タプルのパターンマッチ** — クエリ処理で便利。

```rust
match q {
    (1, x, y) => { /* 処理 */ }
    (2, _, _) => { /* 処理 */ }
    (3, x, _) => { /* 処理 */ }
    _ => unreachable!(),
}
```

**ソート**

```rust
A.sort();                                // 昇順（安定ソート）
A.sort_unstable();                       // 速い方。基本これで OK
A.reverse();                             // 反転（sort と組み合わせて降順に）
A.sort_by(|a, b| b.cmp(a));              // 降順
A.sort_by(|(_, a), (_, b)| b.cmp(a));    // タプルの特定要素で降順
A.sort_by_key(|&(a, _)| a);              // キー指定
A.dedup();                               // 連続する重複を除去（sort 後に使う）
```

**再帰関数 + メモ** — メモは `&mut` で引き回す。

```rust
let mut memo = vec![false; N];
dfs(1, &mut memo);

fn dfs(x: usize, memo: &mut Vec<bool>) {
    memo[x] = true;
    // 処理
}
```

**BTreeSet での二分探索** — 「x 以上の最小値」などが O(log n) で取れる。

```rust
use std::collections::BTreeSet;
let mut set = BTreeSet::new();
set.insert(x);
set.range(x..).next();          // x 以上の最小（lower_bound 相当）→ Option<&T>
set.range(..x).next_back();     // x 未満の最大
```

**ソート済み Vec での二分探索**

```rust
v.binary_search(&x);               // Ok(idx) / Err(挿入位置)
v.partition_point(|&e| e < x);     // lower_bound 相当（x 未満の個数）
v.partition_point(|&e| e <= x);    // upper_bound 相当
```

## 6. 頻出イディオム

```rust
// chmax / chmin
ans = ans.max(x);
ans = ans.min(x);

// カウント集計
use std::collections::HashMap;
let mut map: HashMap<char, usize> = HashMap::new();
*map.entry(c).or_insert(0) += 1;

// 累積和
let mut acc = vec![0i64; n + 1];
for i in 0..n { acc[i + 1] = acc[i] + v[i]; }
// 区間 [l, r) の和 = acc[r] - acc[l]

// グリッドの 4 方向移動
const D: [(i64, i64); 4] = [(1, 0), (-1, 0), (0, 1), (0, -1)];
for &(di, dj) in &D {
    let (ni, nj) = (i as i64 + di, j as i64 + dj);
    if ni < 0 || ni >= h as i64 || nj < 0 || nj >= w as i64 { continue; }
    let (ni, nj) = (ni as usize, nj as usize);
    // grid[ni][nj] ...
}

// bit 全探索
for bit in 0..(1u32 << n) {
    for i in 0..n {
        if bit >> i & 1 == 1 { /* i を選ぶ */ }
    }
}

// 答えで二分探索（めぐる式）
let (mut ng, mut ok) = (0i64, INF);        // check(ok)=true を維持
while ok - ng > 1 {
    let mid = (ok + ng) / 2;
    if check(mid) { ok = mid; } else { ng = mid; }
}

// mod 計算（手動でやる場合。基本は ac-library の ModInt を使う）
const MOD: i64 = 998_244_353;
let ans = (a % MOD * (b % MOD)) % MOD;     // 乗算前に必ず両方 % MOD
let sub = ((a - b) % MOD + MOD) % MOD;     // 引き算は負になり得る

// GCD / LCM（std にないので自作 or ac-library）
fn gcd(a: u64, b: u64) -> u64 { if b == 0 { a } else { gcd(b, a % b) } }
fn lcm(a: u64, b: u64) -> u64 { a / gcd(a, b) * b }
```

## 7. ac-library-rs 抜粋

```rust
use ac_library::{ModInt998244353 as Mint, Dsu, FenwickTree, Segtree, Additive, Max, Min};

// ModInt
let x = Mint::new(2).pow(100) + Mint::new(3);
println!("{}", x.val());
let inv = Mint::new(3).inv();              // 逆元（÷3 に相当）

// Union-Find (DSU)
let mut dsu = Dsu::new(n);
dsu.merge(a, b);
dsu.same(a, b);
dsu.size(a);
dsu.groups();                              // Vec<Vec<usize>>

// Fenwick Tree（点更新・区間和）
let mut ft = FenwickTree::new(n, 0i64);
ft.add(i, x);
ft.sum(l..r);

// Segment Tree（区間 max / min / 和）
let mut seg = Segtree::<Max<i64>>::new(n); // Min<i64> / Additive<i64> も同様
seg.set(i, x);
seg.prod(l..r);
seg.all_prod();
```

## 8. デバッグ・実行

```rust
dbg!(&v);                          // 標準エラーに変数名付きで出力（提出時は消す）
eprintln!("{:?}", v);              // {:?} は Debug 表示（Vec や tuple もそのまま出せる）
```

```sh
cargo run --bin abc300_a            # デバッグ実行（オーバーフローで panic してくれる）
cargo run --release --bin abc300_a  # 実行速度の確認用（オーバーフロー検査なし）
```

### 計算量の目安（1 秒 ≈ 10^8 〜 10^9 操作）

| N の上限 | 許容計算量 |
|---|---|
| ~10^18 | O(log N)・O(1) |
| ~10^12 | O(√N) |
| ~10^6〜10^8 | O(N) |
| ~10^5 | O(N log N) |
| ~10^3 | O(N^2) |
| ~300 | O(N^3) |
| ~20 | O(2^N) |
| ~10 | O(N!) |
