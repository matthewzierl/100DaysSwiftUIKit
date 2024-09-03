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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped)) // '.acton' is a system item (symbol) that is shown
        // 'target' where the shareTapped method will exist (in this class)
        // 'action' when tapped, call a method called shareTapped
        // '#selector' always requires a '@objc' method
        
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
    
    @objc func shareTapped() { // 'objc' for this method, compile it for swift use BUT also make visible to objc code like UIBarButtonItem
        
//        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
//            print("no image found")
//            return
//        }
        
        guard let imageContent = imageView.image else {
            fatalError("Couldn't pull image from imageView")
        }
        
        let renderer = UIGraphicsImageRenderer(size: imageContent.size)
        
        let image = renderer.image { context in
            
            // draw original image
            imageContent.draw(in: CGRect(origin: .zero, size: imageContent.size))
            
            // draw text
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 64),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: CGColor(red: 1, green: 0, blue: 0, alpha: 1)
            ]
            
            let message = "COOL\nTATTOOS\n.COM"
            
            let attributedString = NSAttributedString(string: message, attributes: attrs)
            attributedString.draw(with: CGRect(x: 300, y: 500, width: 500, height: 500), options: .usesLineFragmentOrigin, context: nil)
        }
        
        
        
        
        let vc = UIActivityViewController(activityItems: [image, selectedImage ?? ""], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
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
