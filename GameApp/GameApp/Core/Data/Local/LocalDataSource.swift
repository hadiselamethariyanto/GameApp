//
//  LocalDataSource.swift
//  GameApp
//
//  Created by MuhammadHariyanto on 08/01/23.
//

import Foundation
import RealmSwift
import Combine

protocol LocalDataSourceProtocol: AnyObject{
    func getGames() -> AnyPublisher<[GameEntity], Error>
    func addGames(from games:[GameEntity]) -> AnyPublisher<Bool, Error>
    func getGameById(id:String) -> AnyPublisher<GameEntity?, Error>
    func addGame(from game:GameEntity) -> AnyPublisher<Bool, Error>
    func getFavorites() -> AnyPublisher<[GameEntity], Error>
}

final class LocalDataSource: NSObject{
    private let realm:Realm?
    
    private init(realm: Realm?) {
        self.realm = realm
    }
    
    static let sharedInstance: (Realm?) -> LocalDataSource = {
        realmDatabase in return LocalDataSource(realm: realmDatabase)
    }
}

extension LocalDataSource: LocalDataSourceProtocol{
    
    func getGames() -> AnyPublisher<[GameEntity], Error> {
        return Future<[GameEntity], Error>{completion in
            if let realm = self.realm{
                let games: Results<GameEntity> = {
                    realm.objects(GameEntity.self)
                        .sorted(byKeyPath: "name", ascending: true)
                }()
                completion(.success(games.toArray(ofType: GameEntity.self)))
            }else{
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    func getFavorites() -> AnyPublisher<[GameEntity], Error> {
        return Future<[GameEntity], Error>{completion in
            if let realm = self.realm{
                let games: Results<GameEntity> = {
                    realm.objects(GameEntity.self).filter("isFavorited == true")
                        .sorted(byKeyPath: "name", ascending: true)
                }()
                completion(.success(games.toArray(ofType: GameEntity.self)))
            }else{
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    func getGameById(id:String) -> AnyPublisher<GameEntity?, Error>{
        return Future<GameEntity?, Error>{completion in
            if let realm = self.realm{
                let game: Results<GameEntity> = {
                    realm.objects(GameEntity.self).filter("id == %@", id)
                }()
                completion(.success(game.first))
            }else{
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    
    func addGames(from games: [GameEntity]) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error>{completion in
            if let realm = self.realm{
                do{
                    try realm.write{
                        for game in games {
                            realm.add(game, update: .all)
                        }
                        completion(.success(true))
                    }
                }catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            }else{
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
    func addGame(from game: GameEntity) -> AnyPublisher<Bool, Error>{
        return Future<Bool, Error>{completion in
            if let realm = self.realm{
                do{
                    try realm.write{
                        realm.add(game, update: .all)
                        completion(.success(true))
                    }
                }catch{
                    completion(.failure(DatabaseError.requestFailed))
                }
            }else{
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
     
}

extension Results {
  func toArray<T>(ofType: T.Type) -> [T] {
    var array = [T]()
    for index in 0 ..< count {
      if let result = self[index] as? T {
        array.append(result)
      }
    }
    return array
  }
}


