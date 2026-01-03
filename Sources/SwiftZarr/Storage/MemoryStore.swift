//
//  MemoryStore.swift
//  ZarrSwift
//
//  Created by Tushar Jog on 12/30/25.
//

// MARK: - Memory Store

import Foundation

public class MemoryStore: ZarrStore {
    private var storage: [String: Data] = [:]
    private let lock = NSLock()
    
    public init() {}
    
    public func get(key: String) throws -> Data? {
        lock.lock()
        defer { lock.unlock() }
        return storage[key]
    }
    
    public func set(key: String, value: Data) throws {
        lock.lock()
        defer { lock.unlock() }
        storage[key] = value
    }
    
    public func delete(key: String) throws {
        lock.lock()
        defer { lock.unlock() }
        storage.removeValue(forKey: key)
    }
    
    public func exists(key: String) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return storage[key] != nil
    }
    
    public func list(prefix: String?) throws -> [String] {
        lock.lock()
        defer { lock.unlock() }
        
        if let prefix = prefix {
            return storage.keys.filter { $0.hasPrefix(prefix) }.sorted()
        }
        return Array(storage.keys).sorted()
    }
}


