//
//  TTRateKit.swift
//  mNoisi
//
//  Created by yan on 2017/07/17.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit
import MessageUI

class TTRateKit: NSObject, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    enum RateState: Int {
        case none    = 0
        case showing = 1
        case later   = 2
        case rated   = 3
    }

    public private(set) var savedCount: Int = 0
    public private(set) var rateState: RateState = RateState.none
    public private(set) var appId: String = "123456789"
    public private(set) var appVersion: String
    public private(set) lazy var appName: String = {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    }()
    public private(set) lazy var deviceName: String = {
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar].init(repeating: 0, count: size + 2)
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String.init(cString: machine)
    }()

    public private(set) var recipientAddressList: [String] = [
        "feedback.mmd.dev@gmail.com"
    ]

    static public let shared: TTRateKit = TTRateKit()
    private let _tipCountArray: [Int] = [3, 6, 9, 12]
    private var _currentAppVersion: String


    private override init() {
        let currentAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        if let dict = UserDefaults.standard.dictionary(forKey: "com.tateapp.ratekit"),
            let appVer = dict["appVersion"] as? String,
            appVer == currentAppVersion
        {
            savedCount = dict["savedCount"] as? Int ?? 0
            rateState = RateState(rawValue: dict["rateState"] as? Int ?? 0) ?? .none
            appVersion = appVer
            _currentAppVersion = currentAppVersion
        } else {
            savedCount = 0
            rateState = .none
            appVersion = currentAppVersion
            _currentAppVersion = currentAppVersion
        }
    }

    private func synchronize() {
        let dict: [String: Any] = [
            "appVersion" : appVersion,
            "savedCount" : savedCount,
            "rateState"  : rateState.rawValue
        ]
        UserDefaults.standard.set(dict, forKey: "com.tateapp.ratekit")
        UserDefaults.standard.synchronize()
    }

    // show rate tips
    func didSuccessSaved() {
        savedCount += 1
        if rateState == .later {
            rateState = .none
        }
        self.synchronize()
    }
    
    func showRateTipsIfNeeds() {
        guard (_currentAppVersion == appVersion && rateState == .none && self.isSavedCountEqual()) else {
            return
        }
        self.showRate(nil)
    }

    func showRate(_ inViewController: UIViewController?) {
        let vc = inViewController ?? UIApplication.shared.keyWindow?.rootViewController
        let alertVC = UIAlertController(title: nil,
                                        message: NSLocalizedString("rate_message", comment: ""),
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: NSLocalizedString("rate_rate", comment: ""),
                                        style: .default,
                                        handler: { (_) in
                                            //
                                            self.rateState = .rated
                                            self.synchronize()
                                            guard let url = self.rateURL() else { return }
                                            UIApplication.shared.open(url)
        }))
        alertVC.addAction(UIAlertAction(title: NSLocalizedString("rate_feedback", comment: ""),
                                        style: .default,
                                        handler: { (_) in
                                            // show feedback 
                                            self.showFeedbackEmail(vc)
                                            self.rateState = .rated
                                            self.synchronize()
        }))
        alertVC.addAction(UIAlertAction(title: NSLocalizedString("rate_cancel", comment: ""),
                                        style: .default,
                                        handler: { (_) in
                                            // cancel rate
                                            self.rateState = .later
                                            self.synchronize()
        }))
        rateState = .showing
        vc?.present(alertVC, animated: true, completion: nil)
    }

    private func isSavedCountEqual() -> Bool {
        for count in _tipCountArray {
            if count == savedCount {
                return true
            }
        }
        return false
    }

    private func rateURL() -> URL? {
        let urlStr = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appId)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
        return URL(string: urlStr)
    }


    // MARK: feedback
    func showFeedbackEmail(_ inViewController: UIViewController?) {
        let vc = inViewController ?? UIApplication.shared.keyWindow?.rootViewController
        guard let mailVC = self.showMailViewController(withRecipients: self.recipientAddressList, isHTML: true) else {
            return
        }
        vc?.present(mailVC, animated: true, completion: nil)
    }

    private func showMailViewController(withRecipients: [String], isHTML: Bool) -> MFMailComposeViewController? {
        guard MFMailComposeViewController.canSendMail() else {
            return nil
        }
        var mail = "<html>\n" +
        "<head>\n" +
        "</head>\n" +
        "<body>\n" +
        "<p style=\"font-size:15px;color:#444444;margin:0\">Describe your issues/suggestions below</p>\n" +
        "<div id=\"feedback\" style=\"border: 1px solid #999999;border-width:1px 0px 1px 0px;overflow:auto;\">\n" +
        "<p>\n" +
        "<br/>\n" +
        "<br/>\n" +
        "<br/>\n" +
        "</p>\n" +
        "</div>\n" +
        "<div id=\"screenshot\" style=\"border: 1px solid #999999;border-width:0px 0px 1px 0px;overflow:auto;\">\n" +
        "<p style=\"font-size:15px;color:#444444;margin:0\">Long press to add screenshot here</p>\n" +
        "<p>\n" +
        "<br/>\n" +
        "<br/>\n" +
        "<br/>\n" +
        "</p>\n" +
        "</div>\n" +
        "<table style=\"color:#999999;\">\n" +
        "<tr><td>App Name:</td><td id=\"app_name\">APP-NAME</td></tr>\n" +
        "<tr><td>App Version:</td><td id=\"app_ver\">APP-VER</td></tr>\n" +
        "<tr><td>Device:</td><td id=\"device\">DEV-NAME</td></tr>\n" +
        "<tr><td>OS Version:</td><td id=\"os_ver\">DEV-OS</td></tr>\n" +
        "<tr><td>Capacity:</td><td id=\"Capacity\">DEV-CAPACITY</td></tr>\n" +
        "<tr><td>Available:</td><td id=\"Available\">DEV-AVAILABLE</td></tr>\n" +
        "</table>\n" +
        "<body>\n" +
        "</html>"

        mail = mail.replacingOccurrences(of: "Describe your issues/suggestions below",
                                         with: NSLocalizedString("Describe your issues/suggestions below", comment: ""))
        mail = mail.replacingOccurrences(of: "Long press to add screenshot here",
                                         with: NSLocalizedString("Long press to add screenshot here", comment: ""))
        mail = mail.replacingOccurrences(of: "App Name:",
                                         with: NSLocalizedString("App Name:", comment: ""))
        mail = mail.replacingOccurrences(of: "App Version:",
                                         with: NSLocalizedString("App Version:", comment: ""))
        mail = mail.replacingOccurrences(of: "Device:",
                                         with: NSLocalizedString("Device:", comment: ""))
        mail = mail.replacingOccurrences(of: "OS Version:",
                                         with: NSLocalizedString("OS Version:", comment: ""))
        mail = mail.replacingOccurrences(of: "APP-NAME", with: appName)
        mail = mail.replacingOccurrences(of: "APP_VER", with: appVersion)
        mail = mail.replacingOccurrences(of: "DEV-NAME", with: deviceName)
        mail = mail.replacingOccurrences(of: "DEV-OS", with: UIDevice.current.systemVersion)

        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            let totalSize = (attributes[FileAttributeKey.systemSize] as! NSNumber).int64Value
            let freeSize = (attributes[FileAttributeKey.systemFreeSize] as! NSNumber).int64Value

            let formatter = ByteCountFormatter()
            mail = mail.replacingOccurrences(of: "DEV-CAPACITY",
                                             with: formatter.string(fromByteCount: totalSize))
            mail = mail.replacingOccurrences(of: "DEV-AVAILABLE",
                                             with: formatter.string(fromByteCount: freeSize))
        } catch {
            debugPrint(error.localizedDescription)
        }

        let subject = String(format: NSLocalizedString("TTSC_Feedback", comment: ""), appName) + " " + appVersion

        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.title = subject
        mailComposeVC.setMessageBody(mail, isHTML: true)
        mailComposeVC.setToRecipients(withRecipients)
        return mailComposeVC
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    // MARK: share with your friends
    func shareWithFriends(_ inViewController: UIViewController?) {
        let vc = inViewController ?? UIApplication.shared.keyWindow?.rootViewController
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setSubject(NSLocalizedString("Check out Relax", comment: ""))
            let messageBody = NSLocalizedString("Download Relax on AppStore: ", comment: "") + "\n<br/><br/><a href=\"https://play.google.com/store/apps/details?id=relaxmelodies.sleepsounds.meditation&amp;eferrer=utm_source%3Dshare\">https://play.google.com/store/apps/details?id=relaxmelodies.sleepsounds.meditation&amp;eferrer=utm_source%3Dshare</a>"
            mailVC.setMessageBody(messageBody, isHTML: true)
            vc?.present(mailVC, animated: true, completion: nil)
        } else if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            messageVC.subject = NSLocalizedString("Check out Relax", comment: "")
            messageVC.body = NSLocalizedString("Download Relax on AppStore: ", comment: "") + "\nhttps://play.google.com/store/apps/details?id=relaxmelodies.sleepsounds.meditation&amp;eferrer=utm_source%3Dshare"
            vc?.present(messageVC, animated: true, completion: nil)
        } else {
            let text = NSLocalizedString("Download Relax on AppStore: ", comment: "") + "\nhttps://play.google.com/store/apps/details?id=relaxmelodies.sleepsounds.meditation&amp;eferrer=utm_source%3Dshare"
            let activity = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            vc?.present(activity, animated: true, completion: nil)
        }
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
