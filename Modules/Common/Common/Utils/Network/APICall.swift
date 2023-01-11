//
//  APICall.swift
//  Common
//
//  Created by MuhammadHariyanto on 10/01/23.
//

import Foundation


struct API {
    static let baseUrl = "https://api.rawg.io/api/"
    static let key = "b6d4d0d136ba4bbdb8145d517cc5cfb9"
}

protocol Endpoint {

  var url: String { get }

}

enum Endpoints {
  
  enum Gets: Endpoint {
    case games
    case detail
    case search
    
    public var url: String {
      switch self {
      case .games: return "\(API.baseUrl)games"
      case .detail: return "\(API.baseUrl)games/"
      case .search: return "\(API.baseUrl)games?search="
      }
    }
  }
  
}
