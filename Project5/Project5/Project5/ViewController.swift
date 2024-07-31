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
    var usedWordsLowercased = [String]()
    var currentWord: String = ""
    var running = false

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
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshGame))
        
        startGame()
    }
    
    func startGame() {
        if running { // refresh game normally
            currentWord = allWords.randomElement() ?? ""
            title = currentWord
            usedWords.removeAll(keepingCapacity: true)
        } else { // load from user data
            let defaults = UserDefaults.standard
            if let savedWordData = defaults.object(forKey: "currentWord") as? Data {
                let jsonDecoder = JSONDecoder()
                
                do {
                    currentWord = try jsonDecoder.decode(String.self, from: savedWordData)
                    title = currentWord
                } catch {
                    print("Unable to load previous word")
                }
            }
            if let savedUsedWordData = defaults.object(forKey: "usedWords") as? Data {
                let jsonDecoder = JSONDecoder()
                
                do {
                    usedWords = try jsonDecoder.decode([String].self, from: savedUsedWordData)
                } catch {
                    print("Unable to load previous used words")
                }
            }
            if let savedUsedWordDataLower = defaults.object(forKey: "usedWordsLowercased") as? Data {
                let jsonDecoder = JSONDecoder()
                
                do {
                    usedWordsLowercased = try jsonDecoder.decode([String].self, from: savedUsedWordDataLower)
                } catch {
                    print("Unable to load previous used words lowercased")
                }
            }
        }
        save()
        tableView.reloadData() // tableView member give nfrom UITableViewController, reloadData reloads all sections/rows
    }
    
    @objc func refreshGame() {
        running = true
        startGame()
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
        
        
        if (lowerAnswer.count > 3) {
            if (lowerAnswer != title?.lowercased()) {
                if isPossible(word: lowerAnswer) {
                    if isOriginal(word: lowerAnswer) {
                        if isReal(word: lowerAnswer) {
                            usedWords.insert(word, at: 0) // insert at head
                            usedWordsLowercased.insert(lowerAnswer, at: 0)
                            save()
                            // after this point, could just call tableView.reloadData(), but it is ineffecient and we want an animation to
                            // show that user added a word
                            
                            let indexPath = IndexPath(row: 0, section: 0) // 'row: 0' should reflect where we just added a word
                            tableView.insertRows(at: [indexPath], with: .automatic)
                            
                            return
                        } else {
                            showErrorMessage(errorTitle: "Word not recognized", errorMessage: "u cant just make them up u know...")
                        }
                    } else {
                        showErrorMessage(errorTitle: "Word already used", errorMessage: "pick another word...")
                    }
                } else {
                    showErrorMessage(errorTitle: "Please provide a valid anagram", errorMessage: "You cant spell that word from \(title!.lowercased())")
                }
            } else {
                showErrorMessage(errorTitle: "You just typed in the same word", errorMessage: "The whole point of the game is to make different words dude")
            }
        } else {
            showErrorMessage(errorTitle: "Answer too short", errorMessage: "Please provide an answer greater than 3 letters in length")
        }
    }
    
    func showErrorMessage(errorTitle: String, errorMessage: String) {
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
        return !usedWordsLowercased.contains(word) // true if usedWords doesn't contain word
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
    
    func save() {
        
        let jsonEncoder = JSONEncoder() // use JSONEncoder to encode people array
        
        if let savedData = try? jsonEncoder.encode(currentWord) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "currentWord") // save to user defaults with key 'people'
        } else {
            print("Failed to save currentWord")
        }
        
        if let savedData = try? jsonEncoder.encode(usedWords) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "usedWords") // save to user defaults with key 'people'
        } else {
            print("Failed to save usedWords")
        }
        
        if let savedData = try? jsonEncoder.encode(usedWordsLowercased) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "usedWordsLowercased") // save to user defaults with key 'people'
        } else {
            print("Failed to save usedWordsLowercased")
        }
    }
    


}

