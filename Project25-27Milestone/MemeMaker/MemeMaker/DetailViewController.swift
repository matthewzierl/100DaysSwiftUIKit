//
//  DetailViewController.swift
//  MemeMaker
//
//  Created by Matthew Zierl on 9/4/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    var meme: Meme!
    var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageView = UIImageView()
        imageView.image = meme.image
        
        view = imageView
        
        navigationItem.title = meme.title
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
