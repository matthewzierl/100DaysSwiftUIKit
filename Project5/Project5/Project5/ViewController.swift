//
//  ViewController.swift
//  Project5
//
//  Created by Matthew Zierl on 7/3/24.
//

import UIKit

class ViewController: UITableViewController {
    
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
    
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWord))
        
        startGame()
    }
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData() // tableView member give nfrom UITableViewController, reloadData reloads all sections/rows
    }
    
    @objc func addWord() {
        let ac = UIAlertController(title: "Enter answer:", message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submitWord(answer)
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = usedWords[indexPath.row]
        cell.contentConfiguration = configuration
        
        return cell
    }
    
    func submitWord(_ word: String) {
        let lowerAnswer = word.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(word, at: 0) // insert at head
                    // after this point, could just call tableView.reloadData(), but it is ineffecient and we want an animation to
                    // show that user added a word
                    
                    let indexPath = IndexPath(row: 0, section: 0) // 'row: 0' should reflect where we just added a word
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    return
                } else {
                    errorTitle = "Word not recognized"
                    errorMessage = "u cant just make them up u know..."
                }
            } else {
                errorTitle = "Word already used"
                errorMessage = "pick another word..."
            }
        } else {
            errorTitle = "Please provide a valid anagram"
            errorMessage = "You cant spell that word from \(title!.lowercased())"
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Acknowledge", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    /*
     The word is actually an anagram of the original word
     */
    func isPossible(word: String) -> Bool {
        guard var tempAnswer = title?.lowercased() else {return false}
        for letter in word {
            if let position = tempAnswer.firstIndex(of: letter) {
                tempAnswer.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    /*
     The word is not already present in usedWords array
     */
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word) // true if usedWords doesn't contain word
    }
    
    /*
     The word exists
     */
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let mispelledRanged = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return mispelledRanged.location == NSNotFound
    }
    


}

