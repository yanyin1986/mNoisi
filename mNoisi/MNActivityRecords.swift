//
//  MNActivityRecords.swift
//  mNoisi
//
//  Created by Leon.yan on 31/05/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import Foundation
import SQLite

struct ActivityRecords {
    static public let shared: ActivityRecords = ActivityRecords()
    /// 1 => natural sound, 2 => breath, 3 => meditation
    static private let colType = Expression<Int>("type")
    /// record time
    static private let colTime = Expression<TimeInterval>("time")
    /// duration time
    static private let colDuration = Expression<TimeInterval>("duration")
    /// audio name
    static private let colResource = Expression<String>("resource")

    private var db: Connection
    private var table: Table

    private init() {
        self.table = Table("activity_records")
        let create = self.table.create(temporary: false, ifNotExists: true, block: { (t) in
            t.column(Expression<Int64>("id"), primaryKey: PrimaryKey.autoincrement)
            t.column(ActivityRecords.colType)
            t.column(ActivityRecords.colTime)
            t.column(ActivityRecords.colDuration)
            t.column(ActivityRecords.colResource)
        })
        do {
            self.db = try Connection()
            try self.db.execute(create)
        } catch {
            fatalError("error when init db")
        }
    }

    public func insert(type: Int, duration: TimeInterval = -1, recourse: String = "default") {
        let insert = self.table.insert(ActivityRecords.colType <- type,
                                       ActivityRecords.colTime <- Date().timeIntervalSince1970,
                                       ActivityRecords.colDuration <- duration,
                                       ActivityRecords.colResource <- recourse)
        do {
            try self.db.run(insert)
        } catch {
            debugPrint("error when insert record")
        }
    }
}
