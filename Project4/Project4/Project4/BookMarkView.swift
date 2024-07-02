//
//  BookMarkView.swift
//  Project4
//
//  Created by Matthew Zierl on 7/3/24.
//

import UIKit

class BookMarkView: UITableViewController {
    
    var websites = ["apple.com", "swift.org", "lo.cafe"]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Bookmarks!"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return websites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Bookmark", for: indexPath)
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = websites[indexPath.row]
        
        cell.contentConfiguration = configuration
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let webView = storyboard?.instantiateViewController(identifier: "WebView") as? ViewController {
            webView.websites = self.websites
            webView.selectedWebsite = websites[indexPath.row]
            navigationController?.pushViewController(webView, animated: true)
        }
    }

}
