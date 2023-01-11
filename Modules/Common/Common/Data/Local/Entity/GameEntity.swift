//
//  GameEntity.swift
//  Common
//
//  Created by MuhammadHariyanto on 10/01/23.
//

import Foundation
import RealmSwift

public class GameEntity:Object{
    @objc dynamic var id:String = ""
    @objc dynamic var name:String = ""
    @objc dynamic var released:String = ""
    @objc dynamic var backgroundImage:String = ""
    @objc dynamic var rating:Double = 0.0
    @objc dynamic var ratingCount:Int = 0
    @objc dynamic var overview:String = ""
    @objc dynamic var isFavorited:Bool = false
    
    public override static func primaryKey() -> String? {
        return "id"
    }
}

