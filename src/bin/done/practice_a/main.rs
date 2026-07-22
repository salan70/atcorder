// https://atcoder.jp/contests/practice/tasks/practice_1
// 動作確認用のサンプル解答（Welcome to AtCoder）

use proconio::input;

fn main() {
    input! {
        a: i32,
        b: i32,
        c: i32,
        s: String,
    }

    println!("{} {}", a + b + c, s);
}
