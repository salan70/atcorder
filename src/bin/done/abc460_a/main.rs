use proconio::input;

fn main() {
    input! {
        n: isize,
        m: isize,
    }

    let mut result = 0;
    let mut amari = m;
    loop {
        if amari == 0 {
            break;
        }

        amari = n % amari;
        result+=1;
    }
    
    println!("{result}");
}
