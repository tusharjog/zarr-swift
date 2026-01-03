//
//  ZarrDataType.swift
//  ZarrDataType
//
//  Created by Tushar Jog on 12/24/25.
//
import Foundation

//
// https://zarr-specs.readthedocs.io/en/latest/v3/data-types/index.html
//

// MARK: - Data Types

public enum ZarrDataType: Codable, Equatable {
    case bool // A byte aligned bit, per Zarr version 3
    case int8
    case int16
    case int32
    case int64
    case uint8
    case uint16
    case uint32
    case uint64
    case float32
    case float64
    case complex64  // float32 real + float32 imaginary
    case complex128 // float64 real + float64 imaginary
    case string
    case fixedString(Int)
    case raw(Int) // Raw bytes (r followed by bits)
    
    var isNumeric: Bool {
        switch self {
        case .string, .fixedString, .raw: return false
        default: return true
        }
    }
    
    var byteSize: Int? {
        switch self {
        case .bool : return 1
        case .int8, .uint8: return 1
        case .int16, .uint16: return 2
        case .int32, .uint32, .float32: return 4
        case .int64, .uint64, .float64, .complex64: return 8
        case .complex128: return 16
        case .fixedString(let size): return size / 8
        case .raw(let bits): return bits / 8
        case .string: return nil
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let typeString = try container.decode(String.self)
        
        switch typeString {
        case "int8": self = .int8
        case "int16": self = .int16
        case "int32": self = .int32
        case "int64": self = .int64
        case "uint8": self = .uint8
        case "uint16": self = .uint16
        case "uint32": self = .uint32
        case "uint64": self = .uint64
        case "float32": self = .float32
        case "float64": self = .float64
        case "complex64": self = .complex64
        case "complex128": self = .complex128
        case "string": self = .string
        default:
            if typeString.hasPrefix("r") || typeString.hasPrefix("S") {
                if let size = Int(typeString.dropFirst()) {
                    self = typeString.hasPrefix("r") ? .raw(size) : .fixedString(size)
                } else {
                    throw ZarrError.unsupportedDataType("Invalid format: \(typeString)")
                }
            } else {
                throw ZarrError.unsupportedDataType("Unknown data type: \(typeString)")
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool: try container.encode("bool")
        case .int8: try container.encode("int8")
        case .int16: try container.encode("int16")
        case .int32: try container.encode("int32")
        case .int64: try container.encode("int64")
        case .uint8: try container.encode("uint8")
        case .uint16: try container.encode("uint16")
        case .uint32: try container.encode("uint32")
        case .uint64: try container.encode("uint64")
        case .float32: try container.encode("float32")
        case .float64: try container.encode("float64")
        case .complex64: try container.encode("complex64")
        case .complex128: try container.encode("complex128")
        case .string: try container.encode("string")
        case .fixedString(let size): try container.encode("S\(size)")
        case .raw(let bits): try container.encode("r\(bits)")
        }
    }
}


