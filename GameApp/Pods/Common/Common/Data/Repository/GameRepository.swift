//
//  GameRepository.swift
//  Common
//
//  Created by MuhammadHariyanto on 10/01/23.
//

import Foundation
import Combine

public protocol GameRepositoryProtocol{
    func getGames() -> AnyPublisher<[Game], Error>
    func getDetailGame(id:String) -> AnyPublisher<Game, Error>
    func setFavorite(game:Game) -> AnyPublisher<Game, Error>
    func getFavorites() -> AnyPublisher<[Game], Error>
    func searchGames(query:String) -> AnyPublisher<[Game], Error>
}

public class GameRepository:NSObject{
    private let remote: RemoteDataSource
    private let local: LocalDataSource
    
    public init(local:LocalDataSource, remote: RemoteDataSource){
        self.remote = remote
        self.local = local
    }
        
}


extension GameRepository: GameRepositoryProtocol {
    public func getGames() -> AnyPublisher<[Game], Error> {
        return local.getGames().flatMap{ result -> AnyPublisher<[Game], Error> in
            if result.isEmpty{
                return self.remote.getGames()
                    .map{ GameMapper.mapGameResponseToEntities(input: $0)}
                    .flatMap{ self.local.addGames(from: $0)}
                    .filter{ $0}
                    .flatMap{ _ in self.local.getGames().map{GameMapper.mapGameEntitiesToDomains(input: $0)}
                    }.eraseToAnyPublisher()
            } else{
                return self.local.getGames().map{ GameMapper.mapGameEntitiesToDomains(input: $0)}.eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
    
    public func getDetailGame(id: String) -> AnyPublisher<Game, Error> {
        return local.getGameById(id: id).flatMap{result -> AnyPublisher<Game, Error> in
            if(result?.overview == ""){
                return self.remote.getDetailGame(id: id)
                    .map{ GameMapper.mapGameResponseToEntity(input: $0)}
                    .flatMap{ self.local.addGame(from: $0)}
                    .flatMap{_ in self.local.getGameById(id: id).map{GameMapper.mapGameEntityToDomain(input: $0)}
                    }.eraseToAnyPublisher()
            }else{
                return self.local.getGameById(id: id).map{GameMapper.mapGameEntityToDomain(input:$0)}.eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
    
    public func setFavorite(game: Game) -> AnyPublisher<Game, Error> {
        return local.addGame(from: GameMapper.mapGameDomainToEntity(input: game)).flatMap{result -> AnyPublisher<Game, Error> in
            if(result){
                return self.local.getGameById(id: String(game.id)).map{ GameMapper.mapGameEntityToDomain(input: $0)}.eraseToAnyPublisher()
            }else{
                return self.local.getGameById(id: String(game.id)).map{GameMapper.mapGameEntityToDomain(input: $0)}.eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
    
    public func getFavorites() -> AnyPublisher<[Game], Error> {
        return self.local.getFavorites().map{ GameMapper.mapGameEntitiesToDomains(input: $0)}.eraseToAnyPublisher()
    }
    
    public func searchGames(query: String) -> AnyPublisher<[Game], Error> {
         return remote.searchGames(query: query)
            .map{ GameMapper.mapGameResponseToEntities(input: $0)}
            .flatMap{ self.local.addGames(from: $0)}
            .filter{ $0}
            .flatMap{ _ in self.local.getGames(query: query).map{GameMapper.mapGameEntitiesToDomains(input: $0)}
            }.eraseToAnyPublisher()
    }
}
