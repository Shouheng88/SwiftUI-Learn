//
//  WebView.swift
//  AwesomeSwift
//
//  Created by 王守恒 on 2022/11/2.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    let url: String
        
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        let delegate: Delegate = Delegate(webView: webview)
        webview.navigationDelegate = delegate
        webview.configuration.userContentController.add(delegate, name: "javascriptLoaded")
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let req = URLRequest(url: URL(string: url)!)
        uiView.load(req)
    }
    
    final class Delegate: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        
        let webView: WKWebView
        
        init(webView: WKWebView) {
            self.webView = webView
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "javascriptLoaded", let messageBody = message.body as? String {
                print("接收到 JavaScript 发送的消息 ：\(messageBody)")
//                self.checkGetResult(self)
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            redirectWords(webView)
            webView.evaluateJavaScript("window.webkit.messageHandlers.javascriptLoaded.postMessage('JavaScript Loaded')", completionHandler: nil)
        }
        
        private func redirectWords(_ webView: WKWebView) {
            webView.evaluateJavaScript("document.getElementById('search_input') != undefined") { (result, error) in
                print("get search input element: \(String(describing: result))")
                if result is Int {
                    let jsFill = """
                            var si = document.getElementById('search_input');\n
                            si.dispatchEvent(new Event('focus'));\n
                            si.value = \"Help\";\n
                            var event = new Event('input', { bubbles: true });\n
                            si.dispatchEvent(event);\n
                            var tb = document.getElementsByClassName(\"translate_btn\")[0];\n
                            tb.click();
                    """
                    webView.evaluateJavaScript(jsFill) { (result, error) in
                        print("redirected new page")
                        self.startTask(webView)
                    }
                } else {
                    print("获取网页标题失败：\(String(describing: error?.localizedDescription))")
                }
           }
        }
        
        private var counter = 0
        private var timer: Timer? = nil
        private var isTaskRunning = true
        
        func startTask(_ webView: WKWebView) {
            timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
                self.counter += 1
                if self.counter >= 30 {
                    self.stopTask()
                } else {
                    self.checkGetResult(webView) {
                        self.stopTask()
                    }
                }
            }
        }

        func stopTask() {
            timer?.invalidate()
            timer = nil
        }
        
        private func checkGetResult(_ webView: WKWebView, got: @escaping () -> Void) {
            webView.evaluateJavaScript("document.getElementsByClassName(\"trans-container\").length") { (result, error) in
                print("获取翻译容器 结果: \(String(describing: result))")
                if let length = result as? Int {
                    if (length != 0) {
                        self.parseHtml(webView, got: got)
                    }
                } else {
                    print("获取翻译容器 失败：\(String(describing: error?.localizedDescription))")
                }
            }
        }
        
        private func parseHtml(_ webView: WKWebView, got: @escaping () -> Void) {
            webView.evaluateJavaScript("document.documentElement.outerHTML.toString()") { (html, error) in
                guard let htmlString = html as? String else {
                    print("获取翻译结果 失败: \(String(describing: error))")
                    return
                }
                print("翻译结果: \(htmlString)")
                self.parseContent(htmlString)
                got()
            }
        }
        
        private func parseContent(_ html: String) {
            
        }
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: "https://dict.youdao.com/m/")
    }
}
