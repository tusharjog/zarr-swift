//
//  ZarrDataType.swift
//  ZarrDataType
//
//  Created by Tushar Jog on 12/24/25.
//
import Foundation

public enum ZarrDataType: Codable, Equatable, Sendable {
    case string(String)
    case number(Double)
    case bool(Bool)
    case array([ZarrDataType])
    case dictionary([String: ZarrDataType])
    case null

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if container.decodeNil() {
            self = .null
        }
        else if let x = try? container.decode(String.self)   {
            self = .string(x)
        }
        else if let x = try? container.decode(Bool.self)   {
            self = .bool(x)
        }
        else if let x = try? container.decode(Double.self)   {
            self = .number(x)
        }
        else if let x = try? container.decode([ZarrDataType].self)   {
            self = .array(x)
        }
        else if let x = try? container.decode([String: ZarrDataType].self)   {
            self = .dictionary(x)
        }
        else {
            //throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid JSON value")
            throw ZarrError.unsupportedDataType("Unknown data type: \(container)")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .null:
            try container.encodeNil()
        case .string(let x):
            try container.encode(x)
        case .number(let x):
            try container.encode(x)
        case .bool(let x):
            try container.encode(x)
        case .array(let x):
            try container.encode(x)
        case .dictionary(let x):
            try container.encode(x)
        }
    }
}

//
// Convenience initializers for ZarrDataType
//
extension ZarrDataType : ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .null
    }
}

extension ZarrDataType : ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        //self = value ? .customMirror("b") : .null
        self = .bool(value)
    }
}

// TODO add more


// Convenience accessors
extension ZarrDataType {
    public var boolValue: Bool? {
        if case .bool(let v) = self {
            return v
        } else {
            return nil
        }
    }
}

// TODO add more

extension ZarrDataType {
    public var isNull: Bool {
        self == .null
    }
}
