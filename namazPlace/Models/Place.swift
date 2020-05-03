//
//  Place.swift
//  namazPlace
//
//  Created by Zhassulan Aimukhambetov on 30.04.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import Foundation
import YandexMapKit
import RealmSwift

class Place {
    var id: Int = 0
    var name: String?
    var description: String?
    var address: String?
    var latitude: Double = 0
    var longitude: Double = 0
    
    init() {}
    
    init(id: Int, name: String?, description: String?, address: String?, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.description = description
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    convenience init(placeCashed: PlaceCashed) {
        self.init()
        id = placeCashed.id
        name = placeCashed.name
        description = placeCashed.descriptionPlace
        address = placeCashed.address
        latitude = placeCashed.latitude
        longitude = placeCashed.longitude
    }
}
