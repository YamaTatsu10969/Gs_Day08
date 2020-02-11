//
//  TermsViewController.swift
//  GsTodo
//
//  Created by Tatsuya Yamamoto on 2020/1/30.
//  Copyright © 2020 yamamototatsuya. All rights reserved.
//

import UIKit
import WebKit

class TermsViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let termsURL = URL(string: "https://www.google.com/")
        let request = URLRequest(url: termsURL!)
        webView.load(request)
    }
    
}
