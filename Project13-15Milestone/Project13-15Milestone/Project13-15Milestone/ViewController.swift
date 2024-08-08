//
//  ViewController.swift
//  Project13-15Milestone
//
//  Created by Matthew Zierl on 8/7/24.
//

import UIKit

class ViewController: UICollectionViewController {
    
    
    struct CountryDisplayInfo {
        var name: String
        var imageName: String
        var gec: String
        var continent: String
    }
    
    var countryNames = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria",
                  "Poland", "Russia", "Spain", "UK", "US"]
    
    var countries = [CountryDisplayInfo]() // for collection view

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.title = "Select A Country To Learn About It!"
        
        for country in countryNames {
            countries.append(CountryDisplayInfo(name: country, imageName: country.lowercased(), gec: getCountryGEC(name: country), continent: getContinent(name: country)))
        }
        
    }
    
    func getCountryGEC(name: String) -> String {
        let countryGEC = ["Estonia": "EN", "France": "FR", "Germany": "GM", "Ireland": "EI", "Italy": "IT", "Monaco": "MN", "Nigeria": "NI",
                            "Poland": "PL", "Russia": "RS", "Spain": "SP", "UK": "UK", "US": "US"]
        return countryGEC[name] ?? "UNKNOWN"
    }
    
    func getContinent(name: String) -> String {
        let countryGEC = ["Estonia": "Europe", "France": "Europe", "Germany": "Europe", "Ireland": "Europe", "Italy": "Europe", "Monaco": "Europe", "Nigeria": "Africa",
                            "Poland": "Europe", "Russia": "Central-Asia", "Spain": "Europe", "UK": "Europe", "US": "North-America"]
        return countryGEC[name] ?? "UNKNOWN"
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryCell", for: indexPath) as? CountryCell else {
            print("Could not dequeue cell as CountryCell")
            return UICollectionViewCell()
        }
        cell.imageView.image = UIImage(named: countries[indexPath.item].imageName)
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        cell.name.text = countries[indexPath.item].name
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 2
        cell.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.25, delay: 0, options: []) {
                cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            } completion: { finished in
                UIView.animate(withDuration: 0.25, delay: 0, options: []) {
                    cell.transform = .identity
                }
            }

        }
        
        let selectedCountry = countries[indexPath.item]
        var urlString = "https://github.com/factbook/factbook.json/raw/master/"
        urlString.append("\(selectedCountry.continent.lowercased())/\(selectedCountry.gec.lowercased()).json")
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let url = URL(string: urlString) else {
                print("URL Conversion Error")
                return
            }
            do {
                print(urlString)
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                let country = try decoder.decode(Country.self, from: data)
                
                // create detail view controller from this information
                DispatchQueue.main.async {
                    guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "CountryDetailView") as? DetailViewController else {
                        print("Could not instantiate new CountryDetailView controller")
                        return
                    }
                    vc.detailItem = country
                    vc.imageName = selectedCountry.imageName
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            } catch {
                print("Failed to load/parse data")
            }
        }
        
    }


}

