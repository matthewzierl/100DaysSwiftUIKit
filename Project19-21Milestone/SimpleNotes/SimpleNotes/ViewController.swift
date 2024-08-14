//
//  ViewController.swift
//  SimpleNotes
//
//  Created by Matthew Zierl on 8/14/24.
//

import UIKit

class ViewController: UITableViewController {
    
    
    var allNotes = [Note]()
    
    var notesSection = [String: Int]()
    var notesSectionDates = [String]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        navigationItem.title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(presentSortOptions))
        
        // create tool bar
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let compose = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(composeNote))
        
        toolbarItems = [flexibleSpace, compose]
        
        navigationController?.setToolbarHidden(false, animated: true)
        
        // TODO: Load from user default config
        
        // END
        
        // sort loaded notes and update sections
        allNotes.sort { note1, note2 in
            note1.dateModified > note2.dateModified
        }
        splitNotesIntoSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesSection[notesSectionDates[section]] ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = allNotes[indexPath.count].title
        
        cell.contentConfiguration = configuration
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    /*
        Provide number of sections
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return notesSection.count
    }
    
    /*
        
     */
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.width, height: 40))
        label.font = UIFont(name: "Kailasa-Bold", size: 20)
        label.text = notesSectionDates[section]
        
        view.addSubview(label)
        
        return view
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    func splitNotesIntoSections() {
    
        let calendar = Calendar.current
        
        for note in allNotes {
            let components = calendar.dateComponents([.month, .year], from: note.dateModified) // for now, sorting by modified
            if let month = components.month, let year = components.year {
                let key = "\(month) \(year)"
                if let numNotesInSection = notesSection[key] {
                    notesSection[key] = numNotesInSection + 1
                } else {
                    notesSection[key] = 1
                    notesSectionDates.append(key) // new key, new entry
                }
                
            }
        }
    }
    
    @objc func presentSortOptions(_ barButton: UIBarButtonItem) {
        
    }
    
    @objc func composeNote(_ barButton: UIBarButtonItem) {
        let newNoteView = ComposeNoteController()
        navigationController?.pushViewController(newNoteView, animated: true)
    }
    
    
    
    func save() {
        
    }


}

