//
//  MNTrack.swift
//  mNoisi
//
//  Created by Leon.yan on 24/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import Foundation

public struct MNTrack {
    var id: Int64
    var name: String
    var thumbnail: String
    var fullScreen: String
    var audioUrl: URL
}

public let tracks: [MNTrack] = [
    MNTrack(id: 1, name: "Mountain", thumbnail: "", fullScreen: "2817564516891261945", audioUrl: Bundle.main.url(forResource: "a01_mountain_lake", withExtension: "m4a")!),
    MNTrack(id: 2, name: "Rain leaves", thumbnail: "", fullScreen: "Ocean Wave.jpeg", audioUrl: Bundle.main.url(forResource: "a03_rain_leaves", withExtension: "m4a")!),
    MNTrack(id: 3, name: "Fire Place", thumbnail: "", fullScreen: "3", audioUrl: Bundle.main.url(forResource: "a05_fireplace", withExtension: "m4a")!),
    MNTrack(id: 4, name: "Fire Place", thumbnail: "", fullScreen: "4", audioUrl: Bundle.main.url(forResource: "a05_fireplace", withExtension: "m4a")!),
    MNTrack(id: 5, name: "Fire Place", thumbnail: "", fullScreen: "Spring Walk", audioUrl: Bundle.main.url(forResource: "a05_fireplace", withExtension: "m4a")!),
]
