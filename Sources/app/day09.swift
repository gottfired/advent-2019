import Foundation

class Day09 {
    let input = """
        .###.###.###.#####.#
        #####.##.###..###..#
        .#...####.###.######
        ######.###.####.####
        #####..###..########
        #.##.###########.#.#
        ##.###.######..#.#.#
        .#.##.###.#.####.###
        ##..#.#.##.#########
        ###.#######.###..##.
        ###.###.##.##..####.
        .##.####.##########.
        #######.##.###.#####
        #####.##..####.#####
        ##.#.#####.##.#.#..#
        ###########.#######.
        #.##..#####.#####..#
        #####..#####.###.###
        ####.#.############.
        ####.#.#.##########.
        """
    
    var asteroids:[(Int, Int)] = []
    let size = 20
    func parse() {
        var x = 0
        var y = 0
        for c in input {
            // print(x, y, c)
            if c == "#" {
                asteroids.append((x, y))
            }

            if c != "\n" {
                x += 1
                if x >= size {
                    x = 0
                    y += 1
                }
            }
        }
    }

    var maxAsteroid = (0,0)
    var maxSeen:[Double: [(Int, Int)]] = [:]

    func scan() {
        for a in asteroids {
            var seen: [Double: [(Int, Int)]]=[:]
            for b in asteroids {
                if a != b {
                    let delta = (b.0-a.0, b.1-a.1)
                    let angle = atan2(Double(delta.1), Double(delta.0))
                    if var v = seen[angle] {
                        v.append(b)
                        seen[angle] = v
                    } else {
                        seen[angle] = [b]
                    }
                    
                }
            }

            if seen.count > maxSeen.count {
                maxSeen = seen
                maxAsteroid = a
            }
        }

        print("maxAsteroid", maxAsteroid, maxSeen.count)
    }

    func shoot() {
        var angles = Array(maxSeen.keys)
        var angleMap:[Double:Double] = [:]
        for i in 0...angles.count-1 {
            let angle = angles[i]
            var corrected = angle + Double.pi/2
            while corrected < 0 {
                // convert negative angles to positive
                corrected += 2*Double.pi
            }
            
            while corrected > 2*Double.pi {
                // convert big angles
                corrected -= 2*Double.pi
            }

            print ("angle -> corrected", angle, corrected)

            // remember original angle for indexing later without rounding errors
            angleMap[corrected] = angle
            // store fixed angle for sorting
            angles[i] = corrected
        }

        // sort, so we contain angles starting at 90 degrees up
        angles.sort()
        // print("angles", angles[0], angleMap[angles[0]], maxSeen[angleMap[angles[0]]!])

        var sortedMaxSeen:[[(Int, Int)]] = []
        for angle in angles {
            guard let originalAngle = angleMap[angle] else { 
                print("illegal angle") 
                return
            }
            guard let asteroids = maxSeen[originalAngle] else { 
                print("illegal original")
                return 
            }

            // print("Before", asteroids)
            let sorted = asteroids.sorted(by: {(lhs, rhs) in 
                let deltaLhs = (maxAsteroid.0-lhs.0, maxAsteroid.1-lhs.1)
                let distanceLhs = sqrt(Double(deltaLhs.0*deltaLhs.0 + deltaLhs.1*deltaLhs.1))

                let deltaRhs = (maxAsteroid.0-rhs.0, maxAsteroid.1-rhs.1)
                let distanceRhs = sqrt(Double(deltaRhs.0*deltaRhs.0 + deltaRhs.1*deltaRhs.1))

                return distanceLhs > distanceRhs
            })

            sortedMaxSeen.append(sorted)
            print("Sorted", sorted)
        }

        var index = 0
        for _ in 0...199 {
            // find next non empty array
            while sortedMaxSeen[index].isEmpty {
                index += 1
                if index >= sortedMaxSeen.count {
                    index = 0
                }
            } 
            
            let target = sortedMaxSeen[index].popLast()
            print("shooting", target as Any)

            index += 1
        }
    }
}

func day09First() {
    let day = Day09()
    day.parse()
    day.scan()
    day.shoot()
}