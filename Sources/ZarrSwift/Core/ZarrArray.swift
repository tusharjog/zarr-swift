//
//  ZarrArray.swift
//  ZarrSwift
//
//  Created by Tushar Jog on 12/29/25.
//

import Foundation

public class ZarrArray : ZarrNode {
    public func isGroup() -> Bool {
        return false
    }
    
    public func isArray() -> Bool {
        return true
    }
    
    public var path: String
    public var store: ZarrStore
    public var nodeType: ZarrNodeType
    public var metadata: ZarrArrayMetaData
    
    private init(store: ZarrStore, path: String, metadata: ZarrArrayMetaData) throws {
        self.path = path
        self.store = store
        self.metadata = metadata
        self.nodeType = .array
    }
    
    public static func create(store: ZarrStore, path: String, metadata: ZarrArrayMetaData) throws -> ZarrArray {
        let metadataKey = path.isEmpty ? DEFAULT_META_KEY : "\(path)/\(DEFAULT_META_KEY)"
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let jsondata = try? encoder.encode(metadata) {
            try store.set(key: metadataKey, value: jsondata)
            print(metadataKey)
            print(String(data: jsondata, encoding: .utf8)!)
        }
        
        return try ZarrArray(store: store, path: path, metadata: metadata)
    }
    
    public static func create(store: ZarrStore, path: String,
                              shape: [Int], dataType: ZarrDataType, chunkGrid: ZarrChunkGrid, chunkKeyEncoding: ZarrChunkKeyEncoding, fillValue: FillValue, codecs: [ZarrCodecConfiguration], attributes: [String : JSONValue]?, dimensionNames: [String]?) throws -> ZarrArray {
        let metadata = ZarrArrayMetaData(shape:shape, dataType: dataType, chunkGrid: chunkGrid, chunkKeyEncoding: chunkKeyEncoding, fillValue: fillValue, codecs: codecs, attributes: attributes, dimensionNames: dimensionNames)
        
        return try ZarrArray(store: store, path: path, metadata: metadata)
    }
    
    // Opens existing group - reads metadata from store
    public static func open(store: ZarrStore, path : String) throws -> ZarrArray {
        let metadataKey = path.isEmpty ? DEFAULT_META_KEY : "\(path)/\(DEFAULT_META_KEY)"
        guard let jsonData = try store.get(key: metadataKey) else {
            throw ZarrError.invalidPath("Metadata not found at \(metadataKey)")
        }
        
        let decoder = JSONDecoder()
        let metadata = try decoder.decode(ZarrArrayMetaData.self, from: jsonData)
        
        // Create instance (no writing)
        return try ZarrArray(store: store, path: path, metadata: metadata)
    }
    
    private func chunkKey(for indices: [Int]) -> String {
        let key = metadata.chunkKeyEncoding.encodeKey(indices)
        return path.isEmpty ? key : "\(path)/\(key)"
    }
}

extension ZarrArray {
    internal func decompress(_ data: Data) throws -> Data {
        let chunkShape = metadata.chunkGrid.chunkShape
        let elementCount = chunkShape.reduce(1, *)
        let expectedSize = elementCount * MemoryLayout<UInt8>.size // TODO Change this to use ZarrDataType
        var processedData = data
        
        // 🛠️ Map the JSON configurations to executable Codec objects
        // If metadata stores [CodecConfiguration], convert them now:
        let executableCodecs = try metadata.codecs.map {
            try CodecFactory.create(from: $0)
        }
        
        // Apply in reverse for decoding
        for codec in executableCodecs.reversed() {
            processedData = try codec.decode(processedData, expectedSize: expectedSize)
        }
        
        return processedData
    }
}
