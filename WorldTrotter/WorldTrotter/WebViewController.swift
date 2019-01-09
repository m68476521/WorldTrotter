//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Miguel Orozco on 1/8/19.
//  Copyright © 2019 m68476521. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        let myURL = URL(string: "https://m68476521.com")
        let myRequest = URLRequest(url:myURL!)
        webView.load(myRequest)
        view = webView
    }
}
