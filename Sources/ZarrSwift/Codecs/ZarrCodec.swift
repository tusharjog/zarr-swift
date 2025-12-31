//
//  ZarrCodec.swift
//  ZarrSwift
//
//  Created by Tushar Jog on 12/29/25.
//
import Foundation

public protocol ZarrCodecProtocol {
    var name: String { get }
    func encode(_ data: Data) throws -> Data
    func decode(_ data: Data) throws -> Data
}

