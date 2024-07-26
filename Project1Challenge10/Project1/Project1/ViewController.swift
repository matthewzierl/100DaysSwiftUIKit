//
//  ViewController.swift
//  Project1
//
//  Created by Matthew Zierl on 6/27/24.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var pictures = [String]()
    
    /*
        ONLY used for sorting the pictures
     */
    struct sortPic: SortComparator {
        func compare(_ lhs: String, _ rhs: String) -> ComparisonResult {
            
            let lhs_cut = Int(lhs.dropLast(5))
            let rhs_cut = Int(rhs.dropLast(5))
            
            guard let lhs_cut = lhs_cut, let rhs_cut = rhs_cut else {
                return .orderedSame
            }
            
            if (lhs_cut < rhs_cut) {
                return order == .forward ? .orderedAscending : .orderedDescending
            }
            else if (lhs_cut > rhs_cut) {
                return order == .forward ? .orderedDescending : .orderedAscending
            } else {
                return .orderedSame
            }
            
        }
        
        typealias Compared = String
                    
        var order: SortOrder
    }

    override func viewDidLoad() { // called after screen is loaded
        super.viewDidLoad()
        
        self.title = "cool tattoos(^^)"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareApp))
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            // Do any additional setup after loading the view.
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                if item.hasSuffix(".jpeg") {
                    self?.pictures.append(item)
                }
            }
            
            self?.pictures.sort(using: sortPic(order: .forward))
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Tattoo", for: indexPath) as? TattooCell else {
            fatalError("Unable to dequeue collection view cell")
        }
        
        let pictureName = pictures[indexPath.item]
        
        cell.name.text = pictureName
        cell.name.textColor = .white
        cell.image.image = UIImage(named: pictureName)
        
        cell.image.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.image.layer.borderWidth = 2
        cell.image.layer.cornerRadius = 7
        cell.layer.cornerRadius = 7
        
        cell.backgroundColor = .black
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let detailView = self.storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            detailView.selectedImage = pictures[indexPath.row]
            detailView.totalImages = pictures.count
            detailView.currentImageIndex = indexPath.row
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(detailView, animated: true)
        }
    }
    
    @objc func shareApp() {
        let vc = UIActivityViewController(activityItems: ["Check out this app! Tattoos are cool!"], applicationActivities:  [])
//        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        vc.popoverPresentationController?.sourceItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
