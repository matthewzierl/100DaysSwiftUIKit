import UIKit

func travel(place: (String) -> Void) {
    print("I want to travel to...")
    place("Tokyo") // calls a parameter closure which itself requires a string
    print("probably by plane...")
}

travel { (place: String) in
    print(place)
}

func getDirections(to destination: String, then travel: ([String]) -> Void) {
    let directions = [
        "Go straight ahead",
        "Turn left onto Station Road",
        "Turn right onto High Street",
        "You have arrived at \(destination)"
    ]
    travel(directions)
}
getDirections(to: "London") { (directions: [String]) in // calling function w/ another parameter then a closure that requires a parameter
    print("I'm getting my car.")
    for direction in directions {
        print(direction)
    }
}

func makeFriends(talkTo: ([String]) -> String) { // using closure that requires both parameter and return
    print("Today I'm going to a house party in Madison...")
    let people = ["matt", "lucas", "ryan"]
    let conversation = talkTo(people) // store value returned
    print(conversation, terminator: "")
    print("hopefully i will make friendsD:")
}

makeFriends { (people: [String]) -> String in // closure that returns a value
    var wholeConversation = ""
    for person in people {
        let individualConversation = "gonna talk to \(person)\n"
        wholeConversation += individualConversation
    }
    return wholeConversation
}

func reduce(_ values: [Int], using closure: (Int, Int) -> Int) -> Int {
    // start with a total equal to the first value
    var current = values[0]

    // loop over all the values in the array, counting from index 1 onwards
    for value in values[1...] {
        // call our closure with the current value and the array element, assigning its result to our current value
        current = closure(current, value)
    }

    // send back the final current value
    return current
}



let numbers = [10, 20, 30]
let sum = reduce(numbers) { (runningTotal, next) in // don't actually need to label parameters, swift can figure it out
    runningTotal + next // IMPLICIT RETURN
}
let otherSum = reduce(numbers, using: +)
print("using our own closure: \(sum)")
print("using + operator (basically a closure): \(otherSum)")


func callHome(member: (String) -> String) {
    print("Planning to call family")
    let person = member("mom")
    print(person)
    print("Done calling...")
}

callHome { (person: String) in // BEFORE
    return "calling \(person)"
}
/**
        Can Remove:
            - defining type for parameter (everything after name of parameter)
            - remove 'return' since Swift knows it will return string
            - remove -> String since Swift knows what type will return
            - Swift can use automatic names, counting from 0, for the parameter
 */
callHome { // AFTER
    "calling \($0)" // automatic name, implicit return
}




func goBiking(go: (String, Int) -> String) {
    print("i miss my motorcycle, lets go for a ride!")
    let response = go("Madison", 20)
    print(response)
    print("lets go im exited(^^)")
}

goBiking {
    "plotting a course for \($0) approximately \($1) miles away"
}


func practiceSwift() -> (String) -> String {
    return {
        return "today we are practicing \($0)"
    }
}

let outClosure = practiceSwift()
print(outClosure("swift"))
print(practiceSwift()("UIKit")) // you can do this but not recommended


func makeRandomNumberGenerator() -> () -> Int {
    var previousNumber = 0 // move to outside so each call to instance of makeRandomNumberGenerator has same previous number
    return {
//        var previousNumber = 0
        var newNumber: Int

        repeat {
            newNumber = Int.random(in: 1...3)
        } while newNumber == previousNumber

        previousNumber = newNumber
        return newNumber
    }
}
let generator = makeRandomNumberGenerator() // 'catpures' value of previousNumber (keeps it alive)

for _ in 1...10 {
    print(generator())
}
