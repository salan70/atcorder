use proconio::input;

fn main() {
    input! {
        n: isize,
    }

    let hellow_world = "HelloWorld";
    let mut ret_text = String::new();
    let mut i = 0;
    for c in hellow_world.chars() {
        if i != n - 1 {
            ret_text.push(c);
        }
        i += 1;
    }

    println!("{ret_text}");
}
