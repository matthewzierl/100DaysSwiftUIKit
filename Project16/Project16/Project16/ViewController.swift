//
//  ViewController.swift
//  Project16
//
//  Created by Matthew Zierl on 8/8/24.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: SFSymbols.map), style: .plain, target: self, action: #selector(changeMapType))
        
        let tokyo = Capital(title: "Tokyo", coordinate: CLLocationCoordinate2D(latitude: 35.652832, longitude: 139.839478), extraInfo: "My home")
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), extraInfo: "Home to 2012 Summer Olympics")
        
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), extraInfo: "Founded over 100 years ago")
        
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), extraInfo: "Often called city of light")
        
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), extraInfo: "Has a whole country inside it")
        
        let washington = Capital(title: "Washington D.C", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), extraInfo: "Named after George himself")
        
        mapView.addAnnotations([tokyo, london, oslo, paris, rome, washington])
    }
    
    @objc func changeMapType() {
        let ac = UIAlertController(title: "Map Type", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: { [weak self] _ in
            let config = MKStandardMapConfiguration()
            self?.mapView.preferredConfiguration = config
        }))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { [weak self] _ in
            let config = MKHybridMapConfiguration()
            self?.mapView.preferredConfiguration = config
        }))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { [weak self] _ in
            let config = MKImageryMapConfiguration()
            self?.mapView.preferredConfiguration = config
        }))
        present(ac, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is Capital else { return nil }
        
        let identifier = "CapitalMarker"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor = .magenta
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn // assigning button on right side of annotationView
        } else {
            annotationView?.annotation = annotation
            annotationView?.markerTintColor = .magenta
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo =  capital.extraInfo
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Okay", style: .default))
        
        present(ac, animated: true)
    }


}

