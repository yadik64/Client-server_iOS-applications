//
//  VKAthorizationController.swift
//  myVK
//
//  Created by Дмитрий Яровой on 20/05/2019.
//  Copyright © 2019 Дмитрий Яровой. All rights reserved.
//

import UIKit
import WebKit

class VKAthorizationController: UIViewController {

    @IBOutlet var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    private let session = Session.shared
    private let urlComponents: URLComponents = {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6965193"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/authorize/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: "2621500"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.95")
        ]
        return urlComponents
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = urlComponents.url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
}

extension VKAthorizationController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
                decisionHandler(.allow)
                return
        }
        let params = fragment
            .components(separatedBy: "&")
            .map{ $0.components(separatedBy: "=")}
            .reduce([String: String]()) { (result, param) in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        guard let token = params["access_token"], let id = params["user_id"] else {
            decisionHandler(.allow)
            return
        }
        session.token = token
        session.id = id
        
        performSegue(withIdentifier: "AuthorizationOKSegue", sender: self)
        
        print(session.token, session.id)
        
        decisionHandler(.cancel)
    }
}
