//
//  S3Store.swift
//  ZarrSwift
//
//  Created by Tushar Jog on 12/30/25.
//

import Foundation

public final class S3Store: ZarrStore {
    private let bucket: String
    private let region: String

    public init(bucket: String, region: String) {
        self.bucket = bucket
        self.region = region
    }

    private func url(for path: String) -> URL {
        URL(string: "https://\(bucket).s3.\(region).amazonaws.com/\(path)")!
    }

    public func get(key: String) throws -> Data? {
        return try Data(contentsOf: url(for: key))
    }

    public func set(key: String, value: Data) throws {
        throw NSError(domain: "S3Store", code: 1)
    }

    public func exists(key: String) -> Bool {
        (try? Data(contentsOf: url(for: key))) != nil
    }

    public func list(prefix: String?) throws -> [String] {
        throw NSError(domain: "S3Store", code: 2)
    }
    
    public func delete(key: String) throws {
        throw NSError(domain: "S3Store", code: 3)
    }
}

