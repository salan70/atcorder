use proconio::input;

fn main() {
    input! {
        a: isize,
        d: isize,
    }

    if a > d {
        println!("No")
    } else {
        println!("Yes")
    }
}
