//
//  ZarrNode.swift
//  ZarrSwift
//
//  Created by Tushar Jog on 12/29/25.
//

import Foundation

public enum ZarrNodeType: String, Codable {
    case group
    case array
}

public protocol ZarrNode {
    var path: String { get }
    var store: ZarrStore { get }
    var nodeType: ZarrNodeType { get }
    
    func isGroup() -> Bool
    func isArray() -> Bool
}

extension ZarrNode {
    public var name : String {
        return path.split(separator: "/").last.map(String.init) ?? ""
    }
}
