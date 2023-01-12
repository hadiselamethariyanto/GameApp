//
//  DetailGameModel.swift
//  Common
//
//  Created by MuhammadHariyanto on 10/01/23.
//

import Foundation


public struct DetailGameResponse:Decodable{
    public let id:Int?
    public let name:String?
    public let released:String?
    public let backgroundImage:String?
    public let rating:Double?
    public let ratingCount:Int?
    public let description:String?
    
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
