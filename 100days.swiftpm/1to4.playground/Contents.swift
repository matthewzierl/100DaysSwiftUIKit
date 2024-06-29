import UIKit

import UIKit

var name = (first: "Taylor", last: "Swift") // tuple
print(name.0)
print(name.first)

var teams = [String: String]() // dictionary
var results = [Int]() // array
var people = Set<String>() // set

let hotel: [String: Int] = ["hotel": 1, "hotel2": 2] // dictionary
let names: [String] = ["matt", "leah"] // array
let chains: Set<String> = ["carlton", "7eleven"]

// enum associated values
enum activities {
    case running(Destination: String)
    case watching(Movie: String)
    case calling(Person: String)
}
let talking = activities.calling(Person: "MOM")

// enum raw values
enum planet: Int {
    case mercury = 1 // assign rest of planets prev + 1
    case venus
    case earth
    case mars
    case jupiter
    case saturn
    case neptune
    case uranus
    case pluto
}
let myPlanet = planet(rawValue: 3)

switch myPlanet {
case .mercury:
    print("on mercury!")
case .venus:
    print("on venus!")
case .earth:
    print("on earth!")
case .mars:
    print("on mars!")
case .jupiter:
    print("on jupiter!")
case .saturn:
    print("on saturn!")
case .neptune:
    print("on neptune!")
case .uranus:
    print("on uranus!")
case .pluto:
    print("on pluto!")
default:
    print("planets are cool...")
}

let score = 45

switch score {
case 0..<50:
    print("You failed badly.")
case 50..<85:
    print("You did OK.")
default:
    print("You did great!")
}

let firstCard = 11
let secondCard = 10
print(firstCard == secondCard ? "cards are the same" : "cards are different")


outerLoop: for i in 1...10 { // nested loop with outer label to break
    for j in 1...10 {
        let product = i * j
        print ("\(i) * \(j) is \(product)")

        if product == 5 {
            print("It's a bullseye!")
            break outerLoop
        }
    }
}



let count = 1...10
for number in count {
    print("we are at number \(number)")
    activities.running(Destination: "outside")
}



