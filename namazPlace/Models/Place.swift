//
//  Place.swift
//  namazPlace
//
//  Created by Zhassulan Aimukhambetov on 30.04.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import Foundation

struct Place {
    var name: String?
    var description: String?
    var point: Point
    
    init(point: Point, name: String?, description: String?) {
        self.name = name
        self.description = description
        self.point = point
    }
}

struct Point {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
