//
//  MNDB.swift
//  mNoisi
//
//  Created by Leon.yan on 17/06/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import Foundation
import SQLite


public struct MNDB {
    public static let shared: MNDB = MNDB()

    private let trackTable: Table = Table("track")
    private var _db: Connection

    private init() {
        guard let docUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError("Error when init document directory")
        }

        let dbUrl = docUrl.appendingPathComponent("noisi.sqlite")
        do {
            _db = try Connection(dbUrl.path)
        } catch {
            fatalError("Error when init db connection: \(error)")
        }

        if Defaults[.databaseInitialized] == false {
            Defaults[.databaseInitialized] = true
            self.initialize()
        }
    }

    private func initialize() {
        do {
            let create = trackTable.create(temporary: false, ifNotExists: true, block: { (t) in
                t.column(Expression<Int64>("id"), primaryKey: true)
                t.column(Expression<String>("name"))
                t.column(Expression<String>("thumb_image"))
                t.column(Expression<String>("full_image"))
                t.column(Expression<String>("audio_url"))
                t.column(Expression<Bool>("favor"))
            })

            try _db.execute(create)

            trackTable.insert(<#T##values: [Setter]##[Setter]#>)
        } catch {
            fatalError("Error when initialize db: \(error)")
        }
    }
}
