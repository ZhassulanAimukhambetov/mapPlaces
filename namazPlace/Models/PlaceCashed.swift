//
//  PlaceCashed.swift
//  namazPlace
//
//  Created by Zhassulan Aimukhambetov on 5/2/20.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//
import RealmSwift

class PlaceCashed: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String?
    @objc dynamic var descriptionPlace: String?
    @objc dynamic var address: String?
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    
    convenience init(place: Place) {
        self.init()
        id = place.id
        name = place.name
        descriptionPlace = place.description
        address = place.address
        latitude = place.latitude
        longitude = place.longitude
    }
    
    override static func primaryKey() -> String? {
         return "id"
     }
}


