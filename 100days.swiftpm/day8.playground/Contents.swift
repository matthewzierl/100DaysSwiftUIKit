import UIKit

struct Sport {
    var name: String
    var isOlympic: Bool
    
    var olympicStatus: String { // computed property, must have explicit type
        if (isOlympic) {
            return "\(name) is an olympic sport"
        }
        return "\(name) is NOT an olympic sport"
    }
}
var tennis = Sport(name: "tennis", isOlympic: false)
print(tennis.name)
print(tennis.olympicStatus)


struct Progress {
    var task: String
    var amount: Int { // property observer
        didSet {
            print("Task is now \(amount)% complete")
        }
    }
}

var progress = Progress(task: "Loading data...", amount: 0)
progress.amount = 30
progress.amount = 80
progress.amount = 100

struct City {
    var name: String
    var population: Int
    
    func collectTaxes() -> Int { // functions inside structs are called methods
        return population * 1000
    }
}

var tokyo = City(name: "Tokyo", population: 10_000_000)
print("in the city of \(tokyo.name) collecting total taxes $\(tokyo.collectTaxes())")


struct Person {
    var name: String
    
    mutating func makeAnonymous() { // 'mutating' keyword needed if you want to change member of struct
                                    // additionally, 'mutating' keyword stops constant instances from changing values
        name = "ANONYMOUS"
    }
}
var friend = Person(name: "matt")
print(friend.name)
friend.makeAnonymous()
print(friend.name)


// String is a type of struct
var phrase = "i want to live in tokyo"
print(phrase)
print(phrase.sorted())
print(phrase.count)
print(phrase.uppercased())
print(phrase.removeLast())
print(phrase)

// Arrays are structs
var toys = ["iphone"]
print(toys)
print(toys.count)
toys.append("macbook")
toys.sort()
print(toys.count)
print(toys)

var numbers = [Int]()
var otherNumbers: [Int]
