
class Day07 {
    func get_program() -> [Int] {
        // return [3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0]
        return [3,8,1001,8,10,8,105,1,0,0,21,34,59,76,101,114,195,276,357,438,99999,3,9,1001,9,4,9,1002,9,4,9,4,9,99,3,9,102,4,9,9,101,2,9,9,102,4,9,9,1001,9,3,9,102,2,9,9,4,9,99,3,9,101,4,9,9,102,5,9,9,101,5,9,9,4,9,99,3,9,102,2,9,9,1001,9,4,9,102,4,9,9,1001,9,4,9,1002,9,3,9,4,9,99,3,9,101,2,9,9,1002,9,3,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,99]
    }

    func extract_instructions(opcode: Int) -> (Int, Int, Int, Int) {
        let instruction = opcode % 100
        let param0 = (opcode / 100) % 10
        let param1 = (opcode / 1000) % 10
        let param2 = (opcode / 10000) % 10
        return (instruction, param0, param1, param2)
    }

    func extract_params(program: [Int], param_mode: Int, index: Int) -> Int {
        if param_mode == POSITION_MODE {
            return program[program[index]]
        } else {
            return program[index]
        }
    }

    func runMachine(input:[Int]) -> Int {
        var program = get_program()
        var index = 0
        var inputPos = 0
        var output = 0
        while index < program.count {
            // print("index", index)
            if program[index] == 99 {
                break
            }

            let opcode = program[index];
            let (instruction, param0, param1, param2) = extract_instructions(opcode: opcode)
            // print(
            //     "opcode {}, instruction {}, p0 {}, p1 {}, p2 {}",
            //     opcode, instruction, param0, param1, param2,
            // );
            assert(param2 == 0)
            var instruction_move = 4
            var jump = -1
            if instruction == 1 {
                // add
                let lhs = extract_params(program:program, param_mode:param0, index:index + 1)
                let rhs = extract_params(program:program, param_mode:param1, index:index + 2)
                let target = program[index + 3]
                program[target] = lhs + rhs
            } else if instruction == 2 {
                // multiply
                let lhs = extract_params(program:program, param_mode:param0, index:index + 1)
                let rhs = extract_params(program:program, param_mode:param1, index:index + 2)
                let target = program[index + 3]
                program[target] = lhs * rhs
            } else if instruction == 3 {
                // program
                let target = program[index + 1]
                assert(inputPos < input.count)
                let input_value = input[inputPos]
                inputPos += 1
                program[target] = input_value
                instruction_move = 2
                // print("Wrote \(input_value) to address \(target)");
            } else if instruction == 4 {
                // output
                let target = program[index + 1]
                output = program[target]
                // print("### Output is", output)
                instruction_move = 2
            } else if instruction == 5 {
                let condition = extract_params(program:program, param_mode:param0, index:index + 1) != 0
                let address = extract_params(program:program, param_mode:param1, index:index + 2)
                // print("Jump {} to {}", condition, address)
                if condition {
                    jump = address
                } else {
                    instruction_move = 3
                }
            } else if instruction == 6 {
                let condition = extract_params(program:program, param_mode:param0, index:index + 1) == 0
                let address = extract_params(program:program, param_mode:param1, index:index + 2)
                // print("Jump {} to {}", condition, address)
                if condition {
                    jump = address
                } else {
                    instruction_move = 3
                }
            } else if instruction == 7 {
                let lhs = extract_params(program:program, param_mode:param0, index:index + 1)
                let rhs = extract_params(program:program, param_mode:param1, index:index + 2)
                let target = program[index + 3]
                if lhs < rhs {
                    program[target] = 1
                } else {
                    program[target] = 0
                }
            } else if instruction == 8 {
                let lhs = extract_params(program:program, param_mode:param0, index:index + 1)
                let rhs = extract_params(program:program, param_mode:param1, index:index + 2)
                let target = program[index + 3]
                if lhs == rhs {
                    program[target] = 1
                } else {
                    program[target] = 0
                }
            }

            if jump >= 0 {
                index = jump
            } else {
                index += instruction_move
            }
        }

        return output
    }
}

 
func heapPermutation(a:inout [Int], size:Int, n:Int, operation:([Int])->Void) 
{ 
    // print(a, size, n)
    // if size becomes 1 then prints the obtained 
    // permutation 
    if size == 1 {
        // print(a)
        operation(a)
    }
        
    if size>0 {
        for i in 0...size-1 { 
            heapPermutation(a:&a, size:size-1, n:n, operation:operation)

            // if size is odd, swap first and last 
            // element 
            if (size % 2 == 1) 
            { 
                let temp = a[0]; 
                a[0] = a[size-1]; 
                a[size-1] = temp; 
            } 

            // If size is even, swap ith and last 
            // element 
            else
            { 
                let temp = a[i]; 
                a[i] = a[size-1]; 
                a[size-1] = temp; 
            } 
        } 
    }
    
} 


func day07First() {
    let machine = Day07()
    var maxOutput = 0
    var maxSettings:[Int] = []
    var array = [0,1,2,3,4]
    heapPermutation(a:&array, size:5, n:5, operation: {(data)->Void in
        var out = machine.runMachine(input:[data[0], 0])
        out = machine.runMachine(input:[data[1], out])
        out = machine.runMachine(input:[data[2], out])
        out = machine.runMachine(input:[data[3], out])
        out = machine.runMachine(input:[data[4], out])          
        if out > maxOutput {
            maxOutput = out
            maxSettings = data
        }     
    })

    print("Max = ", maxOutput, maxSettings)   
}
