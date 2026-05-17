const std = @import("std");

/// Computes the greates common divisor between two numbers.
/// This is the algorithm specified in 1.1E.
pub fn EuclidGCD(m: u64, n: u64) u64 {
    if (m < n) {
        const t = m;
        m = n;
        n = t;
    }

    while (true) {
        const r: u64 = m % n;
        if (r == 0) {
            return n;
        }

        m = n;
        n = r;
    }
}

/// Exercise 1.1.3.
pub fn EuclidGCDExercise(m: u64, n: u64) u64 {
    if (m < n) {
        const t = m;
        m = n;
        n = t;
    }

    while (true) {
        m = m % n;
        if (m == 0) return n;

        n = n % m;
        if (n == 0) return m;
    }
}
