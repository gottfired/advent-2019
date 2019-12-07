fs = require("fs");


function updateDepths(node) {
    node.children.forEach(child => {
        child.depth = node.depth + 1;
        updateDepths(child);
    });
}

function buildOrbits() {
    const file = fs.readFileSync("src/day06.input", "utf8").split("\r\n");
    let orbits = {};
    let center = null;
    let you = null;
    let san = null;
    file.forEach(element => {
        const [lhs, rhs] = element.split(")");
        // console.log("mapping", lhs, rhs);
        let parent = orbits[lhs];
        if (!parent) {
            orbits[lhs] = {
                name: lhs,
                depth: 0,
                children: []
            }

            parent = orbits[lhs];
        }

        let child = orbits[rhs];
        if (!child) {
            orbits[rhs] = {
                name: rhs,
                children: []
            }

            child = orbits[rhs];
        }

        if (parent.name === "COM") {
            center = parent;
        }

        if (child.name === "YOU") {
            you = child;
        } else if (child.name === "SAN") {
            san = child;
        }

        parent.children.push(child);
        child.parent = parent;
        child.depth = parent.depth + 1;
        updateDepths(child);
    });

    return {
        center,
        you,
        san
    }
}


function traverse(node, counter) {
    node.children.forEach(child => {
        counter += traverse(child, 0);
        counter += child.depth;

        // console.log("visiting", child.name, counter);
    });

    return counter;
}

function findCommonAncestor(you, san) {
    console.log("Finding ancestors for", you, san);

    const yourAncestors = [you.parent];
    let node = you.parent;
    while (node.parent) {
        yourAncestors.unshift(node.parent.name);
        node = node.parent;
    }

    const santaAncestors = [san.parent];
    node = san.parent;
    while (node.parent) {
        santaAncestors.unshift(node.parent.name);
        node = node.parent;
    }

    console.log(yourAncestors, santaAncestors);

    while (yourAncestors[0] === santaAncestors[0]) {
        yourAncestors.shift();
        santaAncestors.shift();
    }

    console.log("distance", yourAncestors.length + santaAncestors.length);
}


const data = buildOrbits();
total = traverse(data.center, 0);
console.log("total", total);

findCommonAncestor(data.you, data.san);