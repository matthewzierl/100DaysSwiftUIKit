//
//  ViewController.swift
//  SimpleNotes
//
//  Created by Matthew Zierl on 8/14/24.
//

import UIKit

class ViewController: UITableViewController, ComposeNoteControllerDelegate {
    
    var allNotes = [Note]()
    
    var notesSectionCount = [String: Int]()
    var notesSectionDates = [String]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
        navigationItem.title = "Notes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(presentSortOptions))
        
        // create tool bar
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let numNotes = UIBarButtonItem(title: "\(allNotes.count) Notes", style: .plain, target: nil, action: nil)
        let compose = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(composeNote))
        
        toolbarItems = [flexibleSpace, numNotes, flexibleSpace, compose]
        
        navigationController?.setToolbarHidden(false, animated: true)
        
        // TODO: Load from user default config
        
        // END
        
        
        sortNotes() // Sort notes
        splitNotesIntoSections() // Split into grouped sections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("in number of rows in section, outputing: \(notesSectionCount[notesSectionDates[section]] ?? 0)")
        return notesSectionCount[notesSectionDates[section]] ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let sectionKey = notesSectionDates[indexPath.section]
        
        
        let sectionNotes = allNotes.filter { note in
            let calendar = Calendar.current
            let components = calendar.dateComponents([.month, .year], from: note.dateModified)
            if let month = components.month, let year = components.year {
                let key = "\(getNameMonth(month: month)) \(year)"
                return key == sectionKey
            }
            return false
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        var configuration = cell.defaultContentConfiguration()

        configuration.text = sectionNotes[indexPath.row].title
        
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
        return notesSectionCount.count
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
    
    func sortNotes() {
        allNotes.sort { note1, note2 in
            note1.dateModified > note2.dateModified
        }
        for index in allNotes.indices {
            allNotes[index].index = index
        }
    }
    
    func splitNotesIntoSections() {
    
        let calendar = Calendar.current
        
        var newNoteSectionsCount = [String: Int]()
        var newSectionDates = [String]()
        
        for note in allNotes {
            let components = calendar.dateComponents([.month, .year], from: note.dateModified) // for now, sorting by modified
            if let month = components.month, let year = components.year {
                let key = "\(getNameMonth(month: month)) \(year)"
                if let numNotesInSection = newNoteSectionsCount[key] {
                    newNoteSectionsCount[key] = numNotesInSection + 1
                } else {
                    newNoteSectionsCount[key] = 1
                    newSectionDates.append(key) // new key, new entry
                }
                
            }
        }
        
        notesSectionCount = newNoteSectionsCount
        notesSectionDates = newSectionDates
    }
    
    @objc func presentSortOptions(_ barButton: UIBarButtonItem) {
        
    }
    
    @objc func composeNote(_ barButton: UIBarButtonItem) {
        let newNoteView = ComposeNoteController()
        let newNote = Note() // index will be assigned later
        allNotes.append(newNote)
        
//        DispatchQueue.main.async { [weak self] in
//            self?.sortNotes()
//            self?.splitNotesIntoSections()
//        }
        sortNotes()
        splitNotesIntoSections()
        
        newNoteView.note = newNote
        newNoteView.allNotes = allNotes
        newNoteView.delegate = self
        navigationController?.pushViewController(newNoteView, animated: true)
    }
    
    func removedFromNavigationStack(allNotes: [Note]) {
        self.allNotes = allNotes
        print("View removed from navigation stack, sorting notes (\(allNotes.count)) now")
        sortNotes()
        splitNotesIntoSections()
        tableView.reloadData()
    }

    func getNameMonth(month: Int) -> String {
        switch month {
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        default:
            return "Uknown"
        }
    }


}

