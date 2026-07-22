use proconio::{input, marker::Chars};

fn main() {
    input! {
        s: Chars,
    }

    let mut result = String::new();
    for c in &s {
        if c.is_ascii_digit() {
            result.push(*c);
        }
    }
    println!("{result}");
}
