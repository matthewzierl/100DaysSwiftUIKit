//
//  ComposeNoteController.swift
//  SimpleNotes
//
//  Created by Matthew Zierl on 8/15/24.
//

import Foundation
import UIKit

class ComposeNoteController: UIViewController, UITextViewDelegate {
    
    var textView: UITextView!
    
    var note: Note?
    
    var allNotes: [Note]
    
    var delegate: ComposeNoteControllerDelegate?
    
    init(note: Note? = nil, allNotes: [Note]) {
        self.note = note
        self.allNotes = allNotes
        super.init(nibName: nil, bundle: nil) // have no clue what this does
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView = UITextView()
        
        if let note = note {
            textView.text = note.body
        } else {
            note = Note()
            allNotes.append(note!) // new note must be added
        }
        
        let noteOptions = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(presentNoteOptions))
        let shareNote = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareNote))
        
        navigationItem.rightBarButtonItems = [noteOptions, shareNote]
        
        textView.delegate = self
        
        view = textView
        
        delegate?.composeNoteControllerDidLoad(allNotes: allNotes)
        
        let camera = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(presentImageOptions))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let compose = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(composeNote))
        
        toolbarItems = [camera, flexibleSpace, compose]
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        saveNote()
    }
    
    @objc func presentNoteOptions(_ barButton: UIBarButtonItem) {
        
    }
    
    @objc func shareNote(_ barButton: UIBarButtonItem) {
        
    }
    
    @objc func presentImageOptions(_ barButton: UIBarButtonItem) {
        
    }
    
    @objc func composeNote(_ barButton: UIBarButtonItem) {
        
        
        let newNoteView = ComposeNoteController(note: nil, allNotes: allNotes)
        
        newNoteView.delegate = delegate
        
        
        navigationController?.pushViewController(newNoteView, animated: true)
    }
    
    func saveNote() {
//        if var allNotes = allNotes {
//            let defaults = UserDefaults.standard
//            note.title = getTitle()
//            note.body = textView.text
//            allNotes[note!.index] = note!
//            defaults.setValue(allNotes, forKey: "allNotes")
//        }
        guard let note = note else { return }
        
        note.title = getTitle()
        note.body = textView.text
        note.dateModified = Date.now
    }
    
    func getTitle() -> String {
        if let text = textView.text {
            if let firstLineRange = text.range(of: "\n") {
                return String(text[text.startIndex..<firstLineRange.lowerBound])
            } else {
                return "New note"
            }
        } else {
            return "New note"
        }
    }
    
}

protocol ComposeNoteControllerDelegate {
    func composeNoteControllerDidLoad(allNotes: [Note])
}
