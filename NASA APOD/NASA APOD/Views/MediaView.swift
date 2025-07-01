//
//  MediaView.swift
//  NASA APOD
//
//  Created by Adam Gerber on 01/07/2025.
//

import SwiftUI
import WebKit

struct MediaView: View {
    var link: String
    
    private var modifiedURL: URL? {
        guard let url = URL(string: link) else { return nil }
        
        // For YouTube URLs, add parameters to prevent fullscreen
        if link.contains("youtube.com") || link.contains("youtu.be") {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            var queryItems = components?.queryItems ?? []
            
            // Add fs=0 to disable fullscreen button
            if !queryItems.contains(where: { $0.name == "fs" }) {
                queryItems.append(URLQueryItem(name: "fs", value: "0"))
            }
            
            // Add modestbranding=1 to reduce YouTube branding
            if !queryItems.contains(where: { $0.name == "modestbranding" }) {
                queryItems.append(URLQueryItem(name: "modestbranding", value: "1"))
            }
            
            components?.queryItems = queryItems
            return components?.url ?? url
        }
        
        return url
    }
    
    var body: some View {
        if let url = modifiedURL {
            WebView(url: url)
        } else {
            Text("Invalid URL")
                .foregroundColor(.red)
        }
    }
}

struct WebView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No updates needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("WebView failed to load: \(error.localizedDescription)")
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("WebView loaded successfully")
            
            // Inject JavaScript to prevent fullscreen and control video behavior
            let script = """
                // Prevent fullscreen on video elements
                document.addEventListener('click', function(e) {
                    if (e.target.tagName === 'VIDEO' || e.target.closest('video')) {
                        e.preventDefault();
                        e.stopPropagation();
                    }
                }, true);
                
                // Disable fullscreen API
                if (document.documentElement.requestFullscreen) {
                    document.documentElement.requestFullscreen = function() { return false; };
                }
                if (document.exitFullscreen) {
                    document.exitFullscreen = function() { return false; };
                }
                
                // For YouTube embeds, try to prevent fullscreen
                var iframes = document.querySelectorAll('iframe');
                iframes.forEach(function(iframe) {
                    if (iframe.src && iframe.src.includes('youtube')) {
                        // Add parameters to prevent fullscreen
                        if (iframe.src.includes('?')) {
                            iframe.src += '&fs=0';
                        } else {
                            iframe.src += '?fs=0';
                        }
                    }
                });
            """
            
            webView.evaluateJavaScript(script) { result, error in
                if let error = error {
                    print("JavaScript injection error: \(error)")
                }
            }
        }
    }
}

#Preview {
    MediaView(link: "https://www.youtube.com/embed/CC7OJ7gFLvE?rel=0")
}
