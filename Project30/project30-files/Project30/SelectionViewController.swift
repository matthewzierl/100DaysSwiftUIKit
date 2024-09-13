//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
	var items = [String]() // this is the array that will store the filenames to load
	var dirty = false
    var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Reactionist"

		tableView.rowHeight = 90
		tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

		// load all the JPEGs into our array
		let fm = FileManager.default
        
        guard let path = Bundle.main.resourcePath else { return }

		if let tempItems = try? fm.contentsOfDirectory(atPath: path) {
			for item in tempItems {
                print(item)
                if item.range(of: "Large") != nil {
                    
					items.append(item)
                    print("added to items array with total count: \(items.count)")
                    
                    let imageRootName = item.replacingOccurrences(of: "Large", with: "Thumb")
                    guard let path = Bundle.main.path(forResource: imageRootName, ofType: nil) else { fatalError("Could not get path for table cell image") }
                    guard let original = UIImage(contentsOfFile: path) else { fatalError("Could not convert image path to image for cell") }
                    let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90)) // row size
                    let renderer = UIGraphicsImageRenderer(size: renderRect.size) // change renderer to row size
            
                    let rounded = renderer.image { ctx in

                        ctx.cgContext.addEllipse(in: renderRect)
                        ctx.cgContext.clip()
            
                        original.draw(in: renderRect)
                    }
                    images.append(rounded)
                    print("added to image array with total count: \(images.count)")
                    
                }
			}
		}
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if dirty {
			// we've been marked as needing a counter reload, so reload the whole table
			tableView.reloadData()
		}
	}

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return items.count * 10
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var config = cell.defaultContentConfiguration()

        
        config.image = images[indexPath.row % images.count]
        
        let currentImage = items[indexPath.row % items.count]

        // each image stores how often it's been tapped
        let defaults = UserDefaults.standard
        config.text = "\(defaults.integer(forKey: currentImage))"
        
        cell.contentConfiguration = config

        return cell
        
    }
        
//		let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//
//		// find the image for this cell, and load its thumbnail
//		let currentImage = items[indexPath.row % items.count]
//		let imageRootName = currentImage.replacingOccurrences(of: "Large", with: "Thumb")
//        guard let path = Bundle.main.path(forResource: imageRootName, ofType: nil) else { fatalError("Could not get path for table cell image") }
//        guard let original = UIImage(contentsOfFile: path) else { fatalError("Could not convert image path to image for cell") }
//
//        let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90)) // row size
//        let renderer = UIGraphicsImageRenderer(size: renderRect.size) // change renderer to row size
//
//		let rounded = renderer.image { ctx in
//            
////            ctx.cgContext.setShadow(offset: .zero, blur: 200, color: UIColor.black.cgColor)
////            ctx.cgContext.fillEllipse(in: CGRect(origin: .zero, size: original.size)) // draw ellipse full size of image
////            ctx.cgContext.setShadow(offset: .zero, blur: 200, color: nil) // clears the shadow
//            
////			ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
//            ctx.cgContext.addEllipse(in: renderRect)
//			ctx.cgContext.clip()
//
//			original.draw(in: renderRect)
//		}
//
//		cell.imageView?.image = rounded
//
//		// give the images a nice shadow to make them look a bit more dramatic
//		cell.imageView?.layer.shadowColor = UIColor.black.cgColor
//		cell.imageView?.layer.shadowOpacity = 1
//		cell.imageView?.layer.shadowRadius = 10
//		cell.imageView?.layer.shadowOffset = CGSize.zero
//        
//        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath
//
//		// each image stores how often it's been tapped
//		let defaults = UserDefaults.standard
//		cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"
//
//		return cell
//    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ImageViewController()
		vc.image = items[indexPath.row % items.count]
		vc.owner = self

		// mark us as not needing a counter reload when we return
		dirty = false
        
        if let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: true)
        }

		
	}
}
