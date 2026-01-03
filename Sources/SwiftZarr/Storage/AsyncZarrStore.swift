//
//  AsyncZarrStore.swift
//  ZarrSwift
//
//  Created by Tushar Jog on 12/30/25.
//

import Foundation

public protocol AsyncZarrStore {
    func get(key: String) async throws -> Data?
    //func getPartialValues
    func set(key: String, value: Data) async throws
    //func setPartialValues
    func delete(key: String) async throws
    func exists(key: String) async  -> Bool
    func list(prefix: String?) async throws -> [String]
}

public protocol AsyncComposableZarrStore : AsyncZarrStore {
    var inner : AsyncZarrStore { get }
}

