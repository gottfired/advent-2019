use std::collections::HashMap;
use std::fs;

struct Node {
    name: String,
    parent: Option<String>,
    children: Vec<Node>,
    depth: i32,
}

impl PartialEq for Node {
    fn eq(&self, other: &Self) -> bool {
        self.name == other.name
    }
}

pub fn first() {
    let content = fs::read_to_string("./src/day06.input").expect("error reading file");
    let split = content.split("\n");
    let mut orbits = HashMap::new();
    for line in split {
        let parts: Vec<&str> = line.split(")").collect();
        let parent_name = parts[0].to_string();
        let child_name = parts[1].to_string();
        let parent = orbits.get(&parent_name);
        if parent == None {
            let parent_node = Node {
                name: parent_name.clone(),
                parent: None,
                children: Vec::new(),
                depth: 0,
            };
            orbits.insert(parent_name.clone(), &parent_node);
        }

        let child = orbits.get(&child_name);
        if child == None {
            let child_node = Node {
                name: child_name.clone(),
                parent: Some(parent_name.clone()),
                children: Vec::new(),
                depth: 0,
            };
            orbits.insert(child_name.clone(), &child_node);
        }

        // Now both nodes exist -> update depth
        let parent_node = orbits.get(&parent_name).unwrap();
        let child_node = orbits.get(&child_name).unwrap();
        parent_node.children.push(*child_node);

        // ... I give up!
    }
}
