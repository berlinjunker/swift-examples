//
//  LoginView.swift
//  Sonnen
//
//  Created by Peter Werner on 03.03.23.
//

import SwiftUI
import WebKit

struct LoginView: UIViewRepresentable {
    var closeFunction: (() -> Void)
    private var webView: WKWebView?
    var url: URL? = URL(string: URLS.LOGIN)
    let network: Network
    
    init(network: Network, closeFunction: @escaping (() -> Void)) {
        self.network = network
        self.closeFunction = closeFunction
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url!)
        webView.navigationDelegate = context.coordinator
        context.coordinator.closeFunction = closeFunction
        context.coordinator.network = network
        webView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: LoginView
        var closeFunction : (() -> Void)?
        var network: Network?
        
        init(_ parent: LoginView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
            if let host = navigationAction.request.url?.host {
                if (host == "my.sonnen.de") {
                    // dismiss view
                    // closeFunction?()
                }
            }
            
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView,
                     didFinish navigation: WKNavigation!) {
            // Change "key" to your local storage's key that you want to check its value
            webView.evaluateJavaScript("localStorage.getItem(\"persist:CustomerPortal--auth\")", completionHandler: { (value, error) in
                
                guard let storageObj = value as? String else {
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(AuthLocalStorageObject.self, from: Data(storageObj
                        .replacingOccurrences(of: "\\\"", with: "")
                        .utf8))
                    self.network!.TOKEN = decoded.accessToken
                    self.closeFunction?()
                } catch {
                    print("!!")
                }
            })
        }
        
    }
}
