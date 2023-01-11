//
//  GameInteractor.swift
//  GameApp
//
//  Created by MuhammadHariyanto on 07/01/23.
//

import Foundation
import Combine

protocol GameUseCase{
    func getGames() -> AnyPublisher<[Game], Error>
    func getDetailGame(id:String) -> AnyPublisher<Game, Error>
    func setFavorite(game:Game) -> AnyPublisher<Game, Error>
    func getFavorites() -> AnyPublisher<[Game], Error>
}

class GameInteractor:GameUseCase{
    private let repository: GameRepositoryProtocol
    
    required init(repository: GameRepositoryProtocol){
        self.repository = repository
    }
    
    func getGames() -> AnyPublisher<[Game], Error>{
        repository.getGames()
    }
    
    func getDetailGame(id: String) -> AnyPublisher<Game, Error> {
        repository.getDetailGame(id: id)
    }
    
    func setFavorite(game: Game) -> AnyPublisher<Game, Error> {
        repository.setFavorite(game: game)
    }
    
    func getFavorites() -> AnyPublisher<[Game], Error> {
        repository.getFavorites()
    }
    
}
