class Vec3 {
    var x: Int
    var y: Int
    var z: Int

    init(x:Int, y:Int, z:Int) {
        self.x = x
        self.y = y
        self.z = z
    }

    init() {
        x = 0
        y = 0
        z = 0
    }

    var energy: Int {
        get {
            return abs(x) + abs(y) + abs(z)
        }
    }
}

class Moon {
    var pos: Vec3
    var vel = Vec3()

    init(pos: Vec3) {
        self.pos = pos
    }
}

func sign(_ i: Int) -> Int {
    if i == 0 {
        return 0
    } else if i<0 {
        return -1
    } else {
        return 1
    }
}

class Day12 {
    let moons = [        
        Moon(pos: Vec3(x:-2, y:9, z:-5)),
        Moon(pos: Vec3(x:16, y:19, z:9)),
        Moon(pos: Vec3(x:0, y:3, z:6)),
        Moon(pos: Vec3(x:11, y:0, z:11))
        // Moon(pos: Vec3(x:-1, y:0, z:2)),
        // Moon(pos: Vec3(x:2, y:-10, z:-7)),
        // Moon(pos: Vec3(x:4, y:-8, z:8)),
        // Moon(pos: Vec3(x:3, y:5, z:-1))
    ]

    func updateGravities() {
        for i in 0...2 {
            for j in i+1...3 {
                let lhs = moons[i]
                let rhs = moons[j]

                let dx = sign(rhs.pos.x - lhs.pos.x)
                lhs.vel.x += dx
                rhs.vel.x -= dx

                let dy = sign(rhs.pos.y - lhs.pos.y)
                lhs.vel.y += dy
                rhs.vel.y -= dy

                let dz = sign(rhs.pos.z - lhs.pos.z)
                lhs.vel.z += dz
                rhs.vel.z -= dz
            }
        }
    }

    func updatePositions() {
        for moon in moons {
            moon.pos.x += moon.vel.x
            moon.pos.y += moon.vel.y
            moon.pos.z += moon.vel.z
        }
    }

    func update() {
        updateGravities()
        updatePositions()
    }

    func simulate(steps: Int) {
        for _ in 0...steps-1 {
            update()
        }
    }

    var energy:Int {
        get {
            var energy = 0
            for moon in moons {
                energy += moon.pos.energy * moon.vel.energy
            }

            return energy
        }
    }
}

func day12First() {
    let day = Day12()
    day.simulate(steps: 1000)
    // dump(day)
    print("Energy", day.energy)
}

func findPeriod(zeroes: [Int]) -> Int {
    var p = -1
    print("checking", zeroes.count)
    for i in 100...zeroes.count {
        // random: start comparison at 80
        if zeroes[i] == zeroes[80]
            && zeroes[i+1] == zeroes[81]
            && zeroes[i+2] == zeroes[82]
            && zeroes[i+3] == zeroes[83]
            && zeroes[i+4] == zeroes[84]
            && zeroes[i+5] == zeroes[85]
            && zeroes[i+6] == zeroes[86]
            && zeroes[i+7] == zeroes[87]
            && zeroes[i+8] == zeroes[88]
            && zeroes[i+9] == zeroes[89] {
                p = i-80
            }
    }

    if p != -1 {
        var sum = 0
        for i in 0...p-1 {
            sum += zeroes[80+i]
        }

        return sum
    }

    return -1
}



func day12Second() {
    let day = Day12()
    // var energy = -1
    var steps = 0

    // Data
    // Moon(pos: Vec3(x:-2, y:9, z:-5)),
    // Moon(pos: Vec3(x:16, y:19, z:9)),
    // Moon(pos: Vec3(x:0, y:3, z:6)),
    // Moon(pos: Vec3(x:11, y:0, z:11))

    // Sample
    let startPositions = [
        Vec3(x:-1, y:0, z:2),
        Vec3(x:2, y:-10, z:-7),
        Vec3(x:4, y:-8, z:8),
        Vec3(x:3, y:5, z:-1)
    ]

    var zeroesX:[Int] = []
    var zeroesY:[Int] = []
    var zeroesZ:[Int] = []
    var velX:[Int] = []
    var velY:[Int] = []
    var velZ:[Int] = []
    
    let moonIndex = 0
    let initial = startPositions[moonIndex]
    let last = Vec3(x: 0, y:0, z: 0)
    let lastVel = Vec3(x: 0, y:0, z: 0)

    dump(initial)

    var verify:[Int:Vec3] = [:]
    while steps < 1000000 {
        day.update()
        if day.moons[moonIndex].pos.x == initial.x {
            // record delta to last "Nullstelle"
            zeroesX.append(steps-last.x)
            last.x = steps
        }
        // if day.moons[moonIndex].pos.y == initial.y {
        //     // record delta to last "Nullstelle"
        //     zeroesY.append(steps-last.y)
        //     last.y = steps
        // }
        // if day.moons[moonIndex].pos.z == initial.z {
        //     // record delta to last "Nullstelle"
        //     zeroesZ.append(steps-last.z)
        //     last.z = steps
        // }


        // if day.moons[moonIndex].vel.x == 0 {
        //     // record delta to last "Nullstelle"
        //     velX.append(steps-lastVel.x)
        //     lastVel.x = steps
        // }
        // if day.moons[moonIndex].vel.y == 0 {
        //     // record delta to last "Nullstelle"
        //     velY.append(steps-lastVel.y)
        //     lastVel.y = steps
        // }
        // if day.moons[moonIndex].vel.z == 0 {
        //     // record delta to last "Nullstelle"
        //     velZ.append(steps-lastVel.z)
        //     lastVel.z = steps
        // }
        
        steps += 1
    }

    // print(zeroesX.count, zeroesY.count, zeroesZ.count)
    // print(velX.count, velY.count, velZ.count)

    let periodX = findPeriod(zeroes:zeroesX)
    print("Period", periodX)

    // let periodY = findPeriod(zeroes:zeroesY)
    // let periodZ = findPeriod(zeroes:zeroesZ)
    
    // let periodVelX = findPeriod(zeroes:velX)
    // let periodVelY = findPeriod(zeroes:velY)
    // let periodVelZ = findPeriod(zeroes:velZ)
    

    // print("Period", periodX, periodY, periodZ)
    // print("Vel", periodVelX, periodVelY, periodVelZ)
}

// pos0
// 170 332 594 -> kgV = 8381340

// pos1
// 140 256 564

// pos2
// 142 292 216

// pos3
// 168 328 290

// Sample
// moon0 -> 20
// moon1 -> 21, 20
// moon2 -> 20
// moon3 -> 20