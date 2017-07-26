//
//  MeditationEvent.swift
//  mNoisi
//
//  Created by yan on 2017/07/19.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import Foundation
import SQLite

struct MeditationEvent {
    // 2017
    var year: Int
    // 201704
    var month: Int
    // 20170402
    var day: Int
    var startTime: TimeInterval = -1
    var endTime: TimeInterval = -1
    var duration: TimeInterval = -1
    var count: Int = 0

    // 0, 自然点击, 1 手动增加
    var type: Int = 0
    var remark: String = ""
    // user uuid
    var user: String = ""

    init(year: Int, month: Int, day: Int, startTime: TimeInterval, endTime: TimeInterval, duration: TimeInterval, count: Int, type: Int, remark: String, user: String) {
        self.year = year
        self.month = month
        self.day = day
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.count = count
        self.type = type
        self.remark = remark
        self.user = user
    }

    init() {
        self.year = 0
        self.month = 0
        self.day = 0
    }

    init(_ row: Row) {
        let table = EventsManager.meditationEventTable

        year = row[table.colYear]
        month = row[table.colMonth]
        day = row[table.colDay]
        startTime = row[table.colStartTime]
        endTime = row[table.colEndTime]
        duration = row[table.colDuration]
        count = row[table.colCount]
        type = row[table.colType]
        remark = row[table.colRemark]
        user = row[table.colUser]
    }

    mutating func addCount() {
        self.count += 1
    }

    mutating func start() {
        let startDate = Date()
        let components = Calendar(identifier: .gregorian).dateComponents(in: TimeZone.current, from: startDate)
        self.startTime = startDate.timeIntervalSince1970
        self.year = components.year!
        self.month = components.year! * 100 + components.month!
        self.day = components.year! * 10000 + components.month! * 100 + components.day!
    }

    mutating func end(withDuration duration: TimeInterval = -1) {
        self.endTime = Date().timeIntervalSince1970
        self.duration = duration
    }
}
