//
//  DetailViewController.swift
//  Project4
//
//  Created by Matthew Zierl on 6/30/24.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let imageName = imageName else {
            return
        }
        self.navigationItem.title = "picture: \(imageName)"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePhoto))
        self.navigationController?.navigationBar.prefersLargeTitles = false
        imageView.image = UIImage(named: imageName)
    }
    
    @objc func sharePhoto() {
        
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        let ac = UIActivityViewController(activityItems: [image, "check out this sick tattoo!!"], applicationActivities: [])
        ac.popoverPresentationController?.sourceItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
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
