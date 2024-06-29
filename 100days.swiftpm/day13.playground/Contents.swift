import UIKit

var names = [String]()
names.append("matt")
print(names)

var person = Dictionary<String, String>()
person["matt"] = "a piece of shit"
if let desc = person["matt"] {
    print(desc)
}

for num in 1...10 {
    let output = num * 10
    print("\(num) x 10 is \(output)")
}

