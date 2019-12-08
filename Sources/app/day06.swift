import Foundation

class Node {
    init() {
        self.name = ""
        self.depth = 0
        self.children = []
    }
    var name: String
    var depth: Int
    var children: [Node]
    weak var parent: Node?
}

func updateDepths(node: Node) {
    for child in node.children {
        child.depth = node.depth + 1
        updateDepths(node: child)
    }
}

func buildOrbits() -> (Node, Node, Node) {
    var textFile = ""
    do {
        textFile = try String(contentsOf: URL(fileURLWithPath: "./src/day06.input")) 
    } catch {}

    let lines = textFile.components(separatedBy: "\r\n")
    var orbits: [String: Node] = [:]
    var center = Node();
    var you = Node();
    var san = Node();
    for element in lines {
        let parts = element.components(separatedBy: ")")
        let lhs = parts[0]
        let rhs = parts[1]
        // print(lhs, rhs)

        var parent = orbits[lhs]
        if parent == nil {
            let node = Node()
            node.name = lhs
            orbits[lhs] = node 
            parent = orbits[lhs];
        }

        var child = orbits[rhs];
        if child == nil {
            let node = Node()
            node.name = rhs
            orbits[rhs] = node
            child = orbits[rhs];
        }

        if let parent = parent, let child = child {
            if parent.name == "COM" {
                center = parent
            }

            if child.name == "YOU" {
                you = child
            } else if child.name == "SAN" {
                san = child
            }

            parent.children.append(child);
            child.parent = parent;
            child.depth = parent.depth + 1;
            updateDepths(node: child);
        }         
    }
    

    return (
        center,
        you,
        san
    )
}



func traverse(node: Node, counter: Int) -> Int{
    var ret = counter
    for child in node.children {
        ret += traverse(node: child, counter: 0)
        ret += child.depth
        // console.log("visiting", child.name, counter)
    }
    
    return ret
}


func findCommonAncestor(you: Node, san: Node) {
    // console.log("Finding ancestors for", you, san);

    var yourAncestors = [you.parent!.name];
    var node = you.parent;
    while node?.parent != nil {
        if let name = node?.parent?.name {
            yourAncestors.insert(name, at:0)
        }
        node = node?.parent
    }

    var santaAncestors = [san.parent!.name]
    node = san.parent
    while node?.parent != nil{
        if let name = node?.parent?.name {
            santaAncestors.insert(name, at:0)
        }
        node = node?.parent
    }

    // print(yourAncestors, santaAncestors)

    while yourAncestors[0] == santaAncestors[0] {
        yourAncestors.removeFirst();
        santaAncestors.removeFirst();
    }

    print("distance", yourAncestors.count + santaAncestors.count)
}


func day06First() {
    let (center, you, san) = buildOrbits()
    let total = traverse(node: center, counter: 0)
    print("total", total)

    findCommonAncestor(you: you, san: san)

}