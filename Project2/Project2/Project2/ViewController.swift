//
//  ViewController.swift
//  Project2
//
//  Created by Matthew Zierl on 6/29/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var highScore = 0
    var correctAnswer = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        if let navigationBar = self.navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black] // Change the color as needed
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }

        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria",
                      "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 2
        button2.layer.borderWidth = 2
        button3.layer.borderWidth = 2
        
        
        
        button1.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button2.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button3.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        
        button1.layer.borderColor = UIColor.black.cgColor
        button2.layer.borderColor = UIColor.black.cgColor
        button3.layer.borderColor = UIColor.black.cgColor
        
        
        
        askQuestion()
        
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle() // shuffle countries array in place
        correctAnswer = Int.random(in: 0...2)
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        self.title = countries[correctAnswer].uppercased() + " [\(score):\(highScore)]"
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        if (sender.tag == correctAnswer) {
            title = "correct!"
            score += 1
            let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion)) // adds 'continue' button to alert and calls handler when pressed
            present(ac, animated: true)
        } else {
            title = "wrong..."
            let ac = UIAlertController(title: "Incorrect", message: "You Chose: \n\(countries[sender.tag])\nFinal Score: \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: askQuestion))
            present(ac, animated: true)
            score = 0
        }
        if score > highScore {
            highScore = score
        }
    }
    
}

