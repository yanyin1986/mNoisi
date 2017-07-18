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
    
}

struct EventsManager {
    static public let shared: EventsManager = EventsManager()
    static public let tables: [EventTable] = [
        
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
        guard let connection = try? Connection(self.dbFileURL.path) else {
            return
        }

        do {
            for table in FNDataBase.tables {
                try connection.run(table.createTableSQL)
            }
        } catch {
            print(error)
        }

        for table in FNDataBase.tables {
            if let modify = table.modifySQL {
                do {
                    try connection.run(modify)
                } catch {
                    print(error)
                }
            }
        }
    }
}
