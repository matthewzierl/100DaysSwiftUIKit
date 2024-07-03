import UIKit
// by default, Swift uses strong capturing

class Singer {
    func playSong() {
        print("Shake it off!")
    }
}

//func sing() -> () -> Void {
//    
//    let taylor = Singer()
//    let singing = {
//        taylor.playSong() // uses instance created outside closure, Swift automatically uses 'strong capturing' to make sure 'taylor' isn't destroyed for as long as the closure exists somewhere
//        return
//    }
//    return singing
//}

/*
    Doesn't print anymore because of weak taylor:(
    note: can also use 'unknowned taylor' which works similar to an force unwrapped conditional where taylor could be nil but it proceeds anyways, potentially leading to a crash
 */
func sing() -> () -> Void {
    
    let taylor = Singer()
    
    // 'weak' means Swift won't make sure external values outside a closure are kept alive
    let singing = { [weak taylor] in
        taylor?.playSong() // since 'weak' is used, taylor must be an optional, and we must use optional chaining here
        return
    }
    return singing
}

let singFunction = sing()
singFunction()


class House {
    var ownerDetails: (() -> Void)?

    func printDetails() {
        print("This is a great house.")
    }

    deinit {
        print("I'm being demolished!")
    }
}

class Owner {
    var houseDetails: (() -> Void)?

    func printDetails() {
        print("I own a house.")
    }

    deinit {
        print("I'm dying!")
    }
}

print("Creating a house and an owner")

do {
    // swift automatically does strong references when referencing instances outside of closures
    let house = House()
    let owner = Owner()
    house.ownerDetails = owner.printDetails // creates strong references
    owner.houseDetails = house.printDetails // house's owner details references owner's method, owner's house details references house method
    // keeping these strong references will cause a memory leak (memory not freed and not used)
}

print("Done")

print("\nSPACER ------------------- SPACER\n")

print("Creating a house and an owner")

do {
    let house = House()
    let owner = Owner()
    house.ownerDetails = { [weak owner] in owner?.printDetails() }
    owner.houseDetails = { [weak house] in house?.printDetails() }
}

print("Done")
