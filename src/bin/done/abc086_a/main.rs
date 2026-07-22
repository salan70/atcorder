// https://atcoder.jp/contests/abc086/tasks/abc086_a

use proconio::input;

fn main() {
    input! {
        a: u32,
        b: u32,
    }

    if a * b % 2 == 0 {
        println!("Even");
    } else {
        println!("Odd");
    }
}
