//
//  ViewController.swift
//  Project4to6Challenge
//
//  Created by Matthew Zierl on 7/8/24.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Shopping List"
        
        let shareItems = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(shareShoppingList))
        let addToList = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addShoppingItem))
        
        navigationItem.rightBarButtonItems = [addToList, shareItems]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearList))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    /*
        loads cells into table
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItem", for: indexPath)
        var config = cell.defaultContentConfiguration()
        
        config.text = shoppingList[indexPath.row]
        
        cell.contentConfiguration = config
        return cell
    }
    
    
    /*
        call something to add item to list, then update UI for list
     */
    @objc func addShoppingItem() {
        let ac = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { // closure for handler
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.shoppingList.append(answer) // put at back
            
            let newIndex: Int! = self?.shoppingList.endIndex
            
            let indexPath = IndexPath(row: newIndex - 1, section: 0) // put at new index (back)
            self?.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
    @objc func clearList() {
        shoppingList.removeAll(keepingCapacity: false)
        tableView.reloadData()
    }
    
    @objc func shareShoppingList() {
        
        let allItems = shoppingList.joined(separator: "\n")
        
        let ac = UIActivityViewController(activityItems: ["Shopping List:\n", allItems], applicationActivities: [])
        ac.popoverPresentationController?.sourceItem = navigationItem.rightBarButtonItems?[0] // share button
        present(ac, animated: true)
    }
    
    


}

