//
//  BreathEvent.swift
//  mNoisi
//
//  Created by yan on 2017/07/18.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import Foundation
import SQLite

struct BreathEvent {
    // 2017
    private var year: Int
    // 201704
    private var month: Int
    // 20170402
    private var day: Int
    private var startTime: TimeInterval = -1
    private var endTime: TimeInterval = -1
    private var duration: TimeInterval = -1
    private var count: Int = 0

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

    mutating func end() {
        let endDate = Date()
        self.endTime = endDate.timeIntervalSince1970
        self.duration = endTime - startTime
    }
}

struct BreathTable {
    let colId = Expression<Int64>("id")
    let colYear = Expression<Int>("year")
    let colMonth = Expression<Int>("month")
    let colDay = Expression<Int>("day")
    let colStartTime = Expression<TimeInterval>("startTime")
    let colEndTime = Expression<TimeInterval>("endTime")
    let colDuration = Expression<TimeInterval>("duration")
    let colCount = Expression<Int>("count")
}


