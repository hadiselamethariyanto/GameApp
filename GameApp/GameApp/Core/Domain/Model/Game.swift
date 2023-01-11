//
//  Game.swift
//  GameApp
//
//  Created by MuhammadHariyanto on 07/01/23.
//

import Foundation

struct Game:Equatable, Identifiable{
    let id:Int
    let name:String
    let released:String
    let backgroundImage:String
    let rating:Double
    let ratingCount:Int
    let description:String?
    let isFavorited:Bool
}
