//
//  AppDelegate.swift
//  mNoisi
//
//  Created by Leon.yan on 15/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import UserNotifications

struct NotificationSetting {
    var authStatus: UNAuthorizationStatus
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var shared: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        /// setup db
        EventsManager.shared.setup()

        application.beginReceivingRemoteControlEvents()

        let navigationBarAppear: UINavigationBar = UINavigationBar.appearance()
        navigationBarAppear.setBackgroundImage(UIImage(), for: .default)
        navigationBarAppear.shadowImage = UIImage()
        navigationBarAppear.backgroundColor = UIColor.clear
        navigationBarAppear.isTranslucent = true
        navigationBarAppear.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.white ]
        navigationBarAppear.tintColor = UIColor.white

        window = UIWindow(frame: UIScreen.main.bounds)

        let relaxVC = MNRelaxPlayerViewController()
        let nav = MNNavigationController(rootViewController: relaxVC)
        nav.isNavigationBarHidden = true
        if !Defaults[.firstLaunch] {
            Defaults[.firstLaunch] = true
            relaxVC.showList = true
        } else {
            relaxVC.showList = false
        }
        window?.rootViewController = nav
        window?.makeKeyAndVisible()

        return true
    }



    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    override func remoteControlReceived(with event: UIEvent?) {
        guard let event = event else { return }
        if event.type == UIEventType.remoteControl {
            switch event.subtype {
            case .remoteControlStop:
                //stop
                MNPlayer.shared.pause()
            case .remoteControlPlay:
                MNPlayer.shared.play()
            case .remoteControlPause:
                MNPlayer.shared.pause()
            case .remoteControlNextTrack:
                break
            case .remoteControlPreviousTrack:
                break
            default:
                break
                
            }
        }
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func enableLocalNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.getNotificationSettings(completionHandler: { (settings) in

            if settings.authorizationStatus == .notDetermined {
                center.requestAuthorization(options: [.alert, .sound, .badge],
                                            completionHandler: { (granted, error) in
                                                //
                })
            }
        })
        /*
        center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in

        })
        */
    }
}

