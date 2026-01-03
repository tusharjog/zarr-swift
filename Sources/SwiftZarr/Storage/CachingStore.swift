//
//  CachingStore.swift
//  ZarrSwift
//
//  Created by Tushar Jog on 12/30/25.
//
import Foundation

final class LRUCache<Key: Hashable> {
    private let capacity: Int
    private var order: [Key] = []

    init(capacity: Int) {
        self.capacity = capacity
    }

    func touch(_ key: Key) -> Key? {
        order.removeAll { $0 == key }
        order.append(key)
        return order.count > capacity ? order.removeFirst() : nil
    }
}

public final class CachingStore: ComposableZarrStore {
    public let inner: ZarrStore
    private let cache = MemoryStore()
    private let lru: LRUCache<String>
    private let lock = NSLock()

    public init(inner: ZarrStore, capacity: Int = 256) {
        self.inner = inner
        self.lru = LRUCache(capacity: capacity)
    }

    public func get(key: String) throws -> Data? {
        lock.lock()
        if cache.exists(key: key) {
            _ = lru.touch(key)
            let d = try cache.get(key: key)
            lock.unlock()
            return d
        }
        lock.unlock()

        let d = try inner.get(key: key)

        lock.lock()
        if let evicted = lru.touch(key) {
            try? cache.set(key: evicted, value: Data())
        }
        try? cache.set(key: key, value: d!)
        lock.unlock()

        return d
    }

    public func set(key: String, value: Data) throws {
        lock.lock()
        _ = lru.touch(key)
        try? cache.set(key: key, value: value)
        lock.unlock()
        try inner.set(key: key, value: value)
    }

    public func exists(key: String) -> Bool {
        cache.exists(key: key) || inner.exists(key: key)
    }

    public func list(prefix: String?) throws -> [String] {
        Array(Set(try cache.list(prefix: prefix) + inner.list(prefix: prefix)))
    }
    
    public func delete(key: String) throws {
        // TODO
    }
}

