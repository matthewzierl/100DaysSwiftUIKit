//
//  ActionViewController.swift
//  Extension
//
//  Created by Matthew Zierl on 8/10/24.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
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
                    
                    
                }
            }
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
