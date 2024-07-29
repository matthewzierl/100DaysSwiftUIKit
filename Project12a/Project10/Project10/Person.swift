//
//  Person.swift
//  Project10
//
//  Created by Matthew Zierl on 7/26/24.
//

import UIKit

/*
    NSCoding requires NSObject
    NSCoding - for archiving/distributing
 */
class Person: NSObject, NSCoding, NSSecureCoding {
    
    static var supportsSecureCoding: Bool = true
    
    var name: String
    var image: String
    
    /*
        writing to disc
     */
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
    }
    
    /*
        reading from disc
     */
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        image = coder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
