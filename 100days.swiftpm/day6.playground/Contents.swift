import UIKit

let driving = { // basic closure
    print("I'm driving in my car")
}

let location = { (place: String) in // adding parameters for a basic closure
    print("we are driving in \(place)")
}

let drivingWithLocation = { (place: String) -> String in // closures CAN RETURN?!?!?!
    return "we driving up in \(place)"
}

/**
        USING CLOSURES AS PARAMETERS NOW...
*/

let shopping = { // closure that returns void
    print("i'm shopping^_^")
}
func letsShop(action: () -> Void) { // () denotes closure (has no name) and returns Void (nothing)
    print("we going shopping in keonji boys")
    action()
    print("check out this haulXD")
}

let example = { () -> Int in // closure w/ no parameters but still returns a value
    return 22
}

func travel(destination: () -> Void) {
    print("boarding my flight")
    destination()
    print("finally landing!")
}

travel() { // TRAILING CLOSURE SYNTAX only works bc closure is last parameter in function
    print("flying to tokyo via EVA air...")
}
// but since there are no other parameters... you can just
travel {
    print("flying 2 tokyo via EVA air...")
}

func holdClass(name: String, lesson: () -> Void) {
    print("Welcome to \(name)!")
    lesson()
    print("Make sure your homework is done by next week.")
}
holdClass(name: "Philosophy 101") { // trailing closure syntax w/ another variable before
    print("All we are is dust in the wind, dude.")
}



driving()
location("tokyo")
print(drivingWithLocation("tokyo"))

letsShop(action: shopping)

print(example())

