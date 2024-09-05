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
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // add the view
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                imageView.topAnchor.constraint(equalTo: view.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(shareMeme))
        
        
        navigationItem.title = meme.title
    }
    
    @objc func shareMeme(_ btn: UIBarButtonItem) {
        guard let image = imageView.image else { return }
        let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        ac.popoverPresentationController?.barButtonItem = btn // For iPads
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
