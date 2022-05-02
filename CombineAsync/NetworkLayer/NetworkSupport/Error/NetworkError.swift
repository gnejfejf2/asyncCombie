//
//  NetworkError.swift
//  CombineAsync
//
//  Created by 강지윤 on 2022/05/02.
//

import Foundation

public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case generic(Error)
    case urlGeneration
    case decodeError
}
