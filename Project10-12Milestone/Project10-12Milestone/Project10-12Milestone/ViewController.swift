//
//  ViewController.swift
//  Project10-12Milestone
//
//  Created by Matthew Zierl on 8/1/24.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var allInterests: [Interest] = [Interest]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addInterest))
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return } // pull image from picker
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let interest = Interest(interest: "", image: imageName)
        
                
        dismiss(animated: true) // dismiss the top view controller (last pushed)
        
        // Present ac to provide name of interest
        
        let ac = UIAlertController(title: "Name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].placeholder = "Name of Interest"
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            interest.interest = ac?.textFields?[0].text ?? "Unnamed"
            self?.allInterests.append(interest)
            self?.collectionView.reloadData()
            
        })
        
        // end of ac
        
        present(ac, animated: true)
        

    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allInterests.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as? InterestCell else {
            fatalError("unable to dequeue reusable cell")
        }
        
        let currentInterest = allInterests[indexPath.item]
        
        cell.imageLabel.text = currentInterest.interest
        cell.imageLabel.textColor = .black
        
        let path = getDocumentsDirectory().appendingPathComponent(currentInterest.image) // root + imageName
        
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func save() {
        let defaults = UserDefaults.standard
    }
    
    @objc func addInterest() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self // links to self
        present(picker, animated: true)
    }


}

