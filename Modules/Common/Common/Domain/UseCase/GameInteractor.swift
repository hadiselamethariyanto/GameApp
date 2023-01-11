//
//  GameInteractor.swift
//  Common
//
//  Created by MuhammadHariyanto on 10/01/23.
//

import Foundation
import Combine

public protocol GameUseCase{
    func getGames() -> AnyPublisher<[Game], Error>
    func getDetailGame(id:String) -> AnyPublisher<Game, Error>
    func setFavorite(game:Game) -> AnyPublisher<Game, Error>
    func getFavorites() -> AnyPublisher<[Game], Error>
    func searchGames(query:String) -> AnyPublisher<[Game], Error>
}

public class GameInteractor:GameUseCase{
    private let repository: GameRepositoryProtocol
    
    public init(repository: GameRepositoryProtocol){
        self.repository = repository
    }
    
    public func getGames() -> AnyPublisher<[Game], Error>{
        repository.getGames()
    }
    
    public func getDetailGame(id: String) -> AnyPublisher<Game, Error> {
        repository.getDetailGame(id: id)
    }
    
    public func setFavorite(game: Game) -> AnyPublisher<Game, Error> {
        repository.setFavorite(game: game)
    }
    
    public func getFavorites() -> AnyPublisher<[Game], Error> {
        repository.getFavorites()
    }
    
    public func searchGames(query: String) -> AnyPublisher<[Game], Error> {
        repository.searchGames(query: query)
    }
    
}
