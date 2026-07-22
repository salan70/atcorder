use proconio::input;

fn main() {
    input! {
        x: isize,
        y: isize,
    }

    if x * 9 == y * 16 {
        println!("Yes")
    } else {
        println!("No")
    }
}
