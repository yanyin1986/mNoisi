//
//  MNDefaults.swift
//  mNoisi
//
//  Created by Leon.yan on 17/06/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import Foundation

open class MNDefaultsKeys {
    fileprivate init() {}
}

open class MNDKey<ValueType>: MNDefaultsKeys {
    fileprivate let _key: String
    init(_ key: String) {
        _key = key
    }
}

extension MNDefaultsKeys {
    static let firstLaunch         = MNDKey<Bool>("mmd.noisi.firstLaunch")
    static let databaseInitialized = MNDKey<Bool>("mmd.noisi.database_initialized")
    static let lastPlayedMusicId   = MNDKey<Int64>("mmd.noisi.last_played_music_id")
    static let playerVolume        = MNDKey<Float>("mmd.noisi.player_volume")
    static let lastBreathTime      = MNDKey<Int>("mmd.noisi.last_breath_time")
    static let lastMeditationTime  = MNDKey<Int>("mmd.noisi.last_meditation_time")
}


public struct MNDefaults {
    private var _ud: UserDefaults
    fileprivate init() {
        _ud = UserDefaults.standard
    }

    subscript(index: MNDKey<Bool>) -> Bool {
        get { return _ud.bool(forKey: index._key) }
        set { _ud.set(newValue, forKey: index._key) }
    }

    subscript(index: MNDKey<String>) -> String? {
        get { return _ud.string(forKey: index._key) }
        set { _ud.set(newValue, forKey: index._key) }
    }

    subscript(index: MNDKey<Int>) -> Int? {
        get {
            if _ud.object(forKey: index._key) == nil {
                return nil
            } else {
                return _ud.integer(forKey: index._key)
            }
        }
        set { _ud.set(newValue, forKey: index._key) }
    }

    subscript(index: MNDKey<Int64>) -> Int64? {
        get {
            if _ud.object(forKey: index._key) == nil {
                return nil
            } else {
                return Int64(_ud.integer(forKey: index._key))
            }
        }
        set { _ud.set(newValue, forKey: index._key) }
    }

    subscript(index: MNDKey<Float>) -> Float? {
        get {
            if _ud.object(forKey: index._key) == nil {
                return nil
            } else {
                return _ud.float(forKey: index._key)
            }
        }
        set { _ud.set(newValue, forKey: index._key) }
    }

    public func sync() {
        _ud.synchronize()
    }

}

public var Defaults: MNDefaults = MNDefaults()
