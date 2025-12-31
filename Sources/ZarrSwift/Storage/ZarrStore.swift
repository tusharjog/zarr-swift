//
//  ZarrStore.swift
//  ZarrSwift
//
//  Created by Tushar Jog on 12/29/25.
//

import Foundation

//
// A Zarr store is a system that can be used to store and retrieve data from a Zarr hierarchy. For a store to be compatible with this specification, it must support a set of operations defined in the Abstract store interface subsection. The store interface can be implemented using a variety of underlying storage technologies, described in the subsection on Store implementations.
//
// https://zarr-specs.readthedocs.io/en/latest/v3/core/index.html#abstract-store-interface
//
public protocol ZarrStore {
    func get(key: String) throws -> Data?
    //func getPartialValues
    func set(key: String, value: Data) throws
    //func setPartialValues
    func delete(key: String) throws
    func exists(key: String) -> Bool
    func list(prefix: String?) throws -> [String]
}

public protocol ComposableZarrStore : ZarrStore {
    var inner : ZarrStore { get }
}
