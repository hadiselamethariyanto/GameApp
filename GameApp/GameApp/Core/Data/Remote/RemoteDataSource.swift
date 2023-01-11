//
//  RemoteDataSource.swift
//  GameApp
//
//  Created by MuhammadHariyanto on 07/01/23.
//

import Foundation
import Alamofire
import Combine

protocol RemoteDataSourceProtocols: AnyObject{
    func getGames() -> AnyPublisher<[GameResponse], Error>
    func getDetailGame(id:String) -> AnyPublisher<DetailGameResponse, Error>
}


final class RemoteDataSource: NSObject{
    private override init() { }
    
    static let sharedInstance: RemoteDataSource = RemoteDataSource()
}


extension RemoteDataSource: RemoteDataSourceProtocols{
        
    func getGames() -> AnyPublisher<[GameResponse], Error> {
        return Future<[GameResponse], Error>{completion in
            guard let url = URL(string: Endpoints.Gets.games.url) else { return }
            let parameters: Parameters = ["key": API.key]
            AF.request(url, method: .get, parameters: parameters).validate().responseDecodable(of:GameResponses.self){response in
                switch response.result{
                case .success(let value):
                    completion(.success(value.games))
                case .failure:
                    completion(.failure(GameError.networkError))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getDetailGame(id:String) -> AnyPublisher<DetailGameResponse, Error> {
        return Future<DetailGameResponse, Error>{completion in
            guard let url = URL(string: Endpoints.Gets.detail.url+id) else { return }
            let parameters: Parameters = ["key": API.key]
            AF.request(url, method: .get, parameters: parameters).validate().responseDecodable(of:DetailGameResponse.self){response in
                switch response.result{
                case .success(let value):
                    completion(.success(value))
                case .failure:
                    completion(.failure(GameError.networkError))
                }
            }
        }.eraseToAnyPublisher()
    }
}

enum GameError: Error, CustomNSError {
    case networkError
    case apiError
    case decodingError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .networkError: return "No internet connection"
        case .decodingError: return "Failed to decode data"
        }
    }
}
