//
//  ResponseDecoder.swift
//  CombineAsync
//
//  Created by 강지윤 on 2022/05/02.
//

import Foundation

public protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

// MARK: - Response Decoders
public final class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    public init() { }
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        
        do{
            return try jsonDecoder.decode(T.self, from: data)
        }catch{
            throw NetworkError.decodeError
        }
        
        
    }
}
