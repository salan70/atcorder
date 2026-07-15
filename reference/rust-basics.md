# Rust 基礎文法チートシート

## 1. 変数と型

```rust
// 変数宣言（不変）
let x = 5;
let name: &str = "hello";  // 型注釈

// 可変変数
let mut y = 10;
y = 20;

// 定数
const MAX: i32 = 100;

// 型の種類
let a: i32 = 100;      // 32ビット整数
let b: f64 = 3.14;     // 64ビット浮動小数点
let c: bool = true;    // 真偽値
let d: char = 'A';     // 文字（4バイト）
let e: &str = "text";  // 文字列スライス
let f: String = String::from("owned"); // 所有文字列

// 型変換
let num: i32 = 42;
let float_num: f64 = num as f64;
let parsed: i32 = "42".parse().unwrap();
```

## 2. 関数と制御文

```rust
// 関数
fn add(x: i32, y: i32) -> i32 {
    x + y  // 最後の式が戻り値（セミコロンなし）
}

// 式 vs 文
let result = {
    let a = 5;
    let b = 10;
    a + b  // 式：値を返す
};  // result = 15

// if式
let x = if condition { 10 } else { 20 };

// match式
match value {
    1 => "one",
    2..=5 => "small",
    _ => "other",
}

// ループ
loop {
    break;  // breakで値を返せる
    // continue
}

while condition { /* ... */ }

for i in 0..10 { /* ... */ }           // 範囲
for item in vec.iter() { /* ... */ }  // イテレータ
```

## 3. 所有権モデル

```rust
// 所有権のルール
let s1 = String::from("hello");
let s2 = s1;  // s1は無効に becomes（ムーブ）

// 借用（参照）
let s3 = String::from("hello");
let len = calculate_length(&s3);  // 不変借用
// s3はまだ有効

fn calculate_length(s: &String) -> usize {
    s.len()
}

// 可変借用
let mut s4 = String::from("hello");
change(&mut s4);

fn change(s: &mut String) {
    s.push_str(", world");
}

// 借用のルール
// - 任意の時点で、不変借用 or 可変借用のどちらかのみ
// - 不変借用は複数OK
// - 可変借用は1つだけ
```

## 4. コレクション

```rust
use std::collections::{HashMap, HashSet, VecDeque};

// Vec（動的配列）
let mut v: Vec<i32> = Vec::new();
let v = vec![1, 2, 3];     // リテラル
v.push(4);                  // 追加
let third = v[2];           // インデックスアクセス
let third = v.get(2);       // Optionで安全に取得

// HashMap
let mut scores = HashMap::new();
scores.insert(String::from("Blue"), 10);
scores.entry(String::from("Blue")).or_insert(50); // 存在しない場合のみ挿入
if let Some(score) = scores.get("Blue") { /* ... */ }

// HashSet
let mut set = HashSet::new();
set.insert(1);
set.contains(&1);  // true

// VecDeque（キュー/スタック）
let mut deque = VecDeque::new();
deque.push_back(1);   // キューに追加
deque.push_front(0);  // スタック的に追加
deque.pop_front();    // キューから取り出し
deque.pop_back();     // スタックから取り出し

// 文字列
let s = String::from("hello");
let s2 = format!("{} world", s);  // 文字列結合
for c in s.chars() { /* ... */ }  // 文字ごとにイテレート
```

## 5. エラーハンドリング

```rust
// Result型
fn divide(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        Err(String::from("Division by zero"))
    } else {
        Ok(a / b)
    }
}

// Resultの扱い
match divide(10.0, 0.0) {
    Ok(result) => println!("{}", result),
    Err(e) => println!("Error: {}", e),
}

// ?演算子（早期リターン）
fn read_file(path: &str) -> Result<String, std::io::Error> {
    let content = std::fs::read_to_string(path)?;  // エラーなら即return
    Ok(content)
}

// Option型
fn find_first_even(v: &[i32]) -> Option<i32> {
    v.iter().find(|&&x| x % 2 == 0).copied()
}

// Optionの扱い
match find_first_even(&[1, 3, 4, 5]) {
    Some(n) => println!("Found: {}", n),
    None => println!("Not found"),
}

// unwrap系（簡易的、実際は使わない方がいい）
let value = optional_value.unwrap();         // Noneならパニック
let value = optional_value.unwrap_or(0);     // Noneならデフォルト値
let value = optional_value.unwrap_or_else(|| compute_default());
```

## 6. 標準入出力

```rust
use std::io::{self, BufRead, Write};

// 出力
println!("Hello, {}!", name);          // 改行付き
print!("No newline");                  // 改行なし
eprintln!("Error output");             // 標準エラー出力

// 文字列フォーマット
let formatted = format!("{:.2}", 3.14159);  // "3.14"
let padded = format!("{:0>5}", 42);          // "00042"

// 標準入力（1行読み取り）
let mut input = String::new();
io::stdin().read_line(&mut input).unwrap();
let n: i32 = input.trim().parse().unwrap();

// 複数値の読み取り
let mut input = String::new();
io::stdin().read_line(&mut input).unwrap();
let (a, b): (i32, i32) = {
    let mut iter = input.split_whitespace();
    (iter.next().unwrap().parse().unwrap(),
     iter.next().unwrap().parse().unwrap())
};

// バッファ付き入力（高速）
let stdin = io::stdin();
let reader = stdin.lock();
for line in reader.lines() {
    let line = line.unwrap();
    // 処理
}

// 高速入力テンプレート
let mut reader = std::io::BufReader::new(std::io::stdin());
let mut input = String::new();
reader.read_line(&mut input).unwrap();
let n: i32 = input.trim().parse().unwrap();
```
