//
//  ViewController.swift
//  Project7
//
//  Created by Matthew Zierl on 7/9/24.
//

import UIKit

class ViewController: UITableViewController {
    
    var games = [VideoGame]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://github.com/leinstay/steamdb/raw/main/steamdb.json"
        } else {
            urlString = "https://github.com/leinstay/steamdb/raw/main/steamdb.json" // i don't have a different json with same setup so...
        }
            
        
        if let url = URL(string: urlString) { // convert string to URL
            if let data = try? Data(contentsOf: url) { // convert URL to data instance
                // we're okay to parse!
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Problem loading data", message: "Please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Confirm", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonGames = try? decoder.decode([VideoGame].self, from: json) {
            games = jsonGames
            tableView.reloadData()
        }
    }
    
    /*
        Provide cells for given index
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        
        let game = games[indexPath.row]
        
        config.text = game.name
        config.secondaryText = "Genres: \(game.genres) | Platforms: \(game.platforms)"
        
        cell.contentConfiguration = config
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = games[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

