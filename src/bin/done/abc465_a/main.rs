use proconio::input;

fn main() {
    input! {
        n: [isize; 2]
    }

    let a = n[0];
    let b = n[1];

    if a > b * 2 / 3 {
        println!("Yes");
    } else {
        println!("No");
    }
}
