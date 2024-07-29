//
//  ViewController.swift
//  Project10
//
//  Created by Matthew Zierl on 7/25/24.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses: [Person.self], from: savedPeople) as? [Person] {
                people = decodedPeople
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue a Person cell")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        cell.name.textColor = .black
        
        let path = getDocumentsDirectory().appending(path: person.image)
        
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
//        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
//            picker.sourceType = .camera
//        }
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString // create unique name
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        save()
        collectionView.reloadData()
        
        dismiss(animated: true) // dismiss top most view controller
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ask = UIAlertController(title: "Would you like to rename or delete?", message: nil, preferredStyle: .alert)
        ask.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Okay", style: .default) { [weak self, weak ac] _ in
                guard let newName = ac?.textFields?[0].text else {return}
                person.name = newName
                self?.save()
                self?.collectionView.reloadData()
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(ac, animated: true)
        })
        ask.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.save()
            self?.collectionView.reloadData()
        })
        ask.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ask, animated: true)
    }
    
    func save() {
        // save array of objects into a data format that can be saved in persistent storage
        // we modified 'Person' to conform to NSObject and NSCoding so that it can work with NSKeyedArchiver
        // root is 'people' array
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: Person.supportsSecureCoding) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }
    }


}

