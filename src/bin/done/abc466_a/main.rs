// https://atcoder.jp/contests/abc466/tasks/abc466_a

use proconio::input;

fn main() {
    input! {
        n: usize,
        x: [i32; n],
    }

    // x.iter()        : Vec<i32> の各要素への参照(&i32)を返すイテレータを作る
    // .all(f)         : イテレータの全要素が f を満たせば true、1つでも満たさなければ false
    // |&v| v < 0       : クロージャ。引数パターン &v で参照を外して値 v を取り出し、v < 0 を判定
    let ans = if x.iter().all(|&v| v < 0) { "Yes" } else { "No" };
    println!("{ans}");
}

// 別解: for ループ + フラグ変数を使った、より基礎的な実装
// (呼び出されないので #[allow(dead_code)] で unused 警告を抑制)
#[allow(dead_code)]
fn main2() {
    input! {
        n: usize,
        x: [i32; n],
    }

    // 「全部負」かどうかをフラグで判定する
    let mut all_negative = true;
    for i in 0..n {
        if x[i] >= 0 {
            all_negative = false;
        }
    }

    let ans = if all_negative { "Yes" } else { "No" };
    println!("{ans}");
}
