//
//  MNBreathViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 25/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNBreathViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction
    func dismiss(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    @IBAction
    func timerButtonPressed(_ sender: Any) {
        self.navigationController?.pushViewController(MNTimerViewController(), animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
