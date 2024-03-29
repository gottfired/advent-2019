struct Vec2 : Hashable {
    var x: Int
    var y: Int
}

class PaintingRobot {

    static let BLACK = 0
    static let WHITE = 1

    static let LEFT = 0
    static let RIGHT = 1

    var pos = Vec2(x:0, y:0)
    var dir = Vec2(x:0, y:1)
    var tiles: [Vec2: Int] = [:]

    let machine:Machine

    init() {
        let program = [3,8,1005,8,328,1106,0,11,0,0,0,104,1,104,0,3,8,102,-1,8,10,101,1,10,10,4,10,108,1,8,10,4,10,101,0,8,28,1006,0,13,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,1,10,4,10,1002,8,1,54,1,1103,9,10,1006,0,97,2,1003,0,10,1,105,6,10,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,1,10,4,10,1001,8,0,91,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,0,10,4,10,102,1,8,113,2,109,5,10,1006,0,96,1,2,5,10,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,0,10,4,10,102,1,8,146,2,103,2,10,1006,0,69,2,9,8,10,1006,0,25,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,0,10,4,10,101,0,8,182,3,8,1002,8,-1,10,101,1,10,10,4,10,108,1,8,10,4,10,1001,8,0,203,2,5,9,10,1006,0,0,2,6,2,10,3,8,102,-1,8,10,101,1,10,10,4,10,108,1,8,10,4,10,1002,8,1,236,2,4,0,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,0,10,4,10,1002,8,1,263,2,105,9,10,1,103,15,10,1,4,4,10,2,109,7,10,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,0,10,4,10,1001,8,0,301,1006,0,63,2,105,6,10,101,1,9,9,1007,9,1018,10,1005,10,15,99,109,650,104,0,104,1,21102,387508441116,1,1,21102,1,345,0,1106,0,449,21102,1,387353256852,1,21102,1,356,0,1105,1,449,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21101,179410308315,0,1,21102,1,403,0,1106,0,449,21101,206199495827,0,1,21102,414,1,0,1105,1,449,3,10,104,0,104,0,3,10,104,0,104,0,21102,718086758760,1,1,21102,1,437,0,1105,1,449,21101,838429573908,0,1,21102,448,1,0,1106,0,449,99,109,2,21202,-1,1,1,21102,1,40,2,21102,480,1,3,21101,470,0,0,1105,1,513,109,-2,2105,1,0,0,1,0,0,1,109,2,3,10,204,-1,1001,475,476,491,4,0,1001,475,1,475,108,4,475,10,1006,10,507,1102,0,1,475,109,-2,2106,0,0,0,109,4,2101,0,-1,512,1207,-3,0,10,1006,10,530,21101,0,0,-3,21202,-3,1,1,21201,-2,0,2,21102,1,1,3,21102,549,1,0,1105,1,554,109,-4,2106,0,0,109,5,1207,-3,1,10,1006,10,577,2207,-4,-2,10,1006,10,577,22102,1,-4,-4,1106,0,645,22102,1,-4,1,21201,-3,-1,2,21202,-2,2,3,21101,596,0,0,1106,0,554,22101,0,1,-4,21102,1,1,-1,2207,-4,-2,10,1006,10,615,21101,0,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,637,21201,-1,0,1,21101,637,0,0,106,0,512,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2106,0,0]
        machine = Machine(withProgram:program)
    }

    func paint(_ color: Int) {
        // print("paint")
        tiles[pos] = color
    }

    func move(_ turn: Int) {
        // print("move")
        if (turn == PaintingRobot.LEFT) {
            switch dir {
                case Vec2(x:0, y:1): dir = Vec2(x:-1, y: 0)
                case Vec2(x:-1, y:0): dir = Vec2(x:0, y: -1)
                case Vec2(x:0, y:-1): dir = Vec2(x:1, y: 0)
                case Vec2(x:1, y:0): dir = Vec2(x:0, y: 1)
                default: break
            }
        } else {
            switch dir {
                case Vec2(x:0, y:1): dir = Vec2(x:1, y: 0)
                case Vec2(x:1, y:0): dir = Vec2(x:0, y: -1)
                case Vec2(x:0, y:-1): dir = Vec2(x:-1, y: 0)
                case Vec2(x:-1, y:0): dir = Vec2(x:0, y: 1)
                default: break
            }
        }

        pos = Vec2(x:pos.x+dir.x, y:pos.y+dir.y)
    }

    enum State {
        case paint
        case move
    }

    var state = State.paint

    func handleOutput(value:Int) {
        if state == State.paint {
            paint(value)
            // print("paint", value)
            state = State.move
        } else {
            move(value)
            // print("move", value)
            state = State.paint
        }
    }

    func run(startColor: Int) {
        var (_, halt) = machine.runMachine(input:[startColor], onOutput:handleOutput)
        // print("state: ", pos, dir)
        var i = 0
        while !halt {
            let color = tiles[pos] ?? 0
            (_, halt) = machine.runMachine(input:[color], onOutput:handleOutput)
            // print("state: ", pos, dir)
            i += 1
        }
        print("num painted", tiles.count)
    }   
}


func day11First() {
    let robot = PaintingRobot()
    robot.run(startColor: PaintingRobot.BLACK)
}

func day11Second() {
    let robot = PaintingRobot()
    robot.run(startColor: PaintingRobot.WHITE)

    let coords = Array(robot.tiles.keys)
    var minX = 0
    var minY = 0
    var maxX = 0
    var maxY = 0
    for c in coords {
        minX = min(minX, c.x)
        maxX = max(maxX, c.x)
        minY = min(minY, c.y)
        maxY = max(maxY, c.y)
    }

    print(minX, minY, maxX, maxY)

    for y in (minY...maxY).reversed() {
        var line = ""
        for x in minX...maxX {
            let c = robot.tiles[Vec2(x:x, y:y)] ?? 0
            line += c == 0 ? " " : "X"
        }
        print(line)
    }
}
