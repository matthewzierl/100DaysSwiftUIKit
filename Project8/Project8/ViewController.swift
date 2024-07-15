//
//  ViewController.swift
//  Project8
//
//  Created by Matthew Zierl on 7/11/24.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var numSolved = 0
    var level = 1
    
    
    override func loadView() {
        view = UIView() // parent of view, buttons, labels, etc.
        view.backgroundColor = .white
        
        // more code to come!
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "Clues"
        cluesLabel.numberOfLines = 0 // '0' is special value, = as many lines as needed
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical) // allow vertical height to be adjusted
        view.addSubview(cluesLabel)
        
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "Answers"
        answersLabel.textAlignment = .right
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false // stops users from taping/typing in box
        view.addSubview(currentAnswer)
        
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 2
        buttonsView.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        view.addSubview(buttonsView)
        
        
        
        
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(
                equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(
                equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.leadingAnchor,
                constant: 100),
            cluesLabel.widthAnchor.constraint(
                equalTo: view.layoutMarginsGuide.widthAnchor,
                multiplier: 0.6,
                constant: -100),
            
            answersLabel.topAnchor.constraint(
                equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.trailingAnchor,
                constant: -100),
            answersLabel.widthAnchor.constraint(
                equalTo: view.layoutMarginsGuide.widthAnchor,
                multiplier: 0.4,
                constant: -100),
            answersLabel.heightAnchor.constraint(
                equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: 0.5),
            currentAnswer.topAnchor.constraint(
                equalTo: cluesLabel.bottomAnchor, 
                constant: 20),
            
            submit.topAnchor.constraint(
                equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(
                equalTo: view.centerXAnchor, 
                constant: -100),
            submit.heightAnchor.constraint(
                equalToConstant: 44),
            
            clear.centerXAnchor.constraint(
                equalTo: view.centerXAnchor,
                constant: 100),
            clear.centerYAnchor.constraint(
                equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(
                equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(
                equalToConstant: 750),
            buttonsView.heightAnchor.constraint(
                equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(
                equalTo: submit.bottomAnchor,
                constant: 20),
            buttonsView.bottomAnchor.constraint(
                equalTo: view.layoutMarginsGuide.bottomAnchor,
                constant: -20)
            
        ])
        
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton) // add to wrapped view
                
                letterButtons.append(letterButton) // add to array of buttons
            }
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel()
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }
        
        
        if let solutionPosition = solutions.firstIndex(of: answerText) { // They provided a correct answer
            activatedButtons.removeAll()
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n") // split into array
            
            splitAnswers?[solutionPosition] = answerText // replace index with correct answer
            
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            numSolved += 1
            if (numSolved % 7 == 0) {
                let ac = UIAlertController(title: "Well done", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        } else {
            score -= 1
            let ac = UIAlertController(title: "Incorrect", message: "You provided an incorrect answer (Score -1). Please try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Acknowledge", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        
        currentAnswer.text = ""
        for button in activatedButtons {
            button.isHidden = false
        }
        activatedButtons.removeAll()
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        numSolved = 0
        
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        
        for button in letterButtons {
            button.isHidden = false
        }
    }
    
    func loadLevel() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            var clueString = ""
            var solutionString = ""
            var letterBits = [String]()
            
            guard let level = self?.level else {return}
            
            if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
                if let levelContents = try? String(contentsOf: levelFileURL) {
                    var lines = levelContents.components(separatedBy: "\n") // split into lines
                    lines.shuffle() // randomize order
                    /*
                        EXAMPLE of line we need to extract info from:
                     
                            HA|UNT|ED: Ghosts in residence
                     
                        Step 1: seperate by colon ': '
                        Step 2:
                     */
                    for (index, line) in lines.enumerated() {
                        let parts = line.components(separatedBy: ": ")
                        let answer = parts[0]
                        let clue = parts[1]
                        
                        clueString += "\(index + 1). \(clue)\n"
                        
                        let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                        solutionString += "\(solutionWord.count) letters\n"
                        self?.solutions.append(solutionWord)
                        
                        let bits = answer.components(separatedBy: "|")
                        letterBits += bits
                    }
                }
            }
            DispatchQueue.main.async {
                self?.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
                self?.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
                
                self?.letterButtons.shuffle() // buttons already in view, shuffling to change order and apply new title
                
                if self?.letterButtons.count == letterBits.count {
                    guard let count = self?.letterButtons.count else {return}
                    for i in 0 ..< count {
                        self?.letterButtons[i].setTitle(letterBits[i], for: .normal)
                    }
                }
            }
        }
        
    }


}

