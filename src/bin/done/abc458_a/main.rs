use proconio::{input, marker::Chars};

fn main() {
    input! {
        s: Chars,
        n: usize,
    }

    let mut result = String::new();
    let s_len = s.len();
    let mut i = 0;

    for c in s {
        if i < n {
            i += 1;
            continue;
        }

        if i >= s_len - n {
            i += 1;
            continue;
        }

        result.push(c);
        i += 1;
    }

    println!("{result}");
}
