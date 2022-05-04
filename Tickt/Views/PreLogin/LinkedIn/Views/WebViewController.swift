//
//  WebViewController.swift
//  Tickt
//
//  Created by S H U B H A M on 11/03/21.
//

import UIKit
import WebKit
 
protocol LinkedInSigninDelegate: AnyObject {    
    func linkedInSuccess(accessToken: String)
    func linkedInFailure(error: String)
}

class WebViewController: BaseVC {
    
    enum ScreenTpe {
        case privacy, terms, linkedIn
    }
    
    var screenType: ScreenTpe = .linkedIn
    weak var delegate: LinkedInSigninDelegate?
    var activityIndicator: UIActivityIndicatorView! = nil
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var cancelButton: UIButton!
            
    let linkedInKey = "78xhp3erxj0ck3"
    let linkedInSecret = "DpV3W4GOtBdpDxOu"
    let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
    let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        webView.navigationDelegate = self
        setScreenType()
    }
    
    func setScreenType() {
        switch screenType {
        case .linkedIn:
            startAuthorization()
            cancelButton.setImage(nil, for: .normal)
            cancelButton.setTitle("Cancel", for: .normal)
        case .privacy:
            getPrivacyPolicy()
        case .terms:
            getTermsAndCondition()
        }
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        activityIndicator.hidesWhenStopped = true
    }

    func startAuthorization() {
        let responseType = "code"
        let redirectURL = "https://www.shift-freight.com/".addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        let scope = "r_liteprofile+r_emailaddress" 
        
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(linkedInKey)&"
        authorizationURL += "redirect_uri=\(redirectURL)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
        
        print(authorizationURL)
        webView.load(URLRequest(url: URL(string: authorizationURL)!))
        mainQueue { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if screenType == .linkedIn {
            dismiss(animated: true, completion: nil)
        } else {
          pop()
        }
    }
}

extension WebViewController: WKNavigationDelegate  {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if (url?.host ?? "")  == "www.shift-freight.com" {
            if url?.absoluteString.range(of: "code") != nil {
                let urlParts = url?.absoluteString.components(separatedBy: "?")
                if let code = urlParts?[1].components(separatedBy: "=")[1] {
                    requestForAccessToken(authorizationCode: code)
                }
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation:
        WKNavigation!) {
        mainQueue { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        mainQueue { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
}

