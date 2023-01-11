//
//  DetailGameModel.swift
//  GameApp
//
//  Created by MuhammadHariyanto on 08/01/23.
//

import Foundation


struct DetailGameResponse:Decodable{
    let id:Int?
    let name:String?
    let released:String?
    let backgroundImage:String?
    let rating:Double?
    let ratingCount:Int?
    let description:String?
    
    enum CodingKeys:String, CodingKey{
        case id
        case name
        case released
        case backgroundImage = "background_image"
        case rating
        case ratingCount = "ratings_count"
        case description
    }
}
