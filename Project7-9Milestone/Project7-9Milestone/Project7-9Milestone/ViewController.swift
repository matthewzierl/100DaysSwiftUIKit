//
//  ViewController.swift
//  Project7-9Milestone
//
//  Created by Matthew Zierl on 7/16/24.
//

import UIKit

class ViewController: UIViewController {
    
    let hangmanStages = [
    """
       +----+
       |
       |
       |
       |
       |
    ===========
    """,
    """
       +----+
       |         |
       |         O
       |
       |
       |
    ===========
    """,
    """
       +----+
       |         |
       |        O
       |
       |
       |
    ===========
    """,
    """
       +----+
       |         |
       |        O
       |         |
       |
       |
    ===========
    """,
    """
       +----+
       |         |
       |        O
       |       / |
       |
       |
    ===========
    """,
    """
       +----+
       |         |
       |        O
       |       / | \\ \\
       |
       |
    ===========
    """,
    """
       +----+
       |         |
       |        O
       |       / | \\ \\
       |       /   \\
       |
    ===========
    """,
    """
       +----+
       |         |  GAME OVER.
       |        O
       |       / | \\ \\
       |       /   \\ \\
       |
    ===========
    """,
    ]
    
    var wordLabel: UILabel!
    var hangmanLabel: UILabel!
    var usedLetters: UILabel!
    var providedAnswer: UITextField!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var buttonsView: UIView!
    var urlString: String? = nil
    var wordBank = [String]()
    var index = 0 // index for wordbank
    var currentWord: String = "Loading word..."
    var currentStage = 0
    
    
    override func loadView() {
        
        view = UIView() // parent of view, buttons, labels, etc.
//        view.backgroundColor = .white
        
        hangmanLabel = UILabel()
        hangmanLabel.translatesAutoresizingMaskIntoConstraints = false
        hangmanLabel.text = hangmanStages[currentStage] // always start at 0th stage
        hangmanLabel.numberOfLines = 0
        view.addSubview(hangmanLabel)
        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.font = UIFont.systemFont(ofSize: 36)
        wordLabel.text = "Loading word..."
        view.addSubview(wordLabel)
        
        usedLetters = UILabel()
        usedLetters.translatesAutoresizingMaskIntoConstraints = false
        usedLetters.text = ""
        usedLetters.numberOfLines = 0
        view.addSubview(usedLetters)
        
        providedAnswer = UITextField()
        providedAnswer.translatesAutoresizingMaskIntoConstraints = false
        providedAnswer.placeholder = "Make a guess..."
        providedAnswer.borderStyle = .roundedRect
        view.addSubview(providedAnswer)
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(buttonsView)
        
        
        NSLayoutConstraint.activate([
            
            hangmanLabel.topAnchor.constraint(
                equalTo: view.layoutMarginsGuide.topAnchor),
            hangmanLabel.leadingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.leadingAnchor,
                constant: 50),
            hangmanLabel.widthAnchor.constraint(
                equalTo: view.layoutMarginsGuide.widthAnchor,
                multiplier: 0.4),
            
            usedLetters.topAnchor.constraint(
                equalTo: view.layoutMarginsGuide.topAnchor),
            usedLetters.trailingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.trailingAnchor,
                constant: -50),
            usedLetters.widthAnchor.constraint(
                equalTo: view.layoutMarginsGuide.widthAnchor,
                multiplier: 0.4),
            usedLetters.heightAnchor.constraint(
                equalTo: hangmanLabel.heightAnchor),
            
            wordLabel.topAnchor.constraint(
                equalTo: hangmanLabel.bottomAnchor,
                constant: 10),
            wordLabel.centerXAnchor.constraint(
                equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            providedAnswer.topAnchor.constraint(
                equalTo: wordLabel.bottomAnchor,
                constant: 10),
            providedAnswer.centerXAnchor.constraint(
                equalTo: wordLabel.centerXAnchor),
            
            buttonsView.topAnchor.constraint(
                equalTo: providedAnswer.bottomAnchor,
                constant: 10),
            buttonsView.widthAnchor.constraint(
                equalTo: view.layoutMarginsGuide.widthAnchor,
                constant: 0.95),
            buttonsView.centerXAnchor.constraint(
                equalTo: providedAnswer.centerXAnchor),
            buttonsView.bottomAnchor.constraint(
                equalTo: view.layoutMarginsGuide.bottomAnchor),
            
        ])
        
        for letter in "ABCDEFGHIJKLMNOPQRSTUVWXYZ" { // Create buttons
            let letterButton = UIButton()
            letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
            letterButton.titleLabel?.textColor = .blue
            letterButton.setTitle(String(letter), for: .normal)
//            letterButton.setTitleShadowColor(.black, for: .normal)
            letterButton.backgroundColor = UIColor(white: 0.9, alpha: 1)
            letterButton.layer.cornerRadius = 5
            letterButton.layer.borderWidth = 1
            letterButton.layer.borderColor = UIColor.black.cgColor
            letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            letterButtons.append(letterButton)
            buttonsView.addSubview(letterButton)
        }
        
        
        
        
//        hangmanLabel.backgroundColor = .red
//        usedLetters.backgroundColor = .blue
//        buttonsView.layer.backgroundColor = CGColor(red: 0, green: 1, blue: 0, alpha: 1)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadGame()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let buttonWidth: CGFloat = 70
        let buttonHeight: CGFloat = 35
        let padding: CGFloat = 5
        
        let MAX_COLUMNS = Int(buttonsView.frame.width / buttonWidth)
        let MAX_ROWS = Int(ceil(Double(letterButtons.count) / Double(MAX_COLUMNS))) // guarantee 26 letters
        
//        print(MAX_ROWS)
//        print(MAX_COLUMNS)
        
        // Remove existing constraints
        buttonsView.subviews.forEach { $0.removeFromSuperview() }
        
        var row = 0
        var column = 0
        
        for button in letterButtons {
            
            
            if column >= MAX_COLUMNS {
                column = 0
                row += 1
            }
            
            if row >= MAX_ROWS {
                break
            }
            
            if button.superview != buttonsView {
                buttonsView.addSubview(button)
            }
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: buttonWidth - padding),
                button.heightAnchor.constraint(equalToConstant: buttonHeight - padding),
                button.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor, constant: CGFloat(column) * buttonWidth + padding),
                button.topAnchor.constraint(equalTo: buttonsView.topAnchor, constant: CGFloat(row) * buttonHeight + padding)
            ])
            
            column += 1
        }
    }
    
    func loadGame() {
        let urlString = "https://raw.githubusercontent.com/MichaelWehar/Public-Domain-Word-Lists/master/5000-more-common.txt"
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let url = URL(string: urlString) else {
                self?.showError()
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                if let contents = String(data: data, encoding: .utf8) {
                    var words = contents
                        .components(separatedBy: .newlines)
                        .filter { !$0.isEmpty }
                        .map { $0.uppercased() } // Convert each word to uppercase
                    
                    
                    words.shuffle()
                    
                    self?.wordBank = words
                    
                    DispatchQueue.main.async {
                        self?.startGame(with: words)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.showError()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self?.showError()
                }
            }
        }
    }
    
    func startGame(with wordBank: [String]) {
        // Resetting game
        print(wordBank.count)
        currentWord = wordBank[index]
        currentStage = 0
        hangmanLabel.text = hangmanStages[currentStage]
        usedLetters.text = ""
        print(currentWord)
        wordLabel.text = currentWord.map { _ in "_" }.joined(separator: " ")
        for button in letterButtons {
            button.isHidden = false
        }
        // End of resetting game
    }
    
    
    func showError() {
        let ac = UIAlertController(title: "Problem loading words", message: "Please restart", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Acknowledge", style: .default))
        present(ac, animated: true)
    }

    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text, buttonTitle.count == 1 else {
            return
        }
        
        let selection = Character(buttonTitle)
        
        if currentWord.contains(selection) {
            updateDisplayedWord(with: selection)
        } else {
            currentStage += 1
            usedLetters.text?.append("\(selection) ")
            hangmanLabel.text? = hangmanStages[currentStage]
        }
        
        sender.isHidden = true
        
        checkProgress()
        
    }
    
    func updateDisplayedWord(with character: Character) {
        var updatedWord = Array(wordLabel.text ?? "")
        let currentWordArray = Array(currentWord)
        
        for (index, char) in currentWordArray.enumerated() {
            if char == character {
                updatedWord[index * 2] = character // Multiply by 2 to account for spaces
            }
        }
        
        wordLabel.text = String(updatedWord)
    }
    
    /*
        Check if current wordLable contains '-'
        Check if currentStage is equal to the last stage, then end game
     */
    func checkProgress() {
        let currentProgress = wordLabel.text ?? "_"
        if currentProgress.contains("_") {
            if (currentStage == 7) {
                let ac = UIAlertController(title: "You Failed", message: "You coundn't guess the word", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Try again", style: .default))
                present(ac, animated: true)
                index += 1
                startGame(with: wordBank)
            }
            return
        }
        
        let ac = UIAlertController(title: "YOU WON!!", message: "You guessed the word correctly", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Try again", style: .default))
        present(ac, animated: true)
        
        
        index += 1
        startGame(with: wordBank)
    }



}

