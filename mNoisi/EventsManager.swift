//
//  EventsManager.swift
//  mNoisi
//
//  Created by yan on 2017/07/18.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import Foundation
import SQLite

protocol EventTable {
    var tableName: String { get }
    var table: Table { get }
    var createTableSQL: String { get }
}

struct EventsManager {
    static public let shared: EventsManager = EventsManager()

    static private let breathEventTable: BreathTable = BreathTable()
    
    static public let tables: [EventTable] = [
        breathEventTable
    ]

    private var db: Connection

    init() {
        do {
            let documentURL = try FileManager.default.url(for: .documentDirectory,
                                                          in: .userDomainMask,
                                                          appropriateFor: nil,
                                                          create: false)
            let dbFileURL = documentURL.appendingPathComponent("_events.db")
            db = try Connection(dbFileURL.path)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    public func setup() {
        do {
            for table in EventsManager.tables {
                try db.run(table.createTableSQL)
            }
        } catch {
            print(error)
        }

        /*
        for table in FNDataBase.tables {
            if let modify = table.modifySQL {
                do {
                    try connection.run(modify)
                } catch {
                    print(error)
                }
            }
        }
         */
    }
}
