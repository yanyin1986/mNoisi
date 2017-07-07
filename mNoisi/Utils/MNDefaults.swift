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
    static let firstLaunch = MNDKey<Bool>("mmd.noisi.firstLaunch")
    static let databaseInitialized = MNDKey<Bool>("mmd.noisi.database_initialized")
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

    subscript(index: MNDKey<String?>) -> String? {
        get { return _ud.string(forKey: index._key) }
        set { _ud.set(newValue, forKey: index._key) }
    }

    subscript(index: MNDKey<Int>) -> Int {
        get { return _ud.integer(forKey: index._key) }
        set { _ud.set(newValue, forKey: index._key) }
    }

}

public var Defaults: MNDefaults = MNDefaults()
