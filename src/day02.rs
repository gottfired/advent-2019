fn get_input() -> [i32; 125] {
    return [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,13,1,19,1,5,19,23,2,10,23,27,1,27,5,31,2,9,31,35,1,35,5,39,2,6,39,43,1,43,5,47,2,47,10,51,2,51,6,55,1,5,55,59,2,10,59,63,1,63,6,67,2,67,6,71,1,71,5,75,1,13,75,79,1,6,79,83,2,83,13,87,1,87,6,91,1,10,91,95,1,95,9,99,2,99,13,103,1,103,6,107,2,107,6,111,1,111,2,115,1,115,13,0,99,2,0,14,0];
}

pub fn first() {
    let mut input = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,13,1,19,1,5,19,23,2,10,23,27,1,27,5,31,2,9,31,35,1,35,5,39,2,6,39,43,1,43,5,47,2,47,10,51,2,51,6,55,1,5,55,59,2,10,59,63,1,63,6,67,2,67,6,71,1,71,5,75,1,13,75,79,1,6,79,83,2,83,13,87,1,87,6,91,1,10,91,95,1,95,9,99,2,99,13,103,1,103,6,107,2,107,6,111,1,111,2,115,1,115,13,0,99,2,0,14,0];
    input[1] = 12;
    input[2] = 2;
    let mut index = 0;
    while index < input.len() {
        println!("index {}", index);
        if input[index] == 99 {
            break;
        }

        let lhs = input[input[index+1]];
        let rhs = input[input[index+2]];
        println!("lhs {} rhs {}", lhs, rhs);
        let target = input[index+3];
        if input[index] == 1 {    
            input[target] = lhs + rhs;
        } else if input[index] == 2 {
            input[target] = lhs * rhs;
        }
        println!("Writing {} at {}", input[target], target);
        index += 4;
    }
    
    println!("position 0: {}", input[0]);
}

pub fn second() {
    let mut result = 0;
    let mut noun = 0;
    let mut verb = 0;
    while result != 19690720 {
        let mut input = get_input();
        assert!(input[0] == 1);
        input[1] = noun;
        input[2] = verb;
        let mut index = 0;
        while index < input.len() {
            // println!("index {}", index);
            if input[index] == 99 {
                break;
            }
    
            let lhs = input[input[index+1] as usize];
            let rhs = input[input[index+2] as usize];
            // println!("lhs {} rhs {}", lhs, rhs);
            let target = input[index+3] as usize;
            if input[index] == 1 {    
                input[target] = lhs + rhs;
            } else if input[index] == 2 {
                input[target] = lhs * rhs;
            }
            // println!("Writing {} at {}", input[target], target);
            index += 4;
        }
        
        result = input[0];

        println!("noun {} verb {} result {}", noun, verb, result);

        verb += 1;
        if verb == 100 {
            verb = 0;
            noun += 1;
        }
    }
}