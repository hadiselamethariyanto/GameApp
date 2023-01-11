//
//  GameModel.swift
//  GameApp
//
//  Created by MuhammadHariyanto on 05/01/23.
//


struct GameResponses: Decodable{
    let count:Int
    let next:String
    let games: [GameResponse]
    
    enum CodingKeys:String, CodingKey{
        case count
        case next
        case games = "results"
    }
}

struct GameResponse:Decodable{
    let id:Int?
    let name:String?
    let released:String?
    let backgroundImage:String?
    let rating:Double?
    let ratingCount:Int?
    
    private enum CodingKeys:String, CodingKey{
        case id
        case name
        case released
        case backgroundImage = "background_image"
        case rating
        case ratingCount = "ratings_count"
    }    
}





