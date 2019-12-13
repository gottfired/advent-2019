
class Day07 {

    var program = [3,8,1001,8,10,8,105,1,0,0,21,34,59,76,101,114,195,276,357,438,99999,3,9,1001,9,4,9,1002,9,4,9,4,9,99,3,9,102,4,9,9,101,2,9,9,102,4,9,9,1001,9,3,9,102,2,9,9,4,9,99,3,9,101,4,9,9,102,5,9,9,101,5,9,9,4,9,99,3,9,102,2,9,9,1001,9,4,9,102,4,9,9,1001,9,4,9,1002,9,3,9,4,9,99,3,9,101,2,9,9,1002,9,3,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,99]
    var instructionPtr = 0

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

    func runMachine(input:[Int]) -> (Int, Bool) {
        // print("run machine with", input, index)
        var inputPos = 0
        var output = 0
        var halt = false
        while instructionPtr < program.count {
            if program[instructionPtr] == 99 {
                halt = true
                break
            }

            let opcode = program[instructionPtr];
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
                let lhs = extract_params(program:program, param_mode:param0, index:instructionPtr + 1)
                let rhs = extract_params(program:program, param_mode:param1, index:instructionPtr + 2)
                let target = program[instructionPtr + 3]
                program[target] = lhs + rhs
            } else if instruction == 2 {
                // multiply
                let lhs = extract_params(program:program, param_mode:param0, index:instructionPtr + 1)
                let rhs = extract_params(program:program, param_mode:param1, index:instructionPtr + 2)
                let target = program[instructionPtr + 3]
                program[target] = lhs * rhs
            } else if instruction == 3 {
                // input
                let target = program[instructionPtr + 1]
                if inputPos >= input.count {
                    // wait for next input
                    break
                }
                assert(inputPos < input.count)
                let input_value = input[inputPos]
                inputPos += 1
                program[target] = input_value
                instruction_move = 2
                // print("Wrote \(input_value) to address \(target)");
            } else if instruction == 4 {
                // output
                let target = program[instructionPtr + 1]
                output = program[target]
                print("### Output is", output)
                instruction_move = 2
            } else if instruction == 5 {
                let condition = extract_params(program:program, param_mode:param0, index:instructionPtr + 1) != 0
                let address = extract_params(program:program, param_mode:param1, index:instructionPtr + 2)
                // print("Jump {} to {}", condition, address)
                if condition {
                    jump = address
                } else {
                    instruction_move = 3
                }
            } else if instruction == 6 {
                let condition = extract_params(program:program, param_mode:param0, index:instructionPtr + 1) == 0
                let address = extract_params(program:program, param_mode:param1, index:instructionPtr + 2)
                // print("Jump {} to {}", condition, address)
                if condition {
                    jump = address
                } else {
                    instruction_move = 3
                }
            } else if instruction == 7 {
                let lhs = extract_params(program:program, param_mode:param0, index:instructionPtr + 1)
                let rhs = extract_params(program:program, param_mode:param1, index:instructionPtr + 2)
                let target = program[instructionPtr + 3]
                if lhs < rhs {
                    program[target] = 1
                } else {
                    program[target] = 0
                }
            } else if instruction == 8 {
                let lhs = extract_params(program:program, param_mode:param0, index:instructionPtr + 1)
                let rhs = extract_params(program:program, param_mode:param1, index:instructionPtr + 2)
                let target = program[instructionPtr + 3]
                if lhs == rhs {
                    program[target] = 1
                } else {
                    program[target] = 0
                }
            }

            if jump >= 0 {
                instructionPtr = jump
            } else {
                instructionPtr += instruction_move
            }
        }

        // print("output", output, halt)
        return (output, halt)
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
        var (out, _) = machine.runMachine(input:[data[0], 0])
        (out, _) = machine.runMachine(input:[data[1], out])
        (out, _) = machine.runMachine(input:[data[2], out])
        (out, _) = machine.runMachine(input:[data[3], out])
        (out, _) = machine.runMachine(input:[data[4], out])     
        if out > maxOutput {
            maxOutput = out
            maxSettings = data
        }     
    })

    print("Max = ", maxOutput, maxSettings)   
}


func day07Second() {
    
    var maxOutput = 0
    var maxSettings:[Int] = []
    var array = [5,6,7,8,9]
    heapPermutation(a:&array, size:5, n:5, operation: {(data)->Void in
        let machineA = Day07()
        let machineB = Day07()
        let machineC = Day07()
        let machineD = Day07()
        let machineE = Day07()

        let machines = [machineA, machineB, machineC, machineD, machineE]

        var (out, halt) = machineA.runMachine(input:[data[0]])
        (out, halt) = machineB.runMachine(input:[data[1]])
        (out, halt) = machineC.runMachine(input:[data[2]])
        (out, halt) = machineD.runMachine(input:[data[3]])
        (out, halt) = machineE.runMachine(input:[data[4]])

        (out, halt) = machineA.runMachine(input:[0])
        var currentMachine = 1
        while true {
            (out, halt) = machines[currentMachine].runMachine(input:[out])

            if halt == true && currentMachine == 4 {
                // We stop when machineE halts
                break
            }

            currentMachine += 1
            if currentMachine == 5 {
                currentMachine = 0
            }
        }
        
        print("data", data, out)

        if out > maxOutput {
            maxOutput = out
            maxSettings = data
        }     
    })

    print("Max = ", maxOutput, maxSettings)   
}