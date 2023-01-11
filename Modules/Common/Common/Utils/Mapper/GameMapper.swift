//
//  GameMapper.swift
//  Common
//
//  Created by MuhammadHariyanto on 10/01/23.
//

import Foundation


final class GameMapper{
    
    static func gameMapper(input gameResponses:[GameResponse]
    )->[Game]{
        return gameResponses.map{ result in
            return Game(
                id:result.id ?? 0,
                name: result.name ?? "unknown",
                released: result.released ?? "unknown",
                backgroundImage: result.backgroundImage ?? "",
                rating: result.rating ?? 0.0,
                ratingCount: result.ratingCount ?? 0,
                description: nil,
                isFavorited: false
            )
        }
    }
    
    static func detailGameMapper(input result:DetailGameResponse
    )->Game{
        return Game(
            id:result.id ?? 0,
            name: result.name ?? "",
            released: result.released ?? "",
            backgroundImage: result.backgroundImage ?? "",
            rating: result.rating ?? 0.0,
            ratingCount: result.ratingCount ?? 0,
            description: result.description ?? "",
            isFavorited: false
        )
    }
    
    static func mapGameResponseToEntities(input gameResponse: [GameResponse]) -> [GameEntity]{
        return gameResponse.map{result in
            let newGame = GameEntity()
            newGame.id = String(result.id ?? 0)
            newGame.name = result.name ?? ""
            newGame.released = result.released ?? ""
            newGame.backgroundImage = result.backgroundImage ?? ""
            newGame.rating = result.rating ?? 0.0
            newGame.ratingCount = result.ratingCount ?? 0
            newGame.overview = ""
            newGame.isFavorited = false
            return newGame
        }
    }
    
    static func mapGameResponseToEntity(input result: DetailGameResponse) -> GameEntity{
        let newGame = GameEntity()
        newGame.id = String(result.id ?? 0)
        newGame.name = result.name ?? ""
        newGame.released = result.released ?? ""
        newGame.backgroundImage = result.backgroundImage ?? ""
        newGame.rating = result.rating ?? 0.0
        newGame.ratingCount = result.ratingCount ?? 0
        newGame.overview = result.description ?? ""
        newGame.isFavorited = false
        return newGame
    }
    
    static func mapGameEntitiesToDomains(input gameEntities:[GameEntity]) -> [Game]{
        return gameEntities.map{result in
            return Game(id: Int(result.id) ?? 0, name: result.name, released: result.released, backgroundImage: result.backgroundImage, rating: result.rating, ratingCount: result.ratingCount, description: result.overview, isFavorited: result.isFavorited)
        }
    }
    
    static func mapGameEntityToDomain(input gameEntity: GameEntity?) -> Game{
        return Game(id: Int(gameEntity?.id ?? "0") ?? 0, name: gameEntity?.name ?? "Unknown", released: gameEntity?.released ?? "Unkown", backgroundImage: gameEntity?.backgroundImage ?? "Unknown", rating: gameEntity?.rating ?? 0.0, ratingCount: gameEntity?.ratingCount ?? 0, description: gameEntity?.overview ?? "", isFavorited: gameEntity?.isFavorited ?? false)
    }
    
    static func mapGameDomainToEntity(input game:Game) -> GameEntity{
        let newGame = GameEntity()
        newGame.id = String(game.id)
        newGame.name = game.name
        newGame.released = game.released
        newGame.backgroundImage = game.backgroundImage
        newGame.rating = game.rating
        newGame.ratingCount = game.ratingCount
        newGame.overview = game.description ?? ""
        newGame.isFavorited = game.isFavorited
        return newGame
    }
    
}
