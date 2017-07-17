//
//  MNLocalWebViewController.swift
//  mNoisi
//
//  Created by yan on 2017/07/17.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNLocalWebViewController: MNBaseViewController {

    var webURL: URL?
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.titleLabel.text = self.title
        webView.backgroundColor = UIColor.white

        guard let url = webURL else {
            return
        }
        if url.isFileURL {
            if let html = try? String(contentsOf: url) {
                webView.loadHTMLString(html, baseURL: nil)
            }
        } else {
            webView.loadRequest(URLRequest(url: url))
        }
        
    }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
