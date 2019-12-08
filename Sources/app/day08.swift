import Foundation

func bytesFromFile(_ filePath: String) -> [UInt8]? {
    guard let data = NSData(contentsOfFile: filePath) else { return nil }

    var buffer = [UInt8](repeating: 0, count: data.length)
    data.getBytes(&buffer, length: data.length)

    return buffer
}

func day08First() {
    guard let bytes = bytesFromFile("./Sources/app/day08.input") else { return }

    let input = bytes.map { $0 - UInt8(48) }    
    let width = 25
    let height = 6
    let size = width*height
    let layerCount = input.count/size

    print("Num pixels", input.count)
    print("Num layers", layerCount)

    var min0 = 99999
    var minLayerNum1 = 0
    var minLayerNum2 = 0
    
    for layer in 0...layerCount-1 {
        var num0 = 0
        var num1 = 0
        var num2 = 0
        for p in 0...size-1 {
            // let index = layer*size + p
            // print("reading", index)
            let pixel = input[layer*size + p]
            if pixel == 0 {
                num0 += 1
            }
            else if pixel == 1 {
                num1 += 1
            }
            else if pixel == 2 {
                num2 += 1
            }
        }

        if num0 < min0 {
            min0 = num0
            minLayerNum1 = num1
            minLayerNum2 = num2
        }
    }

    print("min0 \(min0), ones \(minLayerNum1), twos \(minLayerNum2) -> \(minLayerNum1*minLayerNum2)")
}



func day08Second() {
    guard let bytes = bytesFromFile("./Sources/app/day08.input") else { return }

    let input = bytes.map { $0 - UInt8(48) }    
    let width = 25
    let height = 6
    let size = width*height
    let layerCount = input.count/size

    var result = [UInt8](repeating: 2, count: size)
    
    for layer in 0...layerCount-1 {
        for p in 0...size-1 {
            let target = result[p]
            if target == 2 {
                let pixel = input[layer*size + p]
                if pixel == 0 || pixel == 1 {
                    result[p] = pixel
                }
            }
        }
    }

    print(result)
}