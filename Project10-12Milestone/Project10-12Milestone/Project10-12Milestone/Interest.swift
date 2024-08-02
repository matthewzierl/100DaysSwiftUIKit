//
//  Interest.swift
//  Project10-12Milestone
//
//  Created by Matthew Zierl on 8/2/24.
//

import UIKit

class Interest: NSObject, Codable {
    
    var interest: String
    var image: String
    
    init(interest: String, image: String) {
        self.interest = interest
        self.image = image
    }
}
