//
//  MNMineViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 20/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit
import FSCalendar

class MNMineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MNCalendarTableViewCell.reuseIdentifier, for: indexPath) as! MNCalendarTableViewCell
            cell.backgroundColor = UIColor.clear
            return cell
        } else {
            // 1
            let cell = tableView.dequeueReusableCell(withIdentifier: MNStaticsInfoTableViewCell.reuseIdentifier, for: indexPath) as! MNStaticsInfoTableViewCell
            cell.backgroundColor = UIColor.clear
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        } else {
            // 1
            return 120
        }
    }

    /*
    // MARK: - FNCalendar
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
    }
 */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
