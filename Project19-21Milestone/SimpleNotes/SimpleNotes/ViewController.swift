//
//  ViewController.swift
//  SimpleNotes
//
//  Created by Matthew Zierl on 8/14/24.
//

import UIKit

class ViewController: UITableViewController, ComposeNoteControllerDelegate {
    
    var allNotes = [[Note]]()
    
    

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // only want to refresh when needing to present it
        sortNotes()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotes[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let note = allNotes[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        var configuration = cell.defaultContentConfiguration()

        configuration.text = note.title
        
        cell.contentConfiguration = configuration
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let note = allNotes[indexPath.section][indexPath.row]
        
        let newNoteView = ComposeNoteController(note: note, allNotes: allNotes)
        newNoteView.delegate = self
        
        navigationController?.pushViewController(newNoteView, animated: true)
    }
    
    /*
        Provide number of sections
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allNotes.count
    }
    
    /*
        
     */
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.frame.width, height: 40))
        label.font = UIFont(name: "Kailasa-Bold", size: 20)
        label.text = allNotes[section][0].key
        
        view.addSubview(label)
        
        return view
    }
    
    // trailing action
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        // action: action itself you are configuring
        // view: object on which action is being performed. Probably the UITableViewCell
        // completionHandler: the handler that must be called when you are finished, so you can dismiss swipe actions
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completionHandler in
            self?.allNotes[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if (self?.allNotes[indexPath.section].count == 0) {
                self?.allNotes.remove(at: indexPath.section)
                tableView.deleteSections([indexPath.section], with: .fade)
            }
            completionHandler(true) // signals to system you are finished deleting, dismissing swip actions
        }
        
        let shareAction = UIContextualAction(style: .normal, title: "Share") { [weak self] action, view, completionHandler in
            
            guard let note = self?.allNotes[indexPath.section][indexPath.row] else {
                completionHandler(false)
                return
            }
            let vc = UIActivityViewController(activityItems: [note.body], applicationActivities: nil)
            self?.present(vc, animated: true)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        shareAction.backgroundColor = .systemBlue
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
        
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        
//        // need to find index of note in allNotes array
//        
//        if editingStyle == .delete {
//            allNotes[indexPath.section].remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
    
    func sortNotes() {
        
        var flatArray = allNotes.flatMap { $0 }
        
        flatArray.sort { note1, note2 in
            note1.dateModified > note2.dateModified
        }
        
        var newAllNotes = [[Note]]()
        var currentArray = [Note]()
        
        for note in flatArray {
            
            if let firstNote = currentArray.first {
                if note.key == firstNote.key {
                    currentArray.append(note)
                } else {
                    newAllNotes.append(currentArray)
                    currentArray = [Note]()
                    currentArray.append(note)
                }
            } else {
                currentArray.append(note)
            }
        }
        
        if !currentArray.isEmpty {
            newAllNotes.append(currentArray)
        }
        
        allNotes = newAllNotes
        
    }
    
    
    @objc func presentSortOptions(_ barButton: UIBarButtonItem) {
        
    }
    
    @objc func composeNote(_ barButton: UIBarButtonItem) {
        
        let newNoteView = ComposeNoteController(note: nil, allNotes: allNotes)
        newNoteView.delegate = self
        
        navigationController?.pushViewController(newNoteView, animated: true)
    }
    
    func composeNoteControllerDidLoad(allNotes: [[Note]]) {
        self.allNotes = allNotes
    }


}

