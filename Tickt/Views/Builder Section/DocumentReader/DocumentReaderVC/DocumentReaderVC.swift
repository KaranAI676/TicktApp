//
//  DocumentReaderVC.swift
//  Tickt
//
//  Created by S H U B H A M on 08/06/21.
//

import UIKit
import WebKit

class DocumentReaderVC: BaseVC {

    //MARK:- IB Outlets
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var backButton: UIButton!
    ///
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    //MARK:- Variables
    var url: String = ""
    var comingFromLocal: Bool = true
    
    //MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK:- IB Actions
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.pop()
    }
}

extension DocumentReaderVC {
    
    private func initialSetup() {
        webView.backgroundColor = .white
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        ///
        mainQueue { [weak self] in
            (self?.comingFromLocal ?? false) ? self?.loadWebPageContent() : self?.downloadDoc()
        }
    }
    
    private func loadWebPageContent(absolutePath: String? = nil) {
        let loadableUrl = absolutePath == nil ? self.url : absolutePath ?? ""
        if let url = URL(string: loadableUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        if webView.isLoading {
            handleLoader(showLoader: true)
        }
    }
    
    private func handleLoader(showLoader: Bool) {
        guard let loader = self.loader else { return }
        loader.isHidden = !showLoader
        showLoader ? loader.startAnimating() : loader.stopAnimating()
    }
    
    private func downloadDoc() {
        guard let url = URL(string: self.url) else { return }
        handleLoader(showLoader: true)
        FileDownloader.loadFileAsync(url: url, completion: { [weak self] absolutePath, error in
            guard let self = self else { return }
            if error != nil {
                return
            } else {
                if let url = absolutePath {
                    self.mainQueue {
                        self.loadWebPageContent(absolutePath: url.absoluteString)
                    }
                }
            }
        })
    }
}

//MARK:- WebViewDelegates
//=======================
extension DocumentReaderVC: WKNavigationDelegate, UIScrollViewDelegate{
    /// This is a method which is responsible to stop the activity indicator when the URl loaded successfully.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        mainQueue { [weak self] in
            self?.handleLoader(showLoader: false)
        }
    }
}

class FileDownloader {

    static func loadFileAsync(url: URL, completion: @escaping (URL?, Error?) -> Void) {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        if false, FileManager().fileExists(atPath: destinationUrl.path) {
            completion(destinationUrl, nil) /// File already exists
        } else {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler: {
                data, response, error in
                if error == nil {
                    if let response = response as? HTTPURLResponse {
                        if response.statusCode == 200 {
                            if let data = data {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic) {
                                    completion(destinationUrl, error)
                                }
                                else {
                                    completion(destinationUrl, error)
                                }
                            }
                            else {
                                completion(destinationUrl, error)
                            }
                        }
                    }
                }
                else {
                    completion(destinationUrl, error)
                }
            })
            task.resume()
        }
    }
}
