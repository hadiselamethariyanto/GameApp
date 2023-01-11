//
//  GameModel.swift
//  Common
//
//  Created by MuhammadHariyanto on 10/01/23.
//

public struct GameResponses: Decodable{
    let count:Int
    let next:String
    let games: [GameResponse]
    
    enum CodingKeys:String, CodingKey{
        case count
        case next
        case games = "results"
    }
}

public struct GameResponse:Decodable{
    public let id:Int?
    public let name:String?
    public let released:String?
    public let backgroundImage:String?
    public let rating:Double?
    public let ratingCount:Int?
    
    private enum CodingKeys:String, CodingKey{
        case id
        case name
        case released
        case backgroundImage = "background_image"
        case rating
        case ratingCount = "ratings_count"
    }
}
