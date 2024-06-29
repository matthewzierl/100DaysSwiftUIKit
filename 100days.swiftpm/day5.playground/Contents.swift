import UIKit

func printHelp() { // normal func
    let message = """
blah blah blah
this is a test for fun printHelp()
leave a like and subscribe:)
"""
    print(message)
}

func square(number: Int) { // func w/ parameter
    let square = number * number
    print(square)
}

func doubleNum(number: Int) -> Int { // func w/ return value
    let doubleNum = number * 2
    return doubleNum
}

func sayHello(to name: String) { // function with 2 different labels for 1 pararmeter
    print("Hello, \(name)!")
}

func greet(_ person: String) { // function w/ no label for external use
    print("hey, \(person)")
}

func sayHi(_ person: String, nicely: Bool = true) { // default parameter set beforehand
    if nicely {
        print("hello there, \(person)")
    } else {
        print("FUCK YOU \(person)")
    }
}

func doubleAll(numbers: Int...) {
    print("doubleAll:")
    for number in numbers {
        print(number * 2)
    }
    print("end doubleAll")
}

enum PasswordError: Error { // for throwing errors, must create enum based on Swift's 'Error'
    case obvious
}
func checkPassword(_ password: String) throws -> Bool { // added 'throws' before return type
    if password == "password" {
        throw PasswordError.obvious
    }
    
    print("\(password) is a GREAT password...")
    return true
}

func doubleInPlace(_ num: inout Int) { // change values in place
    num = num * 2
}

printHelp()
square(number: 8)
print(doubleNum(number: 8))
sayHello(to: "matt") // using external label
greet("matt") // no label needed
sayHi("matt")
sayHi("matt", nicely: false) // changing value of default parameter
doubleAll(numbers: 2, 3, 4)
do {
    try checkPassword("password") // calling func that can throw errors
    // if error thrown nothing from here till 'catch' is reachable
} catch {
    print("password was too simple...")
}
var num = 6
print("before: \(num)")
doubleInPlace(&num)
print("after: \(num)")


