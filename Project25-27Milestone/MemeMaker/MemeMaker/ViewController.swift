//
//  ViewController.swift
//  MemeMaker
//
//  Created by Matthew Zierl on 9/4/24.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var allMemes = [Meme]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewMeme))
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCell", for: indexPath) as? MemeCell ?? MemeCell()
        cell.imageView.image = allMemes[indexPath.item].image
        cell.title.text = allMemes[indexPath.item].title
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // push detailViewController onto navigation stack
        let detailView = DetailViewController()
        detailView.meme = allMemes[indexPath.item]
        
        navigationController?.pushViewController(detailView, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allMemes.count
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        // Create the UIAlertController to get user input
        let textPrompt = UIAlertController(title: "Default Meme Template", message: nil, preferredStyle: .alert)
        
        // Add text fields for top and bottom text
        textPrompt.addTextField { textField in
            textField.placeholder = "Top Text"
        }
        textPrompt.addTextField { textField in
            textField.placeholder = "Bottom Text"
        }
        
        // Action for when the user submits the text
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            
            let topText = textPrompt.textFields?[0].text ?? ""
            let bottomText = textPrompt.textFields?[1].text ?? ""
            
            let renderer = UIGraphicsImageRenderer(size: image.size)
            
            let meme = renderer.image { context in
                
                image.draw(in: CGRect(origin: .zero, size: image.size))
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 128),
                    .paragraphStyle: paragraphStyle,
                    .foregroundColor: UIColor.white
                ]
                
                let topTextRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height / 4)
                let attributedTopText = NSAttributedString(string: topText, attributes: attrs)
                attributedTopText.draw(in: topTextRect)
                
                let bottomTextRect = CGRect(x: 0, y: image.size.height - image.size.height / 4, width: image.size.width, height: image.size.height / 4)
                let attributedBottomText = NSAttributedString(string: bottomText, attributes: attrs)
                attributedBottomText.draw(in: bottomTextRect)
            }
            
            // Create a new Meme object and add it to the array
            let newMeme = Meme(image: meme, title: topText.isEmpty ? (bottomText.isEmpty ? "Untitled" : bottomText) : topText)
            
            self?.allMemes.append(newMeme)
            self?.collectionView.reloadData()
        }
        
        // Add the submit action and present the alert
        textPrompt.addAction(submitAction)
        present(textPrompt, animated: true)
    }

    
    @objc func createNewMeme(_ btn: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }


}

