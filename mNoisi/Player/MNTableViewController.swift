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

        collectionView.contentInset = UIEdgeInsetsMake(70, 10, 6, 10)
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
        return tracks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MNSoundTrackCollectionViewCell.reuseIdentifier, for: indexPath) as! MNSoundTrackCollectionViewCell

        let track = tracks[indexPath.row]
        cell.soundImageView.image = UIImage(named: track.fullScreen)

        let isTrackLiked = MNTrackManager.shared.isTrackLiked(track)

        if isTrackLiked == true {
            cell.isFavorite.alpha = 0
        } else {
            cell.isFavorite.alpha = 1
        }
        cell.isFavorite.center = cell.center
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = UIEdgeInsetsInsetRect(collectionView.frame, collectionView.contentInset)
        return CGSize(width: frame.width, height: frame.width / 3.0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let track = tracks[indexPath.row]
        print(track)
    }



}
