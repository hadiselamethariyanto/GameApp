//
//  FavoriteViewModel.swift
//  GameApp
//
//  Created by MuhammadHariyanto on 08/01/23.
//

import Foundation
import Combine
import Common

public final class FavoriteViewModel{
    private final let gameUseCase:GameUseCase
    
    public init(gameUseCase: GameUseCase) {
        self.gameUseCase = gameUseCase
    }
    
    func getFavorites() -> AnyPublisher<[Game],Error>{
        gameUseCase.getFavorites()
    }
}
