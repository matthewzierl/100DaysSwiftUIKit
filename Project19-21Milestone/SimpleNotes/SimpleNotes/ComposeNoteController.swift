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
    
    var allNotes: [[Note]]
    
    var delegate: ComposeNoteControllerDelegate?
    
    init(note: Note? = nil, allNotes: [[Note]]) {
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
            note!.dateModified = note!.dateModified
            let arr = [note!]
            allNotes.append(arr) // new note must be added, will sort later
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
        
        let notificationCenter = NotificationCenter.default
        
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(showEditingOptions), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(showOptions), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        saveNote()
    }
    
    @objc func presentNoteOptions(_ barButton: UIBarButtonItem) {
        
    }
    
    @objc func shareNote(_ barButton: UIBarButtonItem) {
        let ac = UIActivityViewController(activityItems: [note!.body], applicationActivities: [])
        present(ac, animated: true)
    }
    
    @objc func presentImageOptions(_ barButton: UIBarButtonItem) {
        
    }
    
    @objc func composeNote(_ barButton: UIBarButtonItem) {
        
        
        let newNoteView = ComposeNoteController(note: nil, allNotes: allNotes)
        
        newNoteView.delegate = delegate
        
        
        navigationController?.pushViewController(newNoteView, animated: true)
    }
    
    // a Notification contains name of notification and dictionary
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        textView.verticalScrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        
        textView.scrollRangeToVisible(selectedRange)
        
    }
    
    @objc func showOptions() {
        if (navigationItem.rightBarButtonItems?.count != 2) {
            navigationItem.rightBarButtonItems?.remove(at: 0)
        }
    }
    
    @objc func showEditingOptions() {
        
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(finishEditing))
        if navigationItem.rightBarButtonItems?.count == 2 {
            navigationItem.rightBarButtonItems?.insert(done, at: 0)
        }
    }
    
    @objc func finishEditing(_ button: UIBarButtonItem) {
        // dismiss keyboard
        textView.resignFirstResponder() // resign object that is currently receiving user input
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
    func composeNoteControllerDidLoad(allNotes: [[Note]])
}
