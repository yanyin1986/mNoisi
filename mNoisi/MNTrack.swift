//
//  MNTrack.swift
//  mNoisi
//
//  Created by Leon.yan on 24/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import Foundation
import SQLite

public struct MNTrack {
    var name: String
    var thumbnail: String
    var fullScreen: String
    var isFavorite: Bool = false
    var audioUrl: URL
}

public let tracks: [MNTrack] = [
    MNTrack(name: "Mountain", thumbnail: "", fullScreen: "2817564516891261945", isFavorite: false, audioUrl: Bundle.main.url(forResource: "a01_mountain_lake", withExtension: "m4a")!),
    MNTrack(name: "Rain leaves", thumbnail: "", fullScreen: "Ocean Wave.jpeg", isFavorite: false, audioUrl: Bundle.main.url(forResource: "a03_rain_leaves", withExtension: "m4a")!),
    MNTrack(name: "Fire Place", thumbnail: "", fullScreen: "", isFavorite: false, audioUrl: Bundle.main.url(forResource: "a05_fireplace", withExtension: "m4a")!),
]

struct MNTrackTable {
    private static var colName: Expression<String> = Expression<String>("name")
    private static var colThumbnail: Expression<String> = Expression<String>("thumbnail")
    private static var colFullScreen: Expression<String> = Expression<String>("fullScreen")
    private static var colFavorite: Expression<Bool> = Expression<Bool>("favorite")

    public lazy var createSQL: String = {
        let table = Table("track")
        return table.create(temporary: false,
                            ifNotExists: true,
                            block: { (builder) in
                                builder.column(colName)
                                builder.column(colThumbnail)
                                builder.column(colFullScreen)
                                builder.column(colFavorite)
        })
    }()
}
