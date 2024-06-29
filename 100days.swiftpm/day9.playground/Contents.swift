import UIKit

struct User {
    var username: String
    
    init() { // with an 'init()', creating an instance doesn't require parameters
        username = "ANONYMOUS"
        print("creating anonymous user...")
    }
}
var matt = User()
print(matt.username)
matt.username = "matt"
print(matt.username)

struct Person {
    var name: String
    
    init(name: String) {
        print("received name: \(name)")
        self.name = name // self refers to struct, name is parameter
    }
}
var me = Person(name: "matt")

struct FamilyTree {
    var members: [String]
    init() {
        print("creating family tree!")
        members = [String]()
    }
}
struct Member {
    var name: String
    lazy var familyTree = FamilyTree()
    init(name: String) {
        self.name = name
    }
}
var lucas = Member(name: "Lucas")
lucas.familyTree.members.append("adam")
print(lucas.familyTree.members)

struct Student {
    static var numStudents = 0 // 'static' is same across all instances
    var name: String
    init(name: String) {
        self.name = name
        Student.numStudents += 1
    }
    
    static func killAll() {
        Student.numStudents = 0
    }
}
var ryan = Student(name: "Ryan")
print(Student.numStudents)
var pranav = Student(name: "Pranav")
print(Student.numStudents)
Student.killAll()
print(Student.numStudents)

struct Employee {
    private var id: String // 'private' keyword means you can't change var directly after initialization
    
    init(id: String) {
        self.id = id
    }
    
    mutating func changeID(id: String) { // can use function to change value of private vars
        self.id = id
    }
    
    func printID() {
        print(self.id)
    }
}
var stanley = Employee(id: "417")
stanley.printID()
stanley.changeID(id: "123")
stanley.printID()
