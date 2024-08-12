//
//  ActionViewController.swift
//  Extension
//
//  Created by Matthew Zierl on 8/10/24.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var script: UITextView!
    
    var pageTitle: String = ""
    var pageURL: String = ""
    
    let upperCaseScript = "document.body.style.textTransform = \"uppercase\";"
    let highlightLinksScript = "var links = document.querySelectorAll('a'); links.forEach(function(link) { link.style.backgroundColor = 'yellow'; });"
    let currentURLScript = "alert(\"Current URL: \" + window.location.href);"
    let backgroundColorScript = "document.body.style.backgroundColor = \"lightblue\";"
    let hideImagesScript = "document.querySelectorAll('img'); images.forEach(function(img) { img.remove(); });"
    
    var savedProgress = [String: String]()
    var typingTimer: Timer?
    
    var savedScripts = [String: String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        script.delegate = self
        
        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveScript))
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(listScripts))
        
        navigationItem.rightBarButtonItems = [done, save]
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let defaults = UserDefaults.standard
        
        savedProgress = defaults.object(forKey: "savedProgress") as? [String: String] ?? [String: String]()
        
        savedScripts = defaults.object(forKey: "savedScripts") as? [String: String] ?? [String: String]()
        
    
        // Get the item[s] we're handling from the extension context.
        
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem { 
            
            // inputItems is array of data parent is sending to extension to use
            // an inputItem contains an array of attachments (array of NSItemProviders)
            // calling loadItem on an inputItem is to actually ask provider for the item using a closure
            // item provider gives us a dictionary and an error that was thrown
            
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: UTType.propertyList.identifier) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async { // closure inside closure, will use same capture list
                        self?.title = self?.pageTitle
                        self?.script.text = self?.savedProgress[self!.pageURL]
                    }
                    
                }
            }
        }
    }
    
    @objc func saveScript(_ sender: UIBarButtonItem) {
        
        let ac = UIAlertController(title: "Save Custom Script", message: "Please provide a name", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] action in
            if let input = ac.textFields?[0].text {
                if input == "" { return } // don't save if they didn't provide a name
                self?.savedScripts[input] = self?.script.text
                
                let userDefault = UserDefaults.standard
                userDefault.set(self?.savedScripts, forKey: "savedScripts")
            }
        }))
        present(ac, animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(saveProgress), userInfo: nil, repeats: false)
    }
    
    @objc func listScripts(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Scripts", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Upper Case", style: .default, handler: { [weak self] action in
            self?.script.text = self?.upperCaseScript
        }))
        ac.addAction(UIAlertAction(title: "Highlight Links", style: .default, handler: { [weak self] action in
            self?.script.text = self?.highlightLinksScript
        }))
        ac.addAction(UIAlertAction(title: "Current URL", style: .default, handler: { [weak self] action in
            self?.script.text = self?.currentURLScript
        }))
        ac.addAction(UIAlertAction(title: "Change Background Color", style: .default, handler: { [weak self] action in
            self?.script.text = self?.backgroundColorScript
        }))
        ac.addAction(UIAlertAction(title: "Hide Images", style: .default, handler: { [weak self] action in
            self?.script.text = self?.hideImagesScript
        }))
        for (key, value) in savedScripts {
            ac.addAction(UIAlertAction(title: key, style: .default, handler: { [weak self] action in
                self?.script.text = value
            }))
        }
        present(ac, animated: true)
    }

    
    @IBAction func done() {
        let item = NSExtensionItem()
        
        let argument: NSDictionary = ["customJavascript": script.text] // Make dictionary with 'customJavascript' as key and text as value
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument] // Create another dictionary with javascriptFinalize as key, and previous dictionary as value
        let customJavascript = NSItemProvider(item: webDictionary, typeIdentifier: UTType.propertyList.identifier) // convert that dictionary to NSItemProvider so to convey data between host app and extension
        item.attachments = [customJavascript]
        extensionContext?.completeRequest(returningItems: [item]) // completes request and returns to host app
    }
    
    // a Notification contains name of notification and dictionary
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        script.verticalScrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        
        script.scrollRangeToVisible(selectedRange)
        
    }
    
    @objc func saveProgress() {
        print("User stopped typing for 3 seconds")
        let defaults = UserDefaults.standard
        savedProgress[pageURL] = script.text ?? ""
        defaults.setValue(savedProgress, forKey: "savedProgress")
    }

}
