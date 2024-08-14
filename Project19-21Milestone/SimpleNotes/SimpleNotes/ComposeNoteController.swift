//
//  ComposeNoteController.swift
//  SimpleNotes
//
//  Created by Matthew Zierl on 8/15/24.
//

import Foundation
import UIKit

class ComposeNoteController: UIViewController {
    
    var textView: UITextView! // constructor called in viewDidLoad
    
    var note = Note(title: "", body: "", dateCreated: Date.now, dateModified: Date.now)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView = UITextView()
        
        view = textView
        
        let camera = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(presentImageOptions))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let compose = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(composeNote))
        
        toolbarItems = [camera, flexibleSpace, compose]
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    @objc func presentImageOptions(_ barButton: UIBarButtonItem) {
        
    }
    
    @objc func composeNote(_ barButton: UIBarButtonItem) {
        let newNoteView = ComposeNoteController()
        navigationController?.pushViewController(newNoteView, animated: true)
    }
    
}
