//
//  SearchViewModel.swift
//  Search
//
//  Created by MuhammadHariyanto on 10/01/23.
//

import Foundation
import Common
import Combine


public final class SearchViewModel{
    private final let gameUseCase:GameUseCase
    
    public init(gameUseCase: GameUseCase) {
        self.gameUseCase = gameUseCase
    }
    
    func searchGames(query:String) -> AnyPublisher<[Game],Error>{
        gameUseCase.searchGames(query: query)
    }
}
