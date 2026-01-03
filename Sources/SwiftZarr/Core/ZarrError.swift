import Foundation

// MARK: - Error Types

public enum ZarrError : Error, CustomStringConvertible {
    case missingMetaData(String)
    case invalidNodeType(String)
    case unsupportedCodec(String)
    case invalidMetadata(String)
    case invalidPath(String)
    case chunkNotFound(String)
    case encodingError(String)
    case decodingError(String)
    case unsupportedDataType(String)
    case dimensionMismatch(String)
    case fileSystemError(String)
    case codecError(String)
    case storeError(String)
    case invalidFillValue(String)

    public var description : String {
        switch self {
            case .missingMetaData(let msg): return "Did not find any meta data: \(msg)"
            case .invalidNodeType(let msg): return "Invalid node type: \(msg)"
            case .unsupportedCodec(let msg): return "Unsupported codec: \(msg)"
            case .invalidMetadata(let msg): return "Invalid metadata: \(msg)"
            case .invalidPath(let msg): return "Invalid path: \(msg)"
            case .chunkNotFound(let msg): return "Chunk not found: \(msg)"
            case .encodingError(let msg): return "Encoding error: \(msg)"
            case .decodingError(let msg): return "Decoding error: \(msg)"
            case .unsupportedDataType(let msg): return "Unsupported data type: \(msg)"
            case .dimensionMismatch(let msg): return "Dimension mismatch: \(msg)"
            case .fileSystemError(let msg): return "File system error: \(msg)"
            case .codecError(let msg): return "Codec error: \(msg)"
            case .storeError(let msg): return "Store error: \(msg)"
            case .invalidFillValue(let msg) : return "Invalid fill value: \(msg)"
        }
    }
}

