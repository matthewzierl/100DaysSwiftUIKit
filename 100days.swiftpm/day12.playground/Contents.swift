import UIKit

var age: Int? = nil // optional '?' allows for any value within the type, but now also includes nil (does not exist)
age = 38

// IMPORTANT: Swift will NOT allow us to use optionals without unwrapping first
// 'if let' ONLY works with optionals
var name:String? = nil
if let unwrapped = name { // UNWRAPPING, if contains non-nil value, proceeds to if, otherwise else statement
    print("Name? \(unwrapped).")
} else {
    print("Name Does Not Exist")
}
// 'unwrapped' only usable within scope of if else statement

let album = "nil"
let albums = ["Reputation", "Red", "1989"]
if let position = albums.firstIndex(of: album) { // firstIndex returns Int?
    print("Found \(album) at position \(position).")
}

func nextNum(num: Int?) {
    guard let unwrapped = num else { //
        print("wow gave me a nil...")
        return // expects you to exit right away
    }
    var nextNum = unwrapped + 1 // unwrapped usuable outside of initial statement
    print("you gave me number \(unwrapped)!! next number is \(nextNum)!")
}
var myNum: Int? = nil
nextNum(num: myNum)

// forceful unwrapping
var str = "4"
let exNum = Int(str)! // Int(var) returns optional Int representation
                     // '!' forces unwrapping to type Int, but can crash if wrong -> only use if you know FOR SURE 100%
print(exNum)

// implicitly unwrapping
// don't need to use 'if let' or 'guard let'
let day: Int! = nil // already unwrapped with nil value, will crash if used right now
// only use if you know FOR SURE 100% that a value will be set for it

// nil coalescing
// Allows use of default value when receiving an optional
func username(for id: Int) -> String? {
    if id == 1 {
        return "Matthew Zierl"
    } else {
        return nil
    }
}
let user = username(for: 4) ?? "matt" // default value of 'matt' by using '??'

// optional chaining
let names = ["matt", "lucas", "ryan", "adam"]
let names2 = [String]()
let firstName = names.first?.uppercased() // '?.' unwraps 'first's output, if !nil, proceed, otherwise stop
if let firstName = firstName {
    print(firstName)
} else {print("name does not exist")}

// optional try
enum PasswordError: Error {
    case obvious
}
func checkPassword(_ password: String) throws -> Bool {
    if password == "password" {
        throw PasswordError.obvious
    }

    return true
}

do {
    try checkPassword("password")
    print("That password is good!")
} catch {
    print("You can't use that password.")
}
if let result = try? checkPassword("matt") { // changes result of checkPassword into an optional, if !nil stores into result
    print(result)
    print("The password is great!")
}
try! checkPassword("sekrit") // '!' know FOR SURE 100% function won't fail
print("OK!")

// failable initializers
struct Person {
    var name: String
    
    init?(name: String) { // failable intializer
        if name.count == 4 {
            self.name = name
        } else {
            return nil // can return nil if something goes wrong
        }
    }
}
var matt = Person(name: "matthew") // returns an optional
if let matt = matt {
    print(matt.name)
} else {
    print("bad name")
}

// Typecasting
class Animal{}
class Fish: Animal{}
class Dog: Animal {
    func makeNoise() {
        print("Woof")
    }
}
let pets = [Fish(), Dog(), Fish(), Dog()]
for pet in pets {
    if let myPetDog = pet as? Dog { // 'as' returns optional, Dog or nil
        myPetDog.makeNoise()
    } else {
        print("nyanya")
    }
}

// other
func process(order: String) {
    print("OK, I'll get your \(order).")
}
let pizzaRequest: String! = "pizza"
process(order: pizzaRequest)

struct Bird {
    var name: String
    init?(name: String) {
        guard name == "Lassie" else {
            print("Sorry, wrong dog!")
            return nil
        }
        self.name = name
    }
}
let bird = Bird(name: "birdie")
