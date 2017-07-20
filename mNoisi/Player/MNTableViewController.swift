//
//  MNTableViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 18/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

protocol MNTableViewDelegate: NSObjectProtocol {

    func playerListDidSelectTrack(_ track: MNTrack)

    func playerListViewWillHide()

    func playerListWannaHideBottomView()

    func playerListWannaShowBottomView()
}

extension UIImage {
    func blur() -> UIImage? {
        guard let ciimage = CIImage.init(image: self) else {
            return nil
        }
        let filter = CIFilter.init(name: "CIGaussianBlur")
        filter?.setValue(ciimage, forKey: "inputImage")
        filter?.setValue(40.0, forKey: "inputRadius")

        let ctx = CIContext(eaglContext: EAGLContext.init(api: .openGLES2))

        guard let output = filter?.outputImage else {
            return nil
        }
        guard let cgImage = ctx.createCGImage(output, from: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

class MNTableViewController: MNBaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
    var playingTrack: MNTrack!
    private var _lastContentOffsetY: CGFloat?

    @IBAction func close(_ sender: Any) {
        self.delegate?.playerListWannaShowBottomView()
        self.delegate?.playerListViewWillHide()
    }

    @IBAction func selectedTagChanged(_ sender: MNSegmentControl) {
        if sender.selectedItem == 0 {
            let newTracks = MNTrackManager.shared.liked
            var diffIndexPaths = [IndexPath]()
            for i in 1 ... MNTrackManager.shared.tracks.count {
                if newTracks.first(where: { $0.id == Int64(i) }) == nil {
                    diffIndexPaths.append(IndexPath.init(row: i - 1, section: 0))
                }
            }
            tracks = MNTrackManager.shared.tracks
            collectionView.performBatchUpdates({
                self.collectionView.insertItems(at: diffIndexPaths)
            }, completion: { (finish) in

            })
        } else {
            // selectedItem = 1
            let newTracks = MNTrackManager.shared.liked

            var diffIndexPaths = [IndexPath]()
            for i in 1 ... MNTrackManager.shared.tracks.count {
                if newTracks.first(where: { $0.id == Int64(i) }) == nil {
                    diffIndexPaths.append(IndexPath.init(row: i - 1, section: 0))
                }
            }
            tracks = newTracks
            collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: diffIndexPaths)
            }, completion: { (finish) in

            })
        }
    }
    
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


        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? MNSoundTrackCollectionViewCell {
            let track = tracks[indexPath.row]
            cell.titleLabel.text = track.name
            cell.soundImageView.image = UIImage(named: track.fullScreen)

            let isTrackLiked = MNTrackManager.shared.isTrackLiked(track)
            cell.isFavorite.isHidden = !isTrackLiked

            if track != playingTrack {
                cell.soundImageView.alpha = 0.5
                cell.titleLabel.alpha = 0.5
                cell.isFavorite.alpha = 0.5
                cell.isPlay.isHidden = true
            } else {
                cell.soundImageView.alpha = 1.0
                cell.titleLabel.alpha = 1.0
                cell.isFavorite.alpha = 1.0
                cell.isPlay.isHidden = false
            }
        }
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
        var reloadIndexPaths = [IndexPath]()
        reloadIndexPaths.append(indexPath)
        if let currentPlayingIndex = tracks.index(of: playingTrack) {
            reloadIndexPaths.append(IndexPath(row: currentPlayingIndex, section: 0))
        }

        let track = tracks[indexPath.row]
        print(track)
        playingTrack = track
        collectionView.reloadItems(at: reloadIndexPaths)
        delegate?.playerListDidSelectTrack(track)

        /*
        if let fullScreen = UIImage(named: track.fullScreen) {
            DispatchQueue.global(qos: .background).async {
                if let image = fullScreen.blur() {
                    DispatchQueue.main.async {
                        self.topView.backgroundColor = UIColor.clear
                        self.view.layer.contents = image.cgImage
                    }
                }
            }
        }
 */
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
