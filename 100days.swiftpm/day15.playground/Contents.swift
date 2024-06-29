import UIKit

// Property Observers
struct Bot {
    var name: String {
        willSet { // before changing the property
            updateUI("Person changing names from \(name) to \(newValue)")
        }
        didSet { // after changing the property
            print("Person successfully changed names from \(oldValue) to \(name)")
        }
    }

}
func updateUI(_ msg: String) {
    print(msg)
}
var matt = Bot(name: "Matt")
matt.name = "Matthew"

// computed properties
struct Person {
    var age: Int

    var ageInDogYears: Int {
        get {
            return age * 7
        }
    }
}

var fan = Person(age: 25)
print(fan.ageInDogYears)

/*
 ACCESS CONTROL:
 Public: this means everyone can read and write the property.
 Internal: this means only your Swift code can read and write the property. If you ship your code as a framework for others to use, they won’t be able to read the property.
 File Private: this means that only Swift code in the same file as the type can read and write the property.
 Private: this is the most restrictive option, and means the property is available only inside methods that belong to the type, or its extensions.
 */
class TaylorFan {
    private var name: String?
}

// Polymorphism and Typecasting
class Game {
    var name: String
    init(name: String) {
        self.name = name
    }
    
    func getGameName() -> String {
        return "\(name) is bad game"
    }
}
class StudioGame: Game {
    var studio: String
    
    init(name: String, studio: String) {
        self.studio = studio
        super.init(name: name)
    }
    
    override func getGameName() -> String {
        return "\(name) is a solid game made by the studio \(studio)"
    }
}
class IndieGame: Game {
    var creator: String
    
    init(name: String, creator: String) {
        self.creator = creator
        super.init(name: name)
    }
    override func getGameName() -> String {
        return "\(name) is an amazing game made solely by \(creator)"
    }
}
var halo = StudioGame(name: "Halo: Combat Evolved", studio: "Bungie")
var fnaf = IndieGame(name: "Five Nights at Freddies", creator: "Scott Cawthon")
var overwatch = StudioGame(name: "Overwatch 2", studio: "Blizzard")

var myGames: [Game] = [halo, fnaf, overwatch]

for game in myGames as? [StudioGame] ?? [StudioGame](){ // ALL games in array must be StudioGames for loop to enter
    print(game.getGameName())
}
print("BREAK")
for game in myGames{
    print(game.getGameName())
    if let game = game as? StudioGame {
        print(game.studio)
    } else if let game = game as? IndieGame {
        print(game.creator)
    } else {
        print("WHAT THE FUCK IS GOING ON")
    }
}

// closures
let vw = UIView()
UIView.animate(withDuration: 0.5) {
    vw.alpha = 0
}
