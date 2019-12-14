let POSITION_MODE = 0
let IMMEDIATE_MODE = 1
let RELATIVE_MODE = 2

class Machine {

    let DEBUG = false

    enum Command: Int {
        case add = 1
        case multiply
        case input
        case output
        case jumpTrue
        case jumpFalse
        case less
        case equals
        case adjustBase
    }

    var program = [3,8,1001,8,10,8,105,1,0,0,21,34,59,76,101,114,195,276,357,438,99999,3,9,1001,9,4,9,1002,9,4,9,4,9,99,3,9,102,4,9,9,101,2,9,9,102,4,9,9,1001,9,3,9,102,2,9,9,4,9,99,3,9,101,4,9,9,102,5,9,9,101,5,9,9,4,9,99,3,9,102,2,9,9,1001,9,4,9,102,4,9,9,1001,9,4,9,1002,9,3,9,4,9,99,3,9,101,2,9,9,1002,9,3,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,99,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,99]
    var instructionPtr = 0
    var relativeBase = 0

    init(withProgram program: [Int]) {
        self.program = program

        // Add some ram
        let memory=Array<Int>(repeating: 0, count:1000000)
        self.program.append(contentsOf:memory)
    }

    init() {
        // Add some ram
        let memory=Array<Int>(repeating: 0, count:1000000)
        self.program.append(contentsOf:memory)
    }

    func extract_instructions(opcode: Int) -> (Int, Int, Int, Int) {
        let instruction = opcode % 100
        let param0 = (opcode / 100) % 10
        let param1 = (opcode / 1000) % 10
        let param2 = (opcode / 10000) % 10
        return (instruction, param0, param1, param2)
    }

    func extract_params(param_mode: Int, index: Int) -> Int {
        let value = program[index]
        if param_mode == POSITION_MODE {
            return program[value]
        } else if param_mode == IMMEDIATE_MODE {
            return value
        } else /*if param_mode == RELATIVE_MODE*/ {
            return program[value + relativeBase]
        } 
    }

    func runMachine(input:[Int], onOutput:((Int)->Void)? = nil) -> (Int, Bool) {
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

            if DEBUG {
                print("Opcode", opcode)
            }
            
        
            // target is never IMMEDIATE_MODE
            assert(param2 != IMMEDIATE_MODE)
            var instruction_move = 4
            var jump = -1
            if instruction == Command.add.rawValue
                || instruction == Command.multiply.rawValue {
                let lhs = extract_params(param_mode:param0, index:instructionPtr + 1)
                let rhs = extract_params(param_mode:param1, index:instructionPtr + 2)
                var target = program[instructionPtr + 3]
                if param2 == RELATIVE_MODE {
                    target += relativeBase
                }
                
                if instruction == Command.add.rawValue { program[target] = lhs + rhs }
                if instruction == Command.multiply.rawValue { program[target] = lhs * rhs }
            } else if instruction == Command.input.rawValue {
                var target = program[instructionPtr + 1] 
                if param0 == RELATIVE_MODE {
                    target += relativeBase
                }
                
                // print("### Input", param0, target, relativeBase)
                
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
            } else if instruction == Command.output.rawValue {
                output = extract_params(param_mode:param0, index:instructionPtr + 1)
                // print("### Output =", output)
                if let onOutput = onOutput {
                    onOutput(output)
                }
                instruction_move = 2
            } else if instruction == Command.jumpTrue.rawValue
                || instruction == Command.jumpFalse.rawValue {
                let value = extract_params(param_mode:param0, index:instructionPtr + 1)
                let address = extract_params(param_mode:param1, index:instructionPtr + 2)
                let condition = instruction == Command.jumpTrue.rawValue ? value != 0 : value == 0
                if condition {
                    jump = address
                } else {
                    instruction_move = 3
                }
            } else if instruction == Command.less.rawValue 
                || instruction == Command.equals.rawValue {
                let lhs = extract_params(param_mode:param0, index:instructionPtr + 1)
                let rhs = extract_params(param_mode:param1, index:instructionPtr + 2)
                var target = program[instructionPtr + 3]
                if param2 == RELATIVE_MODE {
                    target += relativeBase
                }
                
                
                let condition = instruction == Command.less.rawValue ? lhs < rhs : lhs == rhs
                if condition {
                    program[target] = 1
                } else {
                    program[target] = 0
                }
            } else if instruction == Command.adjustBase.rawValue {
                let delta = extract_params(param_mode:param0, index:instructionPtr + 1)
                relativeBase += delta
                instruction_move = 2
            }

            if jump >= 0 {
                if DEBUG { print("jump", jump) }
                instructionPtr = jump
            } else {
                if DEBUG { print("move", instruction_move) }
                instructionPtr += instruction_move
            }
        }

        // print("output", output, halt)
        return (output, halt)
    }
}
