//
//  DetailGameViewModel.swift
//  GameApp
//
//  Created by MuhammadHariyanto on 08/01/23.
//

import Foundation
import Combine
import Common

public final class DetailGameViewModel{
    
    private final let gameUseCase:GameUseCase
    
    public init(gameUseCase: GameUseCase) {
        self.gameUseCase = gameUseCase
    }
    
    func getDetailGame(id:String) -> AnyPublisher<Game, Error>{
        gameUseCase.getDetailGame(id: id)
    }
    
    func setFavorite(game:Game) -> AnyPublisher<Game, Error>{
        gameUseCase.setFavorite(game: game)
    }
}
