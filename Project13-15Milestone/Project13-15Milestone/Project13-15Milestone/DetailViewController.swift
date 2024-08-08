//
//  DetailViewController.swift
//  Project13-15Milestone
//
//  Created by Matthew Zierl on 8/8/24.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var webView: WKWebView!
    var detailItem: Country?
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        guard let country = detailItem else { return }
        guard let imageName = imageName else { return }
        
        
        imageView.image = UIImage(named: imageName)
        imageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        imageView.layer.borderWidth = 2
        
        navigationItem.title = country.government.countryName.longName.text
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 80%; } </style>
        </head>
        <body>
        <h2><u>Overview</u></h2>
        <p>\(country.introduction.background.text)</p>
        <h2><u>Capital</u></h2>
        <p>&#9733;\(country.government.capital.name.text):</p>
        <p>\(country.government.capital.etymology.text)</p>
        <h2><u>Location</u></h2>
        <p><u>Location</u>: \(country.geography.location.text)</p>
        <p><u>Climate</u>: \(country.geography.climate.text)</p>
        <p><u>Terrain</u>: \(country.geography.terrain.text)</p>
        <h2><u>Population</u></h2>
        <p><u>Total</u>: \(country.peopleAndSociety.population.total.text)</p>
        <p><u>Male</u>: \(country.peopleAndSociety.population.male.text)</p>
        <p><u>Female</u>: \(country.peopleAndSociety.population.female.text)</p>
        <h2><u>Government</u></h2>
        <p>\(country.government.governmentType.text)</p>
        <h2><u>Etymology</u></h2>
        <p>\(country.government.countryName.etymology.text)</p>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
