//
//  Capital.swift
//  Project16
//
//  Created by Matthew Zierl on 8/8/24.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D // must have coordinate to conform to MKAnnotation
    var extraInfo: String
    var wiki: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, extraInfo: String, wiki: String) {
        self.title = title
        self.coordinate = coordinate
        self.extraInfo = extraInfo
        self.wiki = wiki
    }
}
