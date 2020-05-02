//
//  Place.swift
//  namazPlace
//
//  Created by Zhassulan Aimukhambetov on 30.04.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import Foundation
import YandexMapKit

struct Place {
    var name: String?
    var description: String?
    var address: String?
    var latitude: Double
    var longitude: Double
    
    init(name: String?, description: String?, address: String?, point: YMKPoint) {
        self.name = name
        self.description = description
        self.address = address
        latitude = point.latitude
        longitude = point.longitude
    }
    
    init(placeCashed: PlaceCashed) {
        name = placeCashed.name
        description = placeCashed.descriptionPlace
        address = placeCashed.address
        latitude = placeCashed.latitude
        longitude = placeCashed.longitude
    }
}
