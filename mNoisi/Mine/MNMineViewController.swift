//
//  MNMineViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 20/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNMineViewController: MNBaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet
    private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0)
        tableView.register(UINib(nibName: "MNCalendarTableViewCell", bundle: nil), forCellReuseIdentifier: "calendarCell")
        tableView.register(UINib(nibName: "MNStaticsInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "staticsInfoCell")
        tableView.register(UINib(nibName: "MNSwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "switchCell")
        tableView.register(UINib(nibName: "MNTextTableViewCell", bundle: nil), forCellReuseIdentifier: "textCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MNCalendarTableViewCell.reuseIdentifier, for: indexPath) as! MNCalendarTableViewCell
            cell.backgroundColor = UIColor.clear
            return cell
        } else if indexPath.row == 1 {
            // 1
            let cell = tableView.dequeueReusableCell(withIdentifier: MNStaticsInfoTableViewCell.reuseIdentifier, for: indexPath) as! MNStaticsInfoTableViewCell
            cell.backgroundColor = UIColor.clear
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MNSwitchTableViewCell.reuseIdentifier, for: indexPath) as! MNSwitchTableViewCell
            cell.backgroundColor = UIColor.clear
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MNTextTableViewCell.reuseIdentifier, for: indexPath) as! MNTextTableViewCell
            cell.backgroundColor = UIColor.clear
            switch indexPath.row {
            case 3:
                // share with your friends
                cell.titleLabel.text = "Share with your friends"
            case 4:
                // rate us with 5 stars
                cell.titleLabel.text = "Rate us with 5 starts"
            case 5:
                // feedback
                cell.titleLabel.text = "Feedback"
            case 6:
                // privacy policy
                cell.titleLabel.text = "Privacy Policy"
            default: break
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 280
        } else if indexPath.row == 1 {
            // 1
            return 120
        } else {
            return 50
        }
    }

    @IBAction
    func dismiss(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print(segue)
    }

    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        print(unwindSegue)
    }
}
