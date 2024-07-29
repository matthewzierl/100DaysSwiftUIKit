//
//  ViewController.swift
//  Project12
//
//  Created by Matthew Zierl on 7/29/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let defaults = UserDefaults.standard
        
        defaults.set(25, forKey: "Age")
        defaults.set(true, forKey: "UseFaceID")
        defaults.set(CGFloat.pi, forKey: "Pi")
        defaults.set("Matthew Zierl", forKey: "Name")
        defaults.set(Date(), forKey: "LastAccess")
        
        let array = ["Hello", "Wordl"]
        defaults.set(array, forKey: "SavedArray")
        
        let dict = ["Name":"Matthew Zierl", "Country":"America"]
        defaults.set(dict, forKey: "SavedDictionary")
        
        
        // now try loading
        
        let savedInt = defaults.integer(forKey: "Age")
        let savedBoolean = defaults.bool(forKey: "UseFaceID")
        let savedDate = defaults.object(forKey: "LastAccess") as? Date ?? Date()
        let savedArray = defaults.array(forKey: "SavedArray") as? [String] ?? [String]()
        let savedDictionary = defaults.dictionary(forKey: "SavedDictionary") as? [String:String] ?? [String:String]()
    }


}

