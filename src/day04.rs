// Check if array contains at least one real double digit
fn has_real_double(digits: &[i32; 6]) -> bool {
    let mut found_real_double = false;
    let mut value = -1;
    for j in 0..5 {
        if digits[j] == digits[j + 1] {
            if !found_real_double && value == -1 {
                // Start of double
                found_real_double = true;
                value = digits[j];
            } else if digits[j] == value {
                // Third digit encountered
                found_real_double = false;
            }
        } else if found_real_double {
            break;
        } else {
            // Reset -> different digits
            value = -1;
        }
    }

    return found_real_double;
}

pub fn first() {
    let start = 256310;
    let end = 732736;

    let mut results = Vec::new();
    for i in start..end {
        let d0 = i / 100000;
        let d1 = (i / 10000) % 10;
        let d2 = (i / 1000) % 10;
        let d3 = (i / 100) % 10;
        let d4 = (i / 10) % 10;
        let d5 = i % 10;

        // Check increasing
        if d5 < d4 || d4 < d3 || d3 < d2 || d2 < d1 || d1 < d0 {
            continue;
        }

        // Check has double
        if d0 != d1 && d1 != d2 && d2 != d3 && d3 != d4 && d4 != d5 {
            continue;
        }

        // Check no larger group
        let digits = [d0, d1, d2, d3, d4, d5];
        let found_real_double = has_real_double(&digits);
        // println!("Checking {} = {}", i, found_real_double);
        if !found_real_double {
            continue;
        }

        results.push(i);
    }

    println!("Num passwords = {}", results.len());
}
