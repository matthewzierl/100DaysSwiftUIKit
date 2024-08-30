//
//  ViewController.swift
//  Project25
//
//  Created by Matthew Zierl on 8/29/24.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCBrowserViewControllerDelegate {
    
    
    
    
    var images = [UIImage]()
    
    var peerID = MCPeerID(displayName: UIDevice.current.name) // identifies each user uniquely in a session
    var peerAdvertiser: MCNearbyServiceAdvertiser?
    var mcSession: MCSession? // Manager class that handles all peer connectivity
    var peerBrowser: MCNearbyServiceBrowser?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Selfie Share"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageView", for: indexPath)
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        return cell
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    let ac = UIAlertController(title: "Send Error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Okay", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        invitationHandler(true, mcSession)
        
    }
    
    // Helpful for debugging, tells which peer changed state
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
        @unknown default:
            print("Unknown State Receivied: \(peerID.displayName)")
        }
    }
    

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in // push to main thread bc updating UI
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    // ignore
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    // ignore
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        
    }
    
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to Others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a Session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a Session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }

        // Check if we're already advertising
        if peerAdvertiser == nil {
            peerAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "hws-project25")
            peerAdvertiser?.delegate = self
            peerAdvertiser?.startAdvertisingPeer()
            
            // Optional: Provide feedback to the user
            let ac = UIAlertController(title: "Hosting Started", message: "Your device is now discoverable to others.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            // Optional: Provide feedback if already hosting
            let ac = UIAlertController(title: "Already Hosting", message: "Your device is already discoverable to others.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    // Optional: Method to stop hosting
    func stopHosting() {
        peerAdvertiser?.stopAdvertisingPeer()
        peerAdvertiser = nil
    }

    
    @objc func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }

        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession) // MCBrowserViewController provides a UI for browsing and connecting to peers
        mcBrowser.delegate = self

        present(mcBrowser, animated: true)
    }

    
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }


}

