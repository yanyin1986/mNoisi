//
//  MNRelaxPlayerViewController.swift
//  mNoisi
//
//  Created by Leon.yan on 15/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

class MNRelaxPlayerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    let images: [String] = [
        "2817564516891261945",
        "Spring Walk.jpeg",
        "Ocean Wave.jpeg",
        "3.jpg",
        "4.jpg",
    ]

    var collapse: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func modalFullScreen(_ sender: UIBarButtonItem) {

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackCell", for: indexPath) as! MNTrackCollectionViewCell
        cell.imageView.image = UIImage(named: self.images[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(self.view.frame.size)
        return self.view.frame.size
    }
}
