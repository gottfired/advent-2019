

 
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
    let machine = Machine()
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
        let machineA = Machine()
        let machineB = Machine()
        let machineC = Machine()
        let machineD = Machine()
        let machineE = Machine()

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
        
        // print("data", data, out)

        if out > maxOutput {
            maxOutput = out
            maxSettings = data
        }     
    })

    print("Max = ", maxOutput, maxSettings)   
}