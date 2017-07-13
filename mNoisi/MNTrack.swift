//
//  MNTrack.swift
//  mNoisi
//
//  Created by Leon.yan on 24/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import Foundation
import SQLite

public struct MNTrack: Equatable /*: Codable*/ {
    var id: Int64
    var name: String
    var thumbnail: String
    var fullScreen: String
    var audioUrl: URL

    public static func ==(lhs: MNTrack, rhs: MNTrack) -> Bool {
        return lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.thumbnail == rhs.thumbnail
            && lhs.fullScreen == rhs.fullScreen
            && lhs.audioUrl == rhs.audioUrl
    }
}

public class MNTrackManager {
    public static let shared: MNTrackManager = MNTrackManager()
    private static let kLikedTracks = "likedTracks"
    public let tracks: [MNTrack] = [
        MNTrack(id: 1, name: "White Rain",
                thumbnail: "",
                fullScreen: "whiterain.jpg",
                audioUrl: Bundle.main.url(forResource: "whiterain", withExtension: "mp3")!),
        MNTrack(id: 2, name: "Tropical Rain",
                thumbnail: "",
                fullScreen: "tropicalrain.jpg",
                audioUrl: Bundle.main.url(forResource: "tropicalrain", withExtension: "mp3")!),
        MNTrack(id: 3, name: "Skywalker",
                thumbnail: "",
                fullScreen: "skywalker.jpg",
                audioUrl: Bundle.main.url(forResource: "skywalker", withExtension: "mp3")!),
        MNTrack(id: 4, name: "Fairypond",
                thumbnail: "",
                fullScreen: "fairypond.jpg",
                audioUrl: Bundle.main.url(forResource: "fairypond", withExtension: "mp3")!),
        MNTrack(id: 5, name: "Distant Thunder",
                thumbnail: "",
                fullScreen: "distantthunder.jpg",
                audioUrl: Bundle.main.url(forResource: "distantthunder", withExtension: "mp3")!),
        MNTrack(id: 6, name: "Crackling Fire Sound",
                thumbnail: "",
                fullScreen: "crackling_fire_sound.jpg",
                audioUrl: Bundle.main.url(forResource: "crackling_fire_sound", withExtension: "mp3")!),
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
        return likedTracks.contains(track.id)
    }
}
