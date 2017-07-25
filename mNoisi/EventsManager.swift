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

    static public let breathEventTable: BreathEventTable = BreathEventTable()
    static public let meditationEventTable: MeditationEventTable = MeditationEventTable()
    
    static public let tables: [EventTable] = [
        breathEventTable,
        meditationEventTable,
    ]

    fileprivate var db: Connection

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
            debugPrint(error.localizedDescription)
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

// MARK: breath event
extension EventsManager {
    
    func insert(_ breathEvent: BreathEvent) {
        let table = EventsManager.breathEventTable

        let insert = table.table.insert(
            table.colYear      <- breathEvent.year,
            table.colMonth     <- breathEvent.month,
            table.colDay       <- breathEvent.day,
            table.colStartTime <- breathEvent.startTime,
            table.colEndTime   <- breathEvent.endTime,
            table.colDuration  <- breathEvent.duration,
            table.colCount     <- breathEvent.count,
            table.colType      <- breathEvent.type,
            table.colRemark    <- breathEvent.remark,
            table.colUser      <- breathEvent.user)

        
        do {
            try self.db.run(insert)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    func lastBreathEvent() -> BreathEvent? {
        let table = EventsManager.breathEventTable
        let query = table.table.order(table.colStartTime.desc).limit(1)

        do {
            let results = try self.db.prepare(query)
            var event: BreathEvent?
            for row in results {
                event = BreathEvent(row)
                break
            }
            return event
        } catch {
            return nil
        }
    }

    func breathEvnets(forDay: Int) -> [BreathEvent] {
        let table = EventsManager.breathEventTable
        let query = table.table.filter(table.colDay == forDay)

        var events = [BreathEvent]()
        do {
            
            let results = try db.prepare(query)
            for row in results {
                events.append(BreathEvent(row))
            }
        } catch {

        }

        return events
    }

    func breathDuration(forDay: Int) -> TimeInterval {
        return self.breathEvnets(forDay: forDay).reduce(TimeInterval(0), { $0.0 + $0.1.duration })
    }

    func countBreathEvents(forDay: Int) -> Int {
        let table = EventsManager.breathEventTable
        let query = table.table.filter(table.colDay == forDay).count

        do {
            return try db.scalar(query)
        } catch {
            return 0
        }
    }
}

// MARK: meditation event
extension EventsManager {

    func insert(_ meditationEvent: MeditationEvent) {
        let table = EventsManager.meditationEventTable

        let insert = table.table.insert(
            table.colYear      <- meditationEvent.year,
            table.colMonth     <- meditationEvent.month,
            table.colDay       <- meditationEvent.day,
            table.colStartTime <- meditationEvent.startTime,
            table.colEndTime   <- meditationEvent.endTime,
            table.colDuration  <- meditationEvent.duration,
            table.colType      <- meditationEvent.type,
            table.colRemark    <- meditationEvent.remark,
            table.colUser      <- meditationEvent.user)
        do {
            try self.db.run(insert)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    func lastMeditationEvent() -> MeditationEvent? {
        let table = EventsManager.meditationEventTable
        let query = table.table.order(table.colDay.desc).limit(1)

        do {
            let results = try self.db.prepare(query)
            guard let record = results.makeIterator().next() else {
                return nil
            }
            let event = MeditationEvent(record)
            return event
        } catch {
            return nil
        }
    }

    func meditationEvnets(forDay: Int) -> [MeditationEvent] {
        let table = EventsManager.meditationEventTable
        let query = table.table.filter(table.colDay == forDay)

        var events = [MeditationEvent]()
        do {

            let results = try db.prepare(query)
            for row in results {
                events.append(MeditationEvent(row))
            }
        } catch {

        }

        return events
    }

    func meditationDuration(forDay: Int) -> TimeInterval {
        return self.meditationEvnets(forDay: forDay).reduce(TimeInterval(0), { $0.0 + $0.1.duration })
    }

    func countMeditationEvents(forDay: Int) -> Int {
        let table = EventsManager.breathEventTable
        let query = EventsManager.breathEventTable.table.filter(table.colDay == forDay).count

        do {
            return try db.scalar(query)
        } catch {
            return 0
        }
    }
}
