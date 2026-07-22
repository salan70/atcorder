use proconio::{input, marker::Chars};

fn main() {
    input! {
        s: Chars,
    }

    let mut e_count = 0;
    let mut w_count = 0;
    for c in &s {
        match c {
            'E' => e_count += 1,
            'W' => w_count += 1,
            _ => unreachable!(),
        }
    }

    if e_count > w_count {
        println!("East");
    } else {
        println!("West");
    }
}
