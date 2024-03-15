

import Foundation
import SwiftUI
import WebKit

class WebViewModel: NSObject, ObservableObject, WKNavigationDelegate {
    @Published var webResource: String?
    @Published var currentURL: String = ""
    
    var webView: WKWebView
    
    init(webResource: String? = nil) {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.allowsInlineMediaPlayback = true
        config.allowsAirPlayForMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = true
        
        self.webView = WKWebView(frame: .zero, configuration: config)
        
        let userAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Version/17.2.1 Safari/605.1.15; SkyLeap/1.41.0"
        self.webView.customUserAgent = userAgent
        
        
        super.init()
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
    }
    
    // Example delegate method
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Update the current URL when the page finishes loading
        self.currentURL = webView.url?.absoluteString ?? ""
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Failed to load: \(error.localizedDescription)")
    }
    
    // Other delegate methods as needed...
    
    func loadWebPage() {
        if let webResource = webResource {
            guard let url = URL(string: webResource) else {
                print("Bad URL")
                return
            }
            
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

extension WebViewModel: WKUIDelegate {
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            let url = navigationAction.request.url
            self.webResource = url?.absoluteString
            self.loadWebPage()
        }
        return nil
    }
}
