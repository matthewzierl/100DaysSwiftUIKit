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
       |         |
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
    
    
    override func loadView() {
        
        view = UIView() // parent of view, buttons, labels, etc.
        view.backgroundColor = .white
        
        hangmanLabel = UILabel()
        hangmanLabel.translatesAutoresizingMaskIntoConstraints = false
        hangmanLabel.text = hangmanStages[6] // always start at 0th stage
        hangmanLabel.numberOfLines = 0
        view.addSubview(hangmanLabel)
        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.text = "WORD"
        view.addSubview(wordLabel)
        
        usedLetters = UILabel()
        usedLetters.translatesAutoresizingMaskIntoConstraints = false
        usedLetters.text = "USED LETTERS"
        usedLetters.numberOfLines = 0
        view.addSubview(usedLetters)
        
        providedAnswer = UITextField()
        providedAnswer.translatesAutoresizingMaskIntoConstraints = false
        providedAnswer.placeholder = "Make a guess..."
        providedAnswer.borderStyle = .roundedRect
        view.addSubview(providedAnswer)
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 2
        buttonsView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0)
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
                constant: 20),
            wordLabel.centerXAnchor.constraint(
                equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            providedAnswer.topAnchor.constraint(
                equalTo: wordLabel.bottomAnchor,
                constant: 20),
            providedAnswer.centerXAnchor.constraint(
                equalTo: wordLabel.centerXAnchor),
            
            buttonsView.topAnchor.constraint(
                equalTo: providedAnswer.bottomAnchor,
                constant: 20),
            buttonsView.widthAnchor.constraint(
                equalTo: view.layoutMarginsGuide.widthAnchor,
                multiplier: 0.95),
            buttonsView.centerXAnchor.constraint(
                equalTo: providedAnswer.centerXAnchor)
            
        ])
        
        let width = 150
        let height = 80
        
        for letter in "ABCDEFGHIJKLMNOPQRSTUVWXYZ" {
            let letterButton = UIButton()
            letterButton.setTitle(String(letter), for: .normal)
            letterButton.backgroundColor = .clear
            letterButton.layer.cornerRadius = 5
            letterButton.layer.borderWidth = 1
            letterButton.layer.borderColor = UIColor.black.cgColor
            letterButtons.append(letterButton)
        }
        
        hangmanLabel.backgroundColor = .red
        usedLetters.backgroundColor = .blue

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc func letterTapped() {
        
    }


}

