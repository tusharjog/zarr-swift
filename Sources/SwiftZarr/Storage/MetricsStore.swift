//
//  MetricsStore.swift
//  ZarrSwift
//
//  Created by Tushar Jog on 12/30/25.
//
import Foundation

public final class MetricsStore: ComposableZarrStore {
    public let inner: ZarrStore
    public private(set) var getCount = 0
    private let lock = NSLock()

    public init(inner: ZarrStore) {
        self.inner = inner
    }

    public func get(key: String) throws -> Data? {
        lock.lock(); getCount += 1; lock.unlock()
        return try inner.get(key: key)
    }

    public func set(key: String, value: Data) throws {
        try inner.set(key: key, value: value)
    }

    public func exists(key: String) -> Bool {
        inner.exists(key: key)
    }

    public func list(prefix: String?) throws -> [String] {
        try inner.list(prefix: prefix)
    }
    
    public func delete(key: String) throws {
        return try inner.delete(key: key)
    }
}

