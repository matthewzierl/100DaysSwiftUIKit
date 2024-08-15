//
//  Note.swift
//  SimpleNotes
//
//  Created by Matthew Zierl on 8/15/24.
//

import Foundation

class Note {
    var title: String = ""
    var body: String = ""
    var dateCreated: Date = Date.now
    var dateModified: Date = Date.now
    var index: Int = -1
}
