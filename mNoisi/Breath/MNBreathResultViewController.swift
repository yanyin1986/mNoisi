//
//  MNBreathResultViewController.swift
//  mNoisi
//
//  Created by yan on 2017/07/12.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNBreathResultViewController: MNBaseViewController {

    /// seconds
    var time: Int = 0
    
    @IBOutlet weak var timeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        timeLabel.text =
    }
    
    func timeText(_ time: Int) -> String {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func redo(_ sender: Any) {
        let breathViewController = MNBreathViewController()
        self.navigationController?.setViewControllers([breathViewController], animated: true)
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
