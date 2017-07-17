//
//  MNMineViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 20/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit
import UserNotifications

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
        return 8
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row >= 3
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
            cell.switch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)

            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (setting) in
                if (setting.authorizationStatus == .denied) {
                    cell.switch.isEnabled = false
                } else {
                    cell.switch.isEnabled = true
                    cell.switch.isOn = (setting.authorizationStatus == .authorized)
                }
            })

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
            case 7:
                // EULA
                cell.titleLabel.text = "EULA"
            default: break
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 3:
            TTRateKit.shared.shareWithFriends(self.navigationController)
        case 4:
            TTRateKit.shared.showRate(self.navigationController)
        case 5:
            TTRateKit.shared.showFeedbackEmail(self.navigationController)
        case 6:
            let webVC = MNLocalWebViewController()
            webVC.title = "Privacy Policy"
            webVC.webURL = Bundle.main.url(forResource: "privacy", withExtension: "html")
            self.navigationController?.pushViewController(webVC, animated: true)
        case 7:
            let webVC = MNLocalWebViewController()
            webVC.title = "EULA"
            webVC.webURL = Bundle.main.url(forResource: "eula", withExtension: "html")
            self.navigationController?.pushViewController(webVC, animated: true)
        default:
            debugPrint("")
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

    @objc
    func switchValueChanged(_ switch: UISwitch) {
        if `switch`.isOn {
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound],
                completionHandler: self.requestNotificationComplete(granted:error:))
        } else {
            self.requestNotificationComplete(granted: false, error: nil)
        }
    }

    func requestNotificationComplete(granted: Bool, error: Error?) {
        let center = UNUserNotificationCenter.current()
        if granted {
            let content = UNMutableNotificationContent()
            content.title = "Start to Relax"
            content.body = "relax now!"

            var date = DateComponents()
            date.hour = 19
            date.minute = 58
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            
            let notificationRequest = UNNotificationRequest(identifier: "com.relax.notification_1", content: content, trigger: trigger)//, trigger: trigger)
            center.add(notificationRequest, withCompletionHandler: { (error) in

            })
        } else {

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
