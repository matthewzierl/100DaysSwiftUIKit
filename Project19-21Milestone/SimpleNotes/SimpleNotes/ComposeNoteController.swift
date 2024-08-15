//
//  ComposeNoteController.swift
//  SimpleNotes
//
//  Created by Matthew Zierl on 8/15/24.
//

import Foundation
import UIKit

class ComposeNoteController: UIViewController, UITextViewDelegate {
    
    var textView: UITextView! // constructor called in viewDidLoad
    
    var note: Note! // always passed 
    
    var allNotes: [Note]!
    
    weak var delegate: ComposeNoteControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var noteOptions = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(presentNoteOptions))
        var shareNote = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareNote))
        
        navigationItem.rightBarButtonItems = [noteOptions, shareNote]
        
        textView = UITextView()
        textView.delegate = self
        
        view = textView
        
        let camera = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(presentImageOptions))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let compose = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(composeNote))
        
        toolbarItems = [camera, flexibleSpace, compose]
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.removedFromNavigationStack(allNotes: allNotes)
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
        let newNoteView = ComposeNoteController()
        let newNote = Note()
        
        newNoteView.note = newNote
        newNoteView.allNotes = allNotes
        newNoteView.delegate = delegate // set to own delegate i.e view controller
        
        allNotes.append(newNote)
        print("in save")
        print("appending new note, count is now: \(allNotes.count)")
        
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
        note.title = getTitle()
        note.body = textView.text
        note.dateModified = Date.now
        print("Saving note with index: \(note.index)")
        allNotes[note!.index] = note!
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

protocol ComposeNoteControllerDelegate: AnyObject {
    func removedFromNavigationStack(allNotes: [Note])
}
