//
//  ViewController.swift
//  Project28
//
//  Created by Matthew Zierl on 9/5/24.
//

import LocalAuthentication // touchID faceID
import UIKit

class ViewController: UIViewController {
    @IBOutlet var secret: UITextView!
    
    let password = "123"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Nothing to see here..."
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        
        // First try password
        let ac = UIAlertController(title: "Enter Password", message: nil, preferredStyle: .alert)
        ac.addTextField { field in
            field.placeholder = "password"
        }
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self] action in
            
            let input = ac.textFields?[0].text ?? ""
            if input == self?.password {
                // unlock the message
                self?.unlockSecretMessage()
            } else {
                // prompt user if they want to try biometrics
                
                let ac = UIAlertController(title: "Incorrect Password.", message: "Try Biometric Login?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    self?.initiateBiometricLogin()
                }))
                ac.addAction(UIAlertAction(title: "No", style: .cancel))
                self?.present(ac, animated: true)
            }
        }))
        
        present(ac, animated: true)
    }
    
    func initiateBiometricLogin() {
        let context = LAContext()
        var error: NSError?
        
        // can we use biometric info?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify Yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        // error
                        let ac = UIAlertController(title: "Authentication Failed", message: "You could not be verified. Please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Okay", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // no biometry
            let ac = UIAlertController(title: "Biometry Unavailable", message: "Your device is not configured for biometrix authentication", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret Stuff!"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(saveSecretMessage))
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
        
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return } // make sure secret is visible
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        navigationItem.rightBarButtonItem = nil
        
        title = "Nothing to see here..."
    }
    
    
}

