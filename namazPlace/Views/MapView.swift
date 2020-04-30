//
//  MapView.swift
//  namazPlace
//
//  Created by Zhassulan Aimukhambetov on 30.04.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import UIKit
import YandexMapKit
import YandexMapKitSearch

class MapView: YMKMapView {
    
    let POINT_ASTANA = YMKPoint(latitude: 51.15132203497844, longitude: 71.43448346808336)
    
    var isAddMode = false
    var currentPoint: YMKPoint!
    var placeView: PlaceView!
    var map: YMKMap {
        return self.mapWindow.map
    }
    
    var onPlaceTap: (() -> Void)!
    var onClose: (() -> Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadMap()
        map.addInputListener(with: self)
        map.addCameraListener(with: self)
    }
    
    private func loadMap() {
        let cameraPosition = YMKCameraPosition(target: POINT_ASTANA, zoom: 12, azimuth: 0, tilt: 0)
        map.isNightModeEnabled = true
        map.isZoomGesturesEnabled = true
        map.move(with: cameraPosition, animationType: YMKAnimation(type: .smooth, duration: 1.2), cameraCallback: nil)
    }
    
    func addPlaceMark(point: YMKPoint) {
        let placeMark = map.mapObjects.addPlacemark(with: point)
        placeMark.addTapListener(with: self)
        placeMark.setIconWith(UIImage(named: "mosque")!)
    }
    
}

extension MapView: YMKMapInputListener {
    func onMapTap(with map: YMKMap, point: YMKPoint) {
        if isAddMode {
            map.move(with: YMKCameraPosition(target: point, zoom: map.cameraPosition.zoom, azimuth: 0, tilt: 0), animationType: YMKAnimation(type: .smooth, duration: 0.3), cameraCallback: nil)
        }
    }
    
    func onMapLongTap(with map: YMKMap, point: YMKPoint) {
        if !isAddMode {
            let cameraPosition = YMKCameraPosition(target: point, zoom: map.cameraPosition.zoom, azimuth: 0, tilt: 0)
            map.move(with: cameraPosition, animationType: YMKAnimation(type: .smooth, duration: 0.3), cameraCallback: nil)
            placeView.show()
            YandexGeocoderService.search(point: point) { (title) in
                self.placeView.adressText.text = title
            }
            onClose()
        }
    }
}

extension MapView: YMKMapCameraListener {
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateSource: YMKCameraUpdateSource, finished: Bool) {
        if finished {
            currentPoint = cameraPosition.target
            if isAddMode {
                let yPoint = YMKPoint(latitude: cameraPosition.target.latitude, longitude: cameraPosition.target.longitude)
                YandexGeocoderService.search(point: yPoint) { (title) in
                    self.placeView.adressText.text = title
                }
                let point = Point(latitude: yPoint.latitude, longitude: yPoint.longitude)
                self.placeView.currentPoint = point
            }
        }
    }
}

extension MapView: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        map.move(with: YMKCameraPosition(target: point, zoom: map.cameraPosition.zoom, azimuth: 0, tilt: 0), animationType: YMKAnimation(type: .smooth, duration: 0.3), cameraCallback: nil)
        onPlaceTap()
        return true
    }
}

