import UIKit

protocol Identifiable {
    var id: String {get set}
    func identify()
}
struct User: Identifiable {
    var id: String
}
func displayID(user: Identifiable) {
    print("ID is \(user.id)")
}
var bot = User(id: "111")
displayID(user: bot)

protocol Payable {
    var currency: String {get set}
    var wage: Int {get set}
    func calculateWages() -> Int
}
protocol Educated {
    var degree: String {get set}
    var year: Int {get set}
    mutating func study()
}
protocol HasVacation {
    var vacationDays: Int {get set}
    func takeVacation(days: Int)
}
protocol Employee: Payable, Educated, HasVacation {} // protocol inheritance
protocol Intern: Payable, Educated {} // more protocol inheritance

class CompanyIntern: Intern {
    var currency: String
    var wage: Int
    func calculateWages() -> Int {
        print("Wage: \(wage) \(currency)")
        return wage
    }
    
    var degree: String
    var year: Int
    func study() {
        self.year = self.year + 1
    }
    
    init(currency: String, wage: Int, degree: String, year: Int) {
        self.currency = currency
        self.wage = wage
        self.degree = degree
        self.year = year
    }
}
class CompanyEmployee: Employee {
    var currency: String
    var wage: Int
    func calculateWages() -> Int {
        print("Wage: \(wage) \(currency)")
        return wage
    }
    
    var degree: String
    var year: Int
    func study() {
        self.year = self.year + 1
    }
    
    var vacationDays: Int
    func takeVacation(days: Int) {
        print("taking vacation for \(days) days...")
        self.vacationDays = self.vacationDays - days
    }
    
    init(currency: String, wage: Int, degree: String, year: Int, vacationDays: Int) {
        self.currency = currency
        self.wage = wage
        self.degree = degree
        self.year = year
        self.vacationDays = vacationDays
    }
}
var chris = CompanyEmployee(currency: "USD", wage: 100000, degree: "Computer Science", year: 4, vacationDays: 14)
var matt = CompanyIntern(currency: "Yen", wage: 50000, degree: "Computer Science", year: 3)
let chrisWage = chris.calculateWages()
print("Chris \(chrisWage)")
let mattWage = matt.calculateWages()
print("matt \(mattWage)")
print("hi i'm chris i have \(chris.vacationDays) of vacation.")
chris.takeVacation(days: 7)
print("now i only have \(chris.vacationDays) days of vacation")

extension Int { // 'extension' allows you to extend functionality to different types
    func squared() -> Int {
        return self * self
    }
}
let num = 5
print(num.squared())
extension Int { // 'extension' cannot contain stored properties, must use computer properties instead
    var isEven: Bool {
        return self % 2 == 0
    }
}
print(num.isEven)

// Both arrays and sets conform to protocol 'Collections'
var mains = ["pacman", "pikachu", "kazuya"]
var characters = Set(["roy", "mario", "marth"])
// extend 'Collection' protocol for custom functionality
extension Collection {
    func printSummary() {
        print("There are \(count) members")
        for name in self {
            print("member: \(name)")
        }
    }
}
mains.printSummary()
characters.printSummary()

protocol Anime {
    var availableLanguages: [String] { get set }
    func watch(in language: String)
}
extension Anime {
    func watch(in language: String) {
        if availableLanguages.contains(language) {
            print("Now playing in \(language)")
        } else {
            print("Unrecognized language.")
        }
    }
}
class AngelBeats: Anime {
    var availableLanguages: [String]
    init(availableLanguages: [String]) {
        self.availableLanguages = availableLanguages
    }
}
var myFavAnime = AngelBeats(availableLanguages: ["Japanese", "English"])
myFavAnime.watch(in: "English")

// From early^^^...
//protocol Identifiable {
//    var id: String {get set}
//}
//struct User: Identifiable {
//    var id: String
//}
//func displayID(user: Identifiable) {
//    print("ID is \(user.id)")
//}
//var bot = User(id: "111")
//displayID(user: bot)
extension Identifiable {
    func identify() {
        print("ID is \(id)") // since we extended 'Identifiable', no longer need displayID func standalone
    }
}
bot.identify()

protocol moreIdentifiable: Identifiable { // protocol inheritance
    var numID: Int {get set}
}

struct robot: moreIdentifiable {
    var numID: Int
    var id: String
}
