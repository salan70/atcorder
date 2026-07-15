use std::io;

pub fn read_line() -> String {
    let mut buf = String::new();
    io::stdin().read_line(&mut buf).unwrap();
    buf.trim().to_string()
}

pub fn read_lines(n: usize) -> Vec<String> {
    (0..n).map(|_| read_line()).collect()
}

pub fn read_int() -> i64 {
    read_line().parse().unwrap()
}

pub fn read_ints() -> Vec<i64> {
    read_line()
        .split_whitespace()
        .map(|s| s.parse().unwrap())
        .collect()
}

pub fn read_ints2() -> (i64, i64) {
    let v = read_ints();
    (v[0], v[1])
}

pub fn read_ints3() -> (i64, i64, i64) {
    let v = read_ints();
    (v[0], v[1], v[2])
}

pub fn read_usize() -> usize {
    read_line().parse().unwrap()
}

pub fn read_usizes() -> Vec<usize> {
    read_line()
        .split_whitespace()
        .map(|s| s.parse().unwrap())
        .collect()
}

pub fn read_chars() -> Vec<char> {
    read_line().chars().collect()
}

pub fn yes() {
    println!("Yes");
}

pub fn no() {
    println!("No");
}

pub fn yesno(cond: bool) {
    if cond {
        yes();
    } else {
        no();
    }
}
