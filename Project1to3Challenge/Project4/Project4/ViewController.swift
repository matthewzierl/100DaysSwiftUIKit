//
//  ViewController.swift
//  Project4
//
//  Created by Matthew Zierl on 6/30/24.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pictures += ["1", "2", "3", "4", "5"]
        self.navigationItem.title = "tattoo catalog(^_^)"
        self.navigationController?.navigationBar.prefersLargeTitles = true // prefer large title (for first view)
    }
    
    /*
        Estabishes how many rows the table will show
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    /*
        Called to provide cell
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = "\(indexPath.row + 1).jpeg"
        content.image = UIImage(named: "\(indexPath.row + 1)") // don't need to add '.jpeg' since in assets
        content.imageProperties.maximumSize = CGSize(width: 120, height: 80)
        cell.contentConfiguration = content
        
        return cell
    }
    
    /*
        When user selects a row
            - Pass image, name to detail view
            - Push view onto navigation controller's stack
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailview = self.storyboard?.instantiateViewController(identifier: "detail") as? DetailViewController {
            detailview.imageName = pictures[indexPath.row]
            navigationController?.pushViewController(detailview, animated: true)
        }
    }


}

