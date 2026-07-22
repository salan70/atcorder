use proconio::input;

fn main() {
    input! {
        n: isize,
        a: [isize; n],
        x: isize,
    }

    let mut i = 0;
    for ai in a {
        if i == x - 1 {
            println!("{ai}");
            break;
        }
        i += 1;
    }
}
