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
        
        // Creates "assets" inside On My iPad > LocalWebRunner
        let assetsURL = docsURL.appendingPathComponent("assets")
        if !fileManager.fileExists(atPath: assetsURL.path) {
            try? fileManager.createDirectory(at: assetsURL, withIntermediateDirectories: true)
        }
        
        let indexURL = assetsURL.appendingPathComponent("index.html")
        
        if fileManager.fileExists(atPath: indexURL.path) {
            webView.loadFileURL(indexURL, allowingReadAccessTo: assetsURL)
        } else {
            let placeholderHTML = """
            <html>
            <body style="font-family: -apple-system; text-align: center; padding-top: 20%;">
                <h2>Folder Created!</h2>
                <p>Open <b>Files</b> &rarr; <b>On My iPad</b> &rarr; <b>LocalWebRunner</b> &rarr; <b>assets</b></p>
                <p>Drop your <code>index.html</code> and files inside, then force-close and reopen this app.</p>
            </body>
            </html>
            """
            webView.loadHTMLString(placeholderHTML, baseURL: nil)
        }
    }
}
