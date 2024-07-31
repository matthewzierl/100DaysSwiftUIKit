//
//  ViewController.swift
//  Project1
//
//  Created by Matthew Zierl on 6/27/24.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    
    var picturesViewCount = [String: Int]()
    
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
        
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "viewCount") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                picturesViewCount = try jsonDecoder.decode([String: Int].self, from: savedData)
            } catch {
                print("Failed to load view count")
            }
        }
        
        
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
    
    /*
        REQUIRED
        Called by iOS automatically to determine how many rows in a section for a TableView
        'section' part is for splitting rows into different sections, but we don't need that for now
        returns number of cells in the section
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    /*
        REQUIRED
        Called when you need to provide a row
        indexPath 'IndexPath' contains section number and row number that needs the cell
        returns a UITableViewCell
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) // 'Picture' identifier created in storyboard
        
        var content = cell.defaultContentConfiguration() // modify content of cell
        content.text = pictures[indexPath.row] // change text to image name
        content.secondaryText = "views: \(picturesViewCount[pictures[indexPath.row]] ?? 0)"
        
        content.textProperties.font = UIFont.systemFont(ofSize: 24) // changing size of font
        
        cell.contentConfiguration = content // reassign new copy to cell
        
        return cell
    }
    
    /*
        After the user selects a row in UITableView
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let detailView = self.storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            // 2: success! Set its selectedImage property
            detailView.selectedImage = pictures[indexPath.row]
            detailView.totalImages = pictures.count
            detailView.currentImageIndex = indexPath.row
            if var count = picturesViewCount[pictures[indexPath.row]] {
                count += 1
                picturesViewCount[pictures[indexPath.row]] = count
            } else {
                picturesViewCount[pictures[indexPath.row]] = 1
            }
            save()
            tableView.reloadData()
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
    
    func save() {
        let jsonEncoder = JSONEncoder() // use JSONEncoder to encode people array
        
        if let savedData = try? jsonEncoder.encode(picturesViewCount) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "viewCount") // save to user defaults with key 'people'
        } else {
            print("Failed to save data")
        }
    }
}
