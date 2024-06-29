import UIKit

class Dog {
    var name: String
    var breed: String
    
    init(name: String, breed: String) {
        self.name = name
        self.breed = breed
    }
}
var beagle = Dog(name: "loki", breed: "beagle")

class Poodle: Dog {
    init(name: String) {
        super.init(name: name, breed: "poodle")
    }
}
var poodle = Poodle(name: "dolan")

class Feline { // 'final' keyword before 'class' would prevent other classes from inheriting this class
    var whiskers: Bool
    func makeNoise() {
        print("mewmow")
    }
    init() {
        whiskers = true
    }
}
class Lion: Feline {
    override func makeNoise() {
        print("RARRRR")
    }
}
class Cat: Feline {
    override func makeNoise() {
        print("nyanya")
    }
}
var unknown = Feline()
var lion = Lion()
var cat = Cat()
unknown.makeNoise()
lion.makeNoise()
cat.makeNoise()

class Singer { // class vs struct copying
    var name = "Taylor Swift" // change to 'let' if u dont want member mutability
}

var singer = Singer() // even if using 'let' keyword, members are still mutatable
print(singer.name)  // Output: Taylor Swift

var singerCopy = singer // classes point to same object in memory, struct create new copy at this point
singerCopy.name = "Justin Bieber"

print(singer.name)  // Output: Justin Bieber
//struct Singer {
//    var name = "Taylor Swift"
//}
//
//var singer = Singer()
//print(singer.name)  // Output: Taylor Swift
//
//var singerCopy = singer
//singerCopy.name = "Justin Bieber"
//
//print(singer.name)  // Output: Taylor Swift

class Person {
    var name: String
    init(name: String) {
        self.name = name
    }
    func printGreeting() {
        print("Hello, my name is \(name)")
    }
    deinit {
        print("\(name) is no more.") // when an instance of 'Person' has no more references, cleans up using this
    }
}

for i in 0..<5 {
    var bot = Person(name: "person\(i)")
    bot.printGreeting()
}
