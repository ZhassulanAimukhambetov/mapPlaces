//
//  FirebaseService.swift
//  namazPlace
//
//  Created by Zhassulan Aimukhambetov on 5/4/20.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import Foundation
import Firebase

class FirebaseService {
    let ref = Database.database().reference()
    static let shared = FirebaseService()
    
    init() {}
    
    func writeToDatabase(place: Place) {
        let dict = ["id" : place.id, "name" : place.name, "description" : place.description, "address" : place.address, "latitude" : place.latitude, "longitude" : place.longitude] as [String : Any]
        ref.child("places").child(place.id).setValue(dict)
    }
    
    func readFromDatabase(completion: @escaping ([Place]) -> Void) {
        var places = [Place]()
        ref.child("places").observe(.value) { (snapshot) in
            guard let snapshotValue = snapshot.value as? [String : Any] else {
                completion(places)
                return
            }
            for (_, value) in snapshotValue {
                guard let data = try? JSONSerialization.data(withJSONObject: value) else { return }
                guard let place = try? JSONDecoder().decode(Place.self, from: data) else { return }
                places.append(place)
            }
            completion(places)
        }
    }
}
