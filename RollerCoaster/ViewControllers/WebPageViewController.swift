//
//  WebPageViewController.swift
//  Divyesh karansinh Solanki
//  student id: 301194819
//  date created : 02/04/2022

import UIKit
import WebKit

class WebPageViewController: UIViewController {
    
    @IBOutlet weak var webview: WKWebView!
    let progressView = UIProgressView(progressViewStyle: .default)

    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: Do something
    
    private func initialSetup() {
        webview.navigationDelegate = self
        setupProgressView()
        startLoadContent()
    }
    
    // MARK: - UIProgressView
    func setupProgressView() {
        self.view.addSubview(progressView)
        
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressView.alpha = 0.0
        progressView.progressTintColor = Themes.init(rawValue: UserDefaultsManager.Theme)?.themeConfig().primaryColor
        progressView.trackTintColor = UIColor.clear
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44.0),
            progressView.heightAnchor.constraint(equalToConstant: 4.0)
            ])
        
        webview.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
    }
    
    private func startLoadContent() {
        webview.load(URLRequest(url: URL(string: "https://www.letsgambleusa.com/laws/")!))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard object as? WKWebView === webview, keyPath == #keyPath(WKWebView.estimatedProgress) else { return }
        progressView.progress = Float(webview.estimatedProgress)
    }
    
    //MARK:- Actions
    @IBAction private func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        webview.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        webview.navigationDelegate = nil
    }
}

extension WebPageViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        progressView.alpha = 1.0
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 0.0
        })
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.alpha = 0.0
        UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 1.0
        })
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.alpha = 1.0
        UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 0.0
        })
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.alpha = 1.0
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 0.0
        })
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        progressView.alpha = 1.0
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 0.0
        })
    }
}
