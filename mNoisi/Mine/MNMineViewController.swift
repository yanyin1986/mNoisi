//
//  MNMineViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 20/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit
import UserNotifications

let relaxNotificationId = "com.relax.notification_1"

class MNMineViewController: MNBaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet
    private weak var tableView: UITableView!

    private var notificationAuth: UNAuthorizationStatus?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0)
        tableView.register(UINib(nibName: "MNCalendarTableViewCell", bundle: nil), forCellReuseIdentifier: "calendarCell")
        tableView.register(UINib(nibName: "MNStaticsInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "staticsInfoCell")
        tableView.register(MNSwitchTableViewCell.self, forCellReuseIdentifier: "switchCell")
        tableView.register(MNTextTableViewCell.self, forCellReuseIdentifier: "textCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 5
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: MNCalendarTableViewCell.reuseIdentifier, for: indexPath) as! MNCalendarTableViewCell
                cell.backgroundColor = UIColor.clear
                return cell
            } else {// if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: MNStaticsInfoTableViewCell.reuseIdentifier, for: indexPath) as! MNStaticsInfoTableViewCell
                cell.backgroundColor = UIColor.clear
                return cell
            }
        } else { // section == 1
        /*
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MNSwitchTableViewCell.reuseIdentifier, for: indexPath) as! MNSwitchTableViewCell
            cell.switch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            if let notificationAuth = self.notificationAuth {
                if notificationAuth == .authorized {
                    UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (requests) in
                        if requests.first(where: { $0.identifier == relaxNotificationId }) != nil {
                            cell.switch.isOn = true
                        } else {
                            cell.switch.isOn = false
                        }
                    })
                } else {
                    ///
                    cell.switch.isOn = false
                }
            } else {
                UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (setting) in
                    self.notificationAuth = setting.authorizationStatus
                    cell.switch.isOn = (setting.authorizationStatus == .authorized)
                })
            }

            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (setting) in
                cell.switch.isOn = (setting.authorizationStatus == .authorized)
            })
            cell.titleLabel.text = "Daily Notification"
            cell.backgroundColor = UIColor.clear
            return cell
        } */
            let cell = tableView.dequeueReusableCell(withIdentifier: MNTextTableViewCell.reuseIdentifier, for: indexPath) as! MNTextTableViewCell
            cell.backgroundColor = UIColor.clear
            switch indexPath.row {
            case 0:
                // share with your friends
                cell.titleLabel.text = "Share with your friends"
            case 1:
                // rate us with 5 stars
                cell.titleLabel.text = "Rate us with 5 starts"
            case 2:
                // feedback
                cell.titleLabel.text = "Feedback"
            case 3:
                // privacy policy
                cell.titleLabel.text = "Privacy Policy"
            case 4:
                // EULA
                cell.titleLabel.text = "EULA"
            default: break
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == 1 else { return }

        switch indexPath.row {
        case 0:
            TTRateKit.shared.shareWithFriends(self.navigationController)
        case 1:
            TTRateKit.shared.showRate(self.navigationController)
        case 2:
            TTRateKit.shared.showFeedbackEmail(self.navigationController)
        case 3:
            let webVC = MNLocalWebViewController()
            webVC.title = "Privacy Policy"
            webVC.webURL = Bundle.main.url(forResource: "privacy", withExtension: "html")
            self.navigationController?.pushViewController(webVC, animated: true)
        case 4:
            let webVC = MNLocalWebViewController()
            webVC.title = "EULA"
            webVC.webURL = Bundle.main.url(forResource: "eula", withExtension: "html")
            self.navigationController?.pushViewController(webVC, animated: true)
        default:
            debugPrint("")
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 300
            } else {
                return 85
            }
        } else {
            return 50
        }
        /*
        if indexPath.row == 0 {
            return 300 * tableView.frame.width / 360
        } else if indexPath.row == 1 {
            // 1
            return 85
        } else {
            return 50
        }
 */
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
        let task: () -> Void = {
            let indexPath = IndexPath(row: 2, section: 0)
            guard let switchCell = self.tableView.cellForRow(at: indexPath) as? MNSwitchTableViewCell else { return }
            switchCell.switch.isOn = false

            if let auth = self.notificationAuth, auth == UNAuthorizationStatus.denied {
                ///
                let alert = UIAlertController(title: "Notification permission is denied",
                                              message: "Please goto Setting->Privacy, turn on notification",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
                    // do nothing
                }))
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    // setting
                    if let url = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }

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
                if error == nil {

                } else {
                    DispatchQueue.main.async(execute: task)
                }
            })
        } else {
            DispatchQueue.main.async(execute: task)
        }
    }

    /*
    // MARK: - FNCalendar
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    }
 */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
    }
}
