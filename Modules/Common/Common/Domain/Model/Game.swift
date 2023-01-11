//
//  Game.swift
//  Common
//
//  Created by MuhammadHariyanto on 10/01/23.
//

import Foundation

public struct Game:Equatable, Identifiable{
    public let id:Int
    public let name:String
    public let released:String
    public let backgroundImage:String
    public let rating:Double
    public let ratingCount:Int
    public let description:String?
    public let isFavorited:Bool
    
   public init(id: Int, name: String, released: String, backgroundImage: String, rating: Double, ratingCount: Int, description: String?, isFavorited: Bool) {
        self.id = id
        self.name = name
        self.released = released
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.ratingCount = ratingCount
        self.description = description
        self.isFavorited = isFavorited
    }
}
