//
//  RemoteDataSource.swift
//  Common
//
//  Created by MuhammadHariyanto on 10/01/23.
//

import Foundation
import Alamofire
import Combine

public protocol RemoteDataSource :AnyObject{
    func getGames() -> AnyPublisher<[GameResponse], Error>
    func getDetailGame(id:String) -> AnyPublisher<DetailGameResponse, Error>
    func searchGames(query:String) -> AnyPublisher<[GameResponse], Error>
}



public class RemoteDataSourceImpl: RemoteDataSource{
    
    public init() {}
            
    public func getGames() -> AnyPublisher<[GameResponse], Error> {
        return Future<[GameResponse], Error>{completion in
            guard let url = URL(string: Endpoints.Gets.games.url) else { return }
            let parameters: Parameters = ["key": API.key]
            AF.request(url, method: .get, parameters: parameters).validate().responseDecodable(of:GameResponses.self){response in
                switch response.result{
                case .success(let value):
                    completion(.success(value.games))
                case .failure:
                    completion(.failure(GameError.invalidResponse))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func getDetailGame(id:String) -> AnyPublisher<DetailGameResponse, Error> {
        return Future<DetailGameResponse, Error>{completion in
            guard let url = URL(string: Endpoints.Gets.detail.url+id) else { return }
            let parameters: Parameters = ["key": API.key]
            AF.request(url, method: .get, parameters: parameters).validate().responseDecodable(of:DetailGameResponse.self){response in
                switch response.result{
                case .success(let value):
                    completion(.success(value))
                case .failure:
                    completion(.failure(GameError.invalidResponse))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func searchGames(query: String) -> AnyPublisher<[GameResponse], Error> {
        return Future<[GameResponse], Error>{completion in
            guard let url = URL(string: Endpoints.Gets.games.url) else { return }
            let parameters: Parameters = ["key": API.key, "search": query]
            AF.request(url, method: .get, parameters: parameters).validate().responseDecodable(of:GameResponses.self){response in
                switch response.result{
                case .success(let value):
                    completion(.success(value.games))
                case .failure:
                    completion(.failure(GameError.invalidResponse))
                }
            }
        }.eraseToAnyPublisher()
    }
}
