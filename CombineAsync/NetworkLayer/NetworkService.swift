//
//  NetworkService.swift
//  CombineAsync
//
//  Created by 강지윤 on 2022/05/02.
//

import Foundation

protocol NetworkProtocol{
    
    func requeest<T: Decodable>(type : T.Type , _ endpoint : Requestable) async throws -> T
    
}

final class NetworkService : NetworkProtocol{
    
    private let config : NetworkConfigurable
    private let decoder : ResponseDecoder
    private let session : SessionProtocol
    public init(
        config : NetworkConfigurable ,
        decoder : ResponseDecoder = JSONResponseDecoder() ,
        session : SessionProtocol = DefaultSession()
    ){
        self.config = config
        self.decoder = decoder
        self.session = session
    }
    
    func requeest<T: Decodable>(type : T.Type ,  _ endpoint: Requestable) async throws -> T {
        
        
        let request : URLRequest = try endpoint.urlRequest(with: config)
        
        let (data , response) = try await session.request(request)
        
        guard let urlResponse = response as? HTTPURLResponse else { throw NetworkError.notConnected }
        
        guard urlResponse.statusCode == 200 else { throw NetworkError.error(statusCode: urlResponse.statusCode , data: data) }

        let result : T = try decoder.decode(data)
        
        return result
    }
}

protocol SessionProtocol {
    typealias Response = (Data, URLResponse)
    func request(_  urlRequest : URLRequest) async throws -> Response
}

final class DefaultSession : SessionProtocol{
    
    func request(_ urlRequest: URLRequest) async throws -> Response {
        do{
            return try await URLSession.shared.data(for: urlRequest)
        }catch{
            throw errorResolve(error: error)
        }
    }
    
    private func errorResolve(error: Error) -> Error {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet : return NetworkError.notConnected
        default : return error
        }
    }
}
