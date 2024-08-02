//
//  InterestViewController.swift
//  Project10-12Milestone
//
//  Created by Matthew Zierl on 8/2/24.
//

import UIKit

class InterestViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!
    
    var imagePath: URL?
    var imageDescription: String?
    var interest: String?
    
    weak var delegate: InterestViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let imagePath = imagePath, let imageDescription = imageDescription else {
            return
        }
        
        navigationItem.title = interest
        imageView.image = UIImage(contentsOfFile: imagePath.path)
        textView.text = imageDescription
        textView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = 7
        textView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        textView.textColor = .black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Notify the delegate with the updated description
        delegate?.didUpdateInterestDescription(self, description: textView.text)
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

protocol InterestViewControllerDelegate: AnyObject {
    func didUpdateInterestDescription(_ viewController: InterestViewController, description: String)
}

