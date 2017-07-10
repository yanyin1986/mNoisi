//
//  MNTableViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 18/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

protocol MNTableViewDelegate: NSObjectProtocol {

    func playerListViewWillHide()

    func playerListWannaHideBottomView()

    func playerListWannaShowBottomView()
}

class MNTableViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var delegate: MNTableViewDelegate?

    @IBOutlet
    weak var topView: UIView!

    @IBOutlet
    weak var collectionView: UICollectionView!

    struct SoundTrackName {
        var soundTitleName: String
        var soundImageName: String
    }

    var tracks: [MNTrack] = []
    private var _lastContentOffsetY: CGFloat?

    var soundTrackNames = [
        SoundTrackName(soundTitleName: "Ocean Wave", soundImageName: "Ocean Wave.jpeg"),
        SoundTrackName(soundTitleName: "Spring Walk", soundImageName: "Spring Walk.jpeg"),
        SoundTrackName(soundTitleName: "3", soundImageName: "3.jpg"),
        SoundTrackName(soundTitleName: "4", soundImageName: "4.jpg"),
    ]

    @IBAction func close(_ sender: Any) {
        self.delegate?.playerListWannaShowBottomView()
        self.delegate?.playerListViewWillHide()
    }

    @IBAction func selectedTagChanged(_ sender: MNSegmentControl) {
        if sender.selectedItem == 0 {
            tracks = MNTrackManager.shared.tracks
        } else {
            // selectedItem = 1
            tracks = MNTrackManager.shared.liked
        }
        collectionView.reloadData()
    }
    
//    var soundNames = ["Ocean Wave.jpeg", "Spring Walk.jpeg", "3.jpg", "4.jpg"]
    override func viewDidLoad() {
        super.viewDidLoad()

        tracks = MNTrackManager.shared.tracks
        collectionView.contentInset = UIEdgeInsetsMake(70, 10, 10, 10)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "MNSoundTrackCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "soundTrackCell")
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

        let track = MNTrackManager.shared.tracks[indexPath.row]
        cell.soundImageView.image = UIImage(named: track.fullScreen)

        let isTrackLiked = MNTrackManager.shared.isTrackLiked(track)
        cell.isFavorite.isHidden = !isTrackLiked
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
        let track = MNTrackManager.shared.tracks[indexPath.row]
        print(track)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let lastContentOffsetY = self._lastContentOffsetY else {
            _lastContentOffsetY = scrollView.contentOffset.y
            return
        }

        var scrollOffsetY = max(0, scrollView.contentOffset.y)
        scrollOffsetY = min(scrollView.contentSize.height - scrollView.frame.height, scrollOffsetY)

        if scrollOffsetY > lastContentOffsetY {
            // scroll to down, hide bottom view
            self.delegate?.playerListWannaHideBottomView()
            
        } else if scrollOffsetY < lastContentOffsetY {
            // scroll to up, show bottom view
            self.delegate?.playerListWannaShowBottomView()
        }

        _lastContentOffsetY = scrollOffsetY
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self._lastContentOffsetY = nil
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self._lastContentOffsetY = nil
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self._lastContentOffsetY = nil
        }
    }

}
