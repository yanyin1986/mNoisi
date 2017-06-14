//
//  MNTrack.swift
//  mNoisi
//
//  Created by Leon.yan on 24/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import Foundation

public struct MNTrack /*: Codable*/ {
    var id: Int64
    var name: String
    var thumbnail: String
    var fullScreen: String
    var audioUrl: URL
}



public class MNTrackManager {
    public static let shared: MNTrackManager = MNTrackManager()
    private static let kLikedTracks = "likedTracks"
    public let tracks: [MNTrack] = [
        MNTrack(id: 1, name: "Mountain", thumbnail: "", fullScreen: "2817564516891261945", audioUrl: Bundle.main.url(forResource: "a01_mountain_lake", withExtension: "m4a")!),
        MNTrack(id: 2, name: "Rain leaves", thumbnail: "", fullScreen: "Ocean Wave.jpeg", audioUrl: Bundle.main.url(forResource: "a03_rain_leaves", withExtension: "m4a")!),
        MNTrack(id: 3, name: "Fire Place", thumbnail: "", fullScreen: "3", audioUrl: Bundle.main.url(forResource: "a05_fireplace", withExtension: "m4a")!),
        MNTrack(id: 4, name: "Fire Place", thumbnail: "", fullScreen: "4", audioUrl: Bundle.main.url(forResource: "a05_fireplace", withExtension: "m4a")!),
        MNTrack(id: 5, name: "Fire Place", thumbnail: "", fullScreen: "Spring Walk", audioUrl: Bundle.main.url(forResource: "a05_fireplace", withExtension: "m4a")!),
        ]

    public var liked: [MNTrack] {
        var trackList = [MNTrack]()
        for id in likedTracks {
            if let track = tracks.first(where: { $0.id == id }) {
                trackList.append(track)
            }
        }

        return trackList
    }

    private var likedTracks: [Int64] = []
    private init() {
        if let array = UserDefaults.standard.array(forKey: MNTrackManager.kLikedTracks) as? [Int64] {
            self.likedTracks.append(contentsOf: array)
        }
    }

    public func like(track: MNTrack) {
        guard self.isTrackLiked(track) == false else {
            return
        }
        self.likedTracks.append(track.id)
        UserDefaults.standard.set(self.likedTracks, forKey: MNTrackManager.kLikedTracks)
        UserDefaults.standard.synchronize()
    }

    public func unlike(track: MNTrack) {
        guard let index = self.likedTracks.index(of: track.id) else {
            return
        }
        self.likedTracks.remove(at: index)
        UserDefaults.standard.set(self.likedTracks, forKey: MNTrackManager.kLikedTracks)
        UserDefaults.standard.synchronize()
    }

    public func isTrackLiked(_ track: MNTrack) -> Bool {
        return self.likedTracks.first(where: { $0 == track.id }) != nil
    }
}
