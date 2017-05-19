//
//  MNRelaxPlayerViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 15/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNRelaxPlayerViewController: UIViewController {

    var collapse: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func modalFullScreen(_ sender: UIBarButtonItem) {
        guard let tabBarController = self.tabBarController else { return }
        self.collapse = !self.collapse

        if collapse {
            let frame = tabBarController.view.frame
            UIView.animate(withDuration: 0.3) { 
                tabBarController.tabBar.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: tabBarController.tabBar.frame.height)
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: { 
                tabBarController.tabBar.frame = CGRect(x: 0,
                                                       y: tabBarController.view.frame.height - tabBarController.tabBar.frame.height,
                                                       width: tabBarController.view.frame.width,
                                                       height: tabBarController.tabBar.frame.height)
            })
        }
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
