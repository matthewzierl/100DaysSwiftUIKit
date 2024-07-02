//
//  ViewController.swift
//  Project4
//
//  Created by Matthew Zierl on 7/1/24.
//

import UIKit
import WebKit

/*
 IMPORTANT:
    ViewController now appears to inherit from 2 classes, which IS NOT possible
    For example:
        class A: B, C
    A is the new class
    B is the super class (parent) from which A inherits from
    C (and and those following) are all protocols the class promises to conform to
 */
class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites: [String]?
    var selectedWebsite: String?
    
    override func loadView() {
        webView = WKWebView() // create new instance of web browser component
        // 'delegate' definition: one thing acting in place of another, effectively answering questions and responding to events on its behalf
        webView.navigationDelegate = self // assigning 'self' to be able to handle navigation updates to webView
        // 'self' needs to implement methods needed to be delegate for webView, however these are optional, but swift doesn't know
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /*
            Registers the observer (self) for KVO (key value observation) meaning when webView changed, provides
            info for observer
            forKeyPath: #keypath(var) is the variable we want to observe. it is 'keypath' and not 'property' because you can set up a path for whatever you want to observe. '#keypath' allows compiler to check class has property
            options: .new means we want the value that was newly set
            context: if you provide a unique value, that same value gets sent back to you when you get notification the value has changed. Allows you to check contexts to make sure it was your observer which was called
            
         */
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload)) // calls 'reload' method of webView (WKWebView)
        
        progressView = UIProgressView(progressViewStyle: .default) // create instance and use .default for style (also .bar try it!)
        progressView.sizeToFit() // force the progressView to fit it's content size fully
        let progressButton = UIBarButtonItem(customView: progressView) // wrap progress view in a UIBarButtonItem
        
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrowshape.left"), style: .plain, target: self, action: #selector(navigateBack))
        let forwardButton = UIBarButtonItem(image: UIImage(systemName: "arrowshape.right"), style: .plain, target: self, action: #selector(navigateForward))
        
        toolbarItems = [backButton, forwardButton, spacer, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        if let selectedWebsite = selectedWebsite {
            let url = URL(string: "https://" + selectedWebsite)!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
        
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        guard let websites = websites else {
            return
        }
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage)) // handler passes a reference of openPage so that whenever the action is called, it calls openPage with it's necessary parameters
        }
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel)) // no need for handler
        
        ac.popoverPresentationController?.sourceItem = navigationItem.rightBarButtonItem // ipad
        
        present(ac, animated: true)
        
    }
    
    @objc func navigateBack() {
        webView.goBack()
    }
    
    @objc func navigateForward() {
        webView.goForward()
    }
    
    func openPage(action: UIAlertAction) {
        guard let name = action.title, let url = URL(string: "https://" + name) else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    /*
        Called when webpage finishes loading
     */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title // both are optionals
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    /*
    Decide to allow or cancel a navigation
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url // navigationAction contains info about an action that causes navigation to occur
        guard let websites = websites else {
            return
        }
        
        if let host = url?.host() { // 'host' is website domain of url
            for website in websites {
                if host.contains(website) {
                    /*
                     3 Cases:
                        .cancel
                        .allow
                        .download
                     */
                    decisionHandler(.allow)
                    return
                }
            }
            let ac = UIAlertController(title: "Navigation Prohibited", message: "Website: \(host) is not allowed", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Okay", style: .cancel))
            present(ac, animated: true)
        }
        decisionHandler(.cancel)
    }


}

