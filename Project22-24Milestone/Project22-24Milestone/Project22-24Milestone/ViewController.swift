//
//  ViewController.swift
//  Project22-24Milestone
//
//  Created by Matthew Zierl on 8/29/24.
//

import UIKit

class ViewController: UIViewController {
    
    var testView: UIView!
    var testLabel: UILabel!
    var counter = 5 {
        didSet {
            testLabel.text = "\(counter)"
        }
    }
    var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .red
        
        testView = UIView()
        testView.backgroundColor = .systemBlue
        testView.frame.size = view.frame.size
        
        testLabel = UILabel()
        testLabel.text = "\(counter)"
        
        testView.addSubview(testLabel)
        
        view.addSubview(testView)
        
        counter.times {
            print("HELLO")
        }
        
        testView.bounceOut(duration: 10)
    }
    
    


}

extension UIView {
    func bounceOut(duration: Double) {
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        } completion: { didFinish in
            self.removeFromSuperview()
        }

    }
}

extension Int {
    func times(closure: () -> Void) {
        guard self > 0 else {
            return
        }
        for _ in 0 ..< self {
            closure()
        }
    }
}

extension Array where Element: Comparable {
    mutating func removeItem(item: Element) {
        guard let firstIndex = self.firstIndex(of: item) else { return }
        self.remove(at: firstIndex)
    }
}

