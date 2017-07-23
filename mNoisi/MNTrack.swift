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
        MNTrack(id: 1, name: "Summer Pond",
                thumbnail: "fairypond",
                fullScreen: "fairypond",
                audioUrl: Bundle.main.url(forResource: "a1", withExtension: "mp3")!),
        MNTrack(id: 2, name: "Crackling Fire",
                thumbnail: "crackling_fire_sound",
                fullScreen: "crackling_fire_sound",
                audioUrl: Bundle.main.url(forResource: "a2", withExtension: "mp3")!),
        MNTrack(id: 3, name: "Thunderstorm",
                thumbnail: "distantthunder",
                fullScreen: "distantthunder",
                audioUrl: Bundle.main.url(forResource: "a3", withExtension: "mp3")!),
        MNTrack(id: 4, name: "Forest Rain",
                thumbnail: "tropicalrain",
                fullScreen: "tropicalrain",
                audioUrl: Bundle.main.url(forResource: "a4", withExtension: "mp3")!),
        MNTrack(id: 5, name: "Heavy Rain",
                thumbnail: "whiterain",
                fullScreen: "whiterain",
                audioUrl: Bundle.main.url(forResource: "a5", withExtension: "mp3")!),
        MNTrack(id: 6, name: "Snowstrom",
                thumbnail: "skywalker",
                fullScreen: "skywalker",
                audioUrl: Bundle.main.url(forResource: "a6", withExtension: "mp3")!),
        MNTrack(id: 7, name: "Camping Crickets",
                thumbnail: "camping_crickets",
                fullScreen: "camping_crickets",
                audioUrl: Bundle.main.url(forResource: "a7", withExtension: "mp3")!),
        MNTrack(id: 8, name: "Nightfall Birds",
                thumbnail: "skywalker",
                fullScreen: "skywalker",
                audioUrl: Bundle.main.url(forResource: "a8", withExtension: "mp3")!),
        MNTrack(id: 9, name: "Morning Pigeons",
                thumbnail: "city_pigeons",
                fullScreen: "city_pigeons",
                audioUrl: Bundle.main.url(forResource: "a9", withExtension: "mp3")!),
        MNTrack(id: 10, name: "City Airplane",
                thumbnail: "city_plane",
                fullScreen: "city_plane",
                audioUrl: Bundle.main.url(forResource: "a10", withExtension: "mp3")!),
        MNTrack(id: 11, name: "Forest Birds",
                thumbnail: "forest",
                fullScreen: "forest",
                audioUrl: Bundle.main.url(forResource: "a11", withExtension: "mp3")!),
        MNTrack(id: 12, name: "Music Box",
                thumbnail: "musicbox",
                fullScreen: "musicbox",
                audioUrl: Bundle.main.url(forResource: "a12", withExtension: "mp3")!),
        MNTrack(id: 13, name: "Stream",
                thumbnail: "water",
                fullScreen: "water",
                audioUrl: Bundle.main.url(forResource: "a13", withExtension: "mp3")!),
        ]

    public var liked: [MNTrack] {
        var trackList = [MNTrack]()
        let liked = likedTracks.sorted { (id0, id1) -> Bool in
            return id0 < id1
        }
        for id in liked {
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
