//
//  ViewController.swift
//  Project1
//
//  Created by Matthew Zierl on 6/27/24.
//

import UIKit

class ViewController: UITableViewController {
    
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
        
        // Do any additional setup after loading the view.
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix(".jpeg") {
                pictures.append(item)
            }
        }
        
        pictures.sort(using: sortPic(order: .forward))
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
            // 3: now push it onto the navigation controller
            navigationController?.pushViewController(detailView, animated: true)
        }
    }
}
