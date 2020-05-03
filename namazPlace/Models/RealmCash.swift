//
//  RealmCash.swift
//  namazPlace
//
//  Created by Zhassulan Aimukhambetov on 5/2/20.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//
import Foundation
import RealmSwift

class StorageManager {

    static func writeToStorage(places: [Place]) {
        places
            .map{PlaceCashed(place: $0)}
            .forEach{ place in
                do {
                    let realm = try Realm()
                    try realm.write({
                        realm.add(place, update: .modified)
                    })
                } catch let error as NSError {
                    print("Error writeToRealm: \(error.localizedDescription)")
                }
        }
    }
    
    static func readFromStorage() -> [Place]? {
        do {
            let realm = try Realm()
            return realm
                .objects(PlaceCashed.self)
                .map{Place(placeCashed: $0)} as [Place]
        } catch let error as NSError {
            print("Error readToRealm: \(error.localizedDescription)")
        }
        return nil
    }
}
