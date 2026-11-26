import SwiftUI
import WebKit

struct ContentView: View {
    var body: some View {
        LocalWebView()
            .edgesIgnoringSafeArea(.all)
    }
}

struct LocalWebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        
        let webView = WKWebView(frame: .zero, configuration: config)
        loadWebsite(in: webView)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    private func loadWebsite(in webView: WKWebView) {
        let fileManager = FileManager.default
        guard let docsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // Creates "Assets" inside On My iPad > SARPBC
        let assetsURL = docsURL.appendingPathComponent("Assets")
        if !fileManager.fileExists(atPath: assetsURL.path) {
            try? fileManager.createDirectory(at: assetsURL, withIntermediateDirectories: true)
        }
        
        let indexURL = assetsURL.appendingPathComponent("index.html")
        
        if fileManager.fileExists(atPath: indexURL.path) {
            webView.loadFileURL(indexURL, allowingReadAccessTo: assetsURL)
        } else {
            let placeholderHTML = """
            <!DOCTYPE html>
            <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <style>
                    body {
                        margin: 0;
                        height: 100vh;
                        display: flex;
                        flex-direction: column;
                        justify-content: center;
                        align-items: center;
                        text-align: center;
                        font-family: -apple-system, BlinkMacSystemFont, "Helvetica Neue", sans-serif;
                        font-size: 26px;
                        line-height: 1.4;
                        color: #000000;
                        background-color: #ffffff;
                    }
                    .spacer {
                        height: 36px;
                    }
                </style>
            </head>
            <body>
                <div>No index.html Detected</div>
                <div>Please Insert The Game Assets In</div>
                <div class="spacer"></div>
                <div>On My iPad &gt; SARPBC &gt; Assets</div>
            </body>
            </html>
            """
            webView.loadHTMLString(placeholderHTML, baseURL: nil)
        }
    }
}
