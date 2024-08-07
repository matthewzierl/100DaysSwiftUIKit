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
    var highScore = 0 {
        didSet {
            save()
        }
    }
    var correctAnswer = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "highScore") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                highScore = try jsonDecoder.decode(Int.self, from: savedData)
            } catch {
                print("Failed to load highScore")
            }
        }
        
        self.view.backgroundColor = .white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(checkScore))
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
        
        
        
//        button1.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
//        button2.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
//        button3.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        
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
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { finished in
            UIView.animate(withDuration: 1) {
                sender.transform = .identity
            }
        }

        
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
    
    @objc func checkScore() {
        let ac = UIAlertController(title: "Score:", message: "\(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "cancel", style: .default))
        present(ac, animated: true)
    }
    
    func save() {
        
        let jsonEncoder = JSONEncoder() // use JSONEncoder to encode people array
        
        if let savedData = try? jsonEncoder.encode(highScore) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "highScore") // save to user defaults with key 'people'
        } else {
            print("Failed to save data")
        }
    }
    
}

