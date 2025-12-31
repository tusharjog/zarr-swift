//
//  ZarrGroup.swift
//  ZarrSwift
//
//  Created by Tushar Jog on 12/30/25.
//

import Foundation


public class ZarrGroup : ZarrNode {
    public func isGroup() -> Bool {
        return true
    }
    
    public func isArray() -> Bool {
        return false
    }
    
    public var path: String
    public var store: ZarrStore
    public var nodeType: ZarrNodeType
    public var metadata: ZarrGroupMetaData
    
    public init(path: String, store: ZarrStore, metadata:ZarrGroupMetaData) throws {
        self.path = path
        self.store = store
        self.nodeType = .group
        self.metadata = metadata
        
        let metadataKey = path.isEmpty ? DEFAULT_META_KEY : "\(path)/\(DEFAULT_META_KEY)"
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let jsondata = try? encoder.encode(metadata) {
            try self.store.set(key: metadataKey, value: jsondata)
        }
    }
}
