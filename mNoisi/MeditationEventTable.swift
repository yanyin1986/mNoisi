//
//  MeditationEventTable.swift
//  mNoisi
//
//  Created by yan on 2017/07/19.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import Foundation
import SQLite

struct MeditationEventTable: EventTable {
    let colId = Expression<Int64>("id")
    let colYear = Expression<Int>("year")
    let colMonth = Expression<Int>("month")
    let colDay = Expression<Int>("day")
    let colStartTime = Expression<TimeInterval>("startTime")
    let colEndTime = Expression<TimeInterval>("endTime")
    let colDuration = Expression<TimeInterval>("duration")
    let colCount = Expression<Int>("count")
    let colType = Expression<Int>("type")
    let colRemark = Expression<String>("remark")
    let colUser = Expression<String>("user")

    private static let _tableName = "meditation_event"
    var tableName: String {
        return MeditationEventTable._tableName
    }

    private var _table: Table = Table(_tableName)
    var table: Table {
        return _table
    }

    var createTableSQL: String {
        return _table.create(ifNotExists: true, block: { (t) in
            t.column(colId, primaryKey: PrimaryKey.autoincrement)
            t.column(colYear)
            t.column(colMonth)
            t.column(colDay)
            t.column(colStartTime)
            t.column(colEndTime)
            t.column(colDuration)
            t.column(colCount)
            t.column(colType)
            t.column(colRemark)
            t.column(colUser)
        })
    }
}
