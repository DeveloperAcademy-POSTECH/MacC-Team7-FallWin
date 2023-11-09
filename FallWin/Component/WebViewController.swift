//
//  WebViewController.swift
//  FallWin
//
//  Created by 최명근 on 11/8/23.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var url: String!

    private let webView: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        return WKWebView(frame: .zero, configuration: configuration)
    }()
    private let btnPrev = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: nil, action: #selector(onPrevButtonClick))
    private let btnNext = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: nil, action: #selector(onNextButtonClick))
    private let btnShare = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: nil, action: #selector(onShareButtonClick))
    private let btnRefresh = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: nil, action: #selector(onRefreshButtonClick))
    private let btnSafari = UIBarButtonItem(image: UIImage(systemName: "safari"), style: .plain, target: nil, action: #selector(onSafariButtonClick))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initViews()
        
        webView.navigationDelegate = self
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
    }
    
    private func initViews() {
        self.view.addSubview(self.webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        let webTop = NSLayoutConstraint(item: self.webView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let webBottom = NSLayoutConstraint(item: self.webView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        let webLeading = NSLayoutConstraint(item: self.webView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let webTrailing = NSLayoutConstraint(item: self.webView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        let webCenterX = NSLayoutConstraint(item: self.webView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let webCenterY = NSLayoutConstraint(item: self.webView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([webTop, webBottom, webLeading, webTrailing, webCenterX, webCenterY])
        
        self.initToolbar()
        
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    private func initToolbar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barItems = [btnPrev, spacer, btnNext, spacer, btnShare, spacer, btnRefresh, spacer, btnSafari]
        self.toolbarItems = barItems
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc
    private func onPrevButtonClick(_ item: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc
    private func onNextButtonClick(_ item: UIBarButtonItem) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc
    private func onShareButtonClick(_ item: UIBarButtonItem) {
        guard let urlToShare = webView.url else {
            return
        }
        let activityVC = UIActivityViewController(activityItems: [urlToShare], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true)
    }
    
    @objc
    private func onRefreshButtonClick(_ item: UIBarButtonItem) {
        webView.reload()
    }
    
    @objc
    private func onSafariButtonClick(_ item: UIBarButtonItem) {
        if let url = URL(string: self.url) {
            UIApplication.shared.open(url)
        }
    }

}
