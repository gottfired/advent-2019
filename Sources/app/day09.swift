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

    func scan() {
        var maxSeen = 0
        var maxAsteroid = (0,0)
        for a in asteroids {
            var seen: [Double: [(Int, Int)]]=[:]
            for b in asteroids {
                if a != b {
                    let delta = (b.0-a.0, b.1-a.1)
                    let angle = atan2(Double(delta.0), Double(delta.1))
                    if var v = seen[angle] {
                        v.append(b)
                    } else {
                        seen[angle] = [b]
                    }
                    
                }
            }

            if seen.count > maxSeen {
                maxSeen = seen.count
                maxAsteroid = a
            }
        }

        print("maxAsteroid", maxAsteroid, maxSeen)
    }
}

func day09First() {
    let day = Day09()
    day.parse()
    day.scan()
}