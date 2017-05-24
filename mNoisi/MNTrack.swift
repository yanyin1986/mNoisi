//
//  MNTrack.swift
//  mNoisi
//
//  Created by Leon.yan on 24/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import Foundation
import SQLite

struct MNTrack {
    var name: String
    var thumbnail: String
    var fullScreen: String
    var isFavorite: Bool = false
}

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
