//
//  ViewController.swift
//  Project22
//
//  Created by Matthew Zierl on 8/20/24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var beaconLabel: UILabel!
    @IBOutlet var distanceReading: UILabel!
    
    var locationManager: CLLocationManager?
    var activeBeaconUUID: UUID?  // Track the currently detected beacon's UUID
    
    var allUUID = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        distanceReading.text = "UNKNOWN"
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        allUUID = [
            UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!,
            UUID(uuidString: "EDBA2FC0-C7B4-415D-B0BA-55401EB2C092")!,
            UUID(uuidString: "BCE3EBD0-A1FF-4C46-9E45-E39791870B8B")!
        ]
        
        for uuid in allUUID {
            let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: uuid.uuidString)
            locationManager?.startMonitoring(for: beaconRegion)
            locationManager?.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid))
        }
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        guard let beacon = beacons.first else {
            return
        }

        // If a beacon is already active, ignore others
        if let activeUUID = activeBeaconUUID {
            guard activeUUID == beacon.uuid else { return }  // Continue updating only for the active beacon
        } else {
            // No active beacon, set the current beacon as active
            activeBeaconUUID = beacon.uuid
            let index = allUUID.firstIndex(of: beacon.uuid)
            var beaconType = String()
            
            switch index {
            case 0:
                beaconType = "Alpha"
            case 1:
                beaconType = "Beta"
            case 2:
                beaconType = "Charlie"
            default:
                beaconType = "Unknown"
            }
            
            beaconLabel.text = beaconType
            
            UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat], animations: {
                self.beaconLabel.alpha = 0.0
            }, completion: nil)
            
            // Optionally, show an alert when the first beacon is found
            let ac = UIAlertController(title: "Beacon found!", message: beaconType, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cool", style: .default))
            present(ac, animated: true)
        }

        // Continue updating the UI for the active beacon
        update(distance: beacon.proximity)
    }
}
