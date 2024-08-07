//
//  ViewController.swift
//  Project15
//
//  Created by Matthew Zierl on 8/7/24.
//

import UIKit

class ViewController: UIViewController {
    
    var imageView: UIImageView!
    var currentAnimation = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 215, y: 384)
        view.addSubview(imageView)
    }

    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true
        
        // start animation block
        // no caputre list for animation because there is no chance of strong reference cycles
        // closures passed to animate will be used once then thrown away
//        UIView.animate(withDuration: 1, delay: 0, options: []) { // ease in/out by default
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) { // spring animation (over shoot / under shoot)
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                break
            case 1:
                self.imageView.transform = .identity // return
                break
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -150, y: -300) // move image by amount
                break
            case 3:
                self.imageView.transform = .identity
                break
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
                break
            case 5:
                self.imageView.transform = .identity
                break
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = .green
                break
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = .clear
            default:
                break
            }
        } completion: { finished in
            sender.isHidden = false
        }

        
        
        
        
        currentAnimation += 1
        if (currentAnimation > 7) {
            currentAnimation = 0
        }
    }
    
}

