//
//  ViewController.swift
//  Project7
//
//  Created by Matthew Zierl on 7/9/24.
//

import UIKit

class ViewController: UITableViewController {
    
    var games = [VideoGame]()
    var filteredGames = [VideoGame]()
    var urlString: String? = nil
    var selectedGenre: String? = nil
    var selectedPlatform: String? = nil
    var showFilteredResults: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://github.com/leinstay/steamdb/raw/main/steamdb.json"
        } else { // tag == 1
            urlString = "https://github.com/leinstay/steamdb/raw/main/steamdb.json" // i don't have a different json with same setup so...
        }
        
        // urlString will have a value no matter what
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", image: nil, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterResults))
            
        
        if let url = URL(string: urlString!) { // convert string to URL
            if let data = try? Data(contentsOf: url) { // convert URL to data instance
                // we're okay to parse!
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    @objc func filterResults() {
        let ac = UIAlertController(title: "Filter", message: "Choose a genre or platform (1 word each)", preferredStyle: .alert)
        ac.addTextField()// genre
        ac.textFields?[0].placeholder = "Action, Adventure, etc..."
        ac.addTextField() // platform
        ac.textFields?[1].placeholder = "WIN, MAC, LNX..."
        
        let filterAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            
            if let genreField = ac?.textFields?[0] {
                self?.selectedGenre = genreField.text
            }
            if let platformField = ac?.textFields?[1] {
                self?.selectedPlatform = platformField.text
            }
            self?.showFilteredResults = true
            self?.updateFilteredList()
            self?.tableView?.reloadData()
        }
        
        ac.addAction(filterAction)
        
        present(ac, animated: true)
    }
    
    func updateFilteredList() {
        
        filteredGames.removeAll() // clear previous list
        
        if selectedGenre! != "" && selectedPlatform! != "" {
            for game in games {
                if game.genres.contains(selectedGenre!) && game.platforms.contains(selectedPlatform!) {
                    filteredGames.append(game)
                }
            }
        } else if selectedGenre! != "" {
            for game in games {
                if game.genres.contains(selectedGenre!) {
                    filteredGames.append(game)
                }
            }
        } else if selectedPlatform! != "" {
            for game in games {
                if game.platforms.contains(selectedPlatform!) {
                    filteredGames.append(game)
                }
            }
        } else {
            showFilteredResults = false // user put nothing in the filter, return to normal
            return // don't do anything, nil for both
        }
    }
    
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "This information is provided by \(urlString!)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default))
        present(ac, animated: true)
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
        
        let game: VideoGame
        
        if showFilteredResults {
            game = filteredGames[indexPath.row]
        } else {
            game = games[indexPath.row]
        }
        
        config.text = game.name
        config.secondaryText = "Genres: \(game.genres) | Platforms: \(game.platforms)"
        
        cell.contentConfiguration = config
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showFilteredResults {
            return filteredGames.count
        }
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = games[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

