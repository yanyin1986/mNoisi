//
//  MNTableViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 18/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNTableViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet
    weak var topView: UIView!

    @IBOutlet
    weak var collectionView: UICollectionView!

    struct SoundTrackName {
        var soundTitleName: String
        var soundImageName: String
    }

    var soundTrackNames = [
        SoundTrackName(soundTitleName: "Ocean Wave", soundImageName: "Ocean Wave.jpeg"),
        SoundTrackName(soundTitleName: "Spring Walk", soundImageName: "Spring Walk.jpeg"),
        SoundTrackName(soundTitleName: "3", soundImageName: "3.jpg"),
        SoundTrackName(soundTitleName: "4", soundImageName: "4.jpg"),
    ]

    @IBAction func close(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name.MNRelaxPlayerViewWillAppear, object: nil)
        self.dismiss(animated: true, completion: nil)
    }


//    var soundNames = ["Ocean Wave.jpeg", "Spring Walk.jpeg", "3.jpg", "4.jpg"]
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.contentInset = UIEdgeInsetsMake(44, 10, 20, 10)
        //self.view.backgroundColor = UIColor(red: 0x15/255.0, green: 0x23/255.0, blue: 0x3c/255.0, alpha: 1.0)// UIColor.red

        collectionView.dataSource = self
        collectionView.delegate = self
        //tableView.separatorInset = UIEdgeInsetsMake(100, 20, 100, 10)
        collectionView.backgroundColor = UIColor.clear

        topView.layer.shadowOpacity = 1.0
        topView.layer.shadowOffset = CGSize(width: 0, height: 1)
        topView.layer.shadowRadius = 8.0
        topView.layer.shadowColor = UIColor(white: 0, alpha: 57.0).cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return soundTrackNames.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let identifier = "cell"
//        var soundCell = tableView.dequeueReusableCell(withIdentifier: "cell")
//        if soundCell == nil {
//            soundCell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
//        }
//        let soundLabel: SoundTrackName = soundTrackNames[indexPath.row]
//        soundCell?.textLabel?.text = soundLabel.soundTitleName
//        soundCell?.backgroundColor = UIColor.clear
//        soundCell?.backgroundView = UIImageView(image: UIImage(named: soundLabel.soundImageName))
        //indexPath.row
        //indexPath.section
        print(indexPath)

        let soundLabel: SoundTrackName = soundTrackNames[indexPath.row]
        let soundCell = tableView.dequeueReusableCell(withIdentifier: "soundTrackCell", for: indexPath) as! MNSoundTrackTableViewCell
        soundCell.soundImageView.image = UIImage(named: soundLabel.soundImageName)
        soundCell.backgroundColor = UIColor.clear

        return soundCell
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
