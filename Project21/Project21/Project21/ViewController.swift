//
//  ViewController.swift
//  Project21
//
//  Created by Matthew Zierl on 8/13/24.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("yay!")
            } else {
                print("D'oh!")
            }
        }
    }
    
    @objc func scheduleLocal() {
        
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests() // remove all requests that haven't been triggered yet
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // we want to test right away
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func scheduleNotificatonInterval(title: String, body: String, identifier: String) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = identifier
        content.userInfo = ["yes": "sir"]
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        /*
            identifier: unique string that gets sent to you when the button is tapped
            title: what users see in the interface
            options: any special actions related to the action
         */
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let other = UNNotificationAction(identifier: "destruction", title: "Destruction", options: .destructive)
        let remindLater = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: .foreground)
        
        /*
            identifier: must match same category identifier that we made above
         */
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, other, remindLater], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom Data received: \(customData)")
            
            let ac: UIAlertController?
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("Default identifier")
                ac = UIAlertController(title: "Lame", message: "Please use the action I gave you", preferredStyle: .alert)
                ac?.addAction(UIAlertAction(title: "okay", style: .default))
            case "show":
                print("User tapped OUR show more information...")
                ac = UIAlertController(title: "YES", message: "YOU USED OUR ACTION", preferredStyle: .alert)
                ac?.addAction(UIAlertAction(title: "COOL", style: .default))
            case "destruction":
                ac = UIAlertController(title: "destruction", message: "mwahahaha", preferredStyle: .alert)
                ac?.addAction(UIAlertAction(title: "...", style: .default))
            case "remindLater":
                ac = UIAlertController(title: "Scheduling notifcation", message: "10 sec from now so lock your screen", preferredStyle: .alert)
                ac?.addAction(UIAlertAction(title: "got it", style: .default))
                scheduleNotificatonInterval(title: "A custom notifcation", body: "You must have pressed 'remind later' in previous notificaton", identifier: "alaUrm")
                
            default:
                ac = UIAlertController(title: "huh", message: "what is going on...", preferredStyle: .alert)
                ac?.addAction(UIAlertAction(title: "bruh", style: .default))
            }
            
            if let ac = ac {
                present(ac, animated: true)
            }
        }
        // must call completion handler
        completionHandler() // marked escaping: can escape current method and be used later on
        // e.x: make network request, stash away completion handler to be used later on
    }


}

