//
//  MNTimerViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 25/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

protocol MNTimerDelegate: class {

    func timerViewController(_ controller: MNTimerViewController, didChooseTime: Int)
}

class MNTimerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    weak var delegate: MNTimerDelegate?

    @IBOutlet
    private weak var timePicker: UIPickerView!

    var times: [Int] = [
        1, 3, 5, 10, 15, 20, 25, 30, 40, 50, 60
    ]

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirm(_ sender: Any) {
        let selectedRow = timePicker.selectedRow(inComponent: 0)
        self.delegate?.timerViewController(self, didChooseTime: times[selectedRow])
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return times.count
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = "\(times[row]) m"
        return NSAttributedString(string: title, attributes: [ NSForegroundColorAttributeName : UIColor.white ])
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
