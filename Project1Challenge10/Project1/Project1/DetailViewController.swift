//
//  DetailViewController.swift
//  Project1
//
//  Created by Matthew Zierl on 6/28/24.
//

import UIKit

class DetailViewController: UIViewController {
    
        // Do any additional setup after loading the view.
        @IBOutlet var imageView: UIImageView! // I control dragged Image View from Detail View Controller in the storyboard to here
        // @IBOutlet is only for interface builder
        var selectedImage: String?
        var totalImages: Int?
        var currentImageIndex: Int?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            guard let totalImages = totalImages, let currentImageIndex = currentImageIndex else {
                return
            }
            
            self.title = "\(currentImageIndex + 1)/\(totalImages)" // both are optional, so don't need to unwrap
            self.navigationItem.largeTitleDisplayMode = .never // 'navigationItem' is configuration JUST for this screen
            
            if let imageToLoad = selectedImage {
                imageView.image  = UIImage(named: imageToLoad) // UIImageView has field image: UIImage that takes string name to find file in app's bundle
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.hidesBarsOnTap = true // the navigation controller this view may or may not have been pushed on
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            self.navigationController?.hidesBarsOnTap = false // the navigation controller this view may or may not have been pushed on
        }
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
}
