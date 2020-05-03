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

protocol MapViewDelegate: AnyObject {
    func showPlaceView(with place: Place?)
    func closePlaceView()
    func setPlaceName(name: String?)
}

class MapView: YMKMapView {
    
    let POINT_ASTANA = YMKPoint(latitude: 51.15132203497844, longitude: 71.43448346808336)
    var map: YMKMap {
        return self.mapWindow.map
    }
    weak var delegate: MapViewDelegate?
    var place: Place?
    var mapObject: YMKMapObject?
    var isAddAddressMode = false
    var isAddPlaceMode = false
        
    override func awakeFromNib() {
        super.awakeFromNib()
        loadMap()
        map.addInputListener(with: self)
        map.addCameraListener(with: self)
    }
    
    func addPlaceMarks(places: [Place]) {
        places.forEach { (place) in
            let point = YMKPoint(latitude: place.latitude, longitude: place.longitude)
            let placeMark = map.mapObjects.addPlacemark(with: point)
            placeMark.setIconWith(UIImage(named: "mosque")!)
            placeMark.userData = place
            placeMark.addTapListener(with: self)
        }
    }
    
    func curentPlace() -> Place {
        guard let mapObject = mapObject else { return Place() }
        map.mapObjects.remove(with: mapObject)
        guard let currentPlace = mapObject.userData as? Place else { return Place() }
        return currentPlace
    }
    
    private func loadMap() {
        map.isNightModeEnabled = true
        map.show(point: POINT_ASTANA, zoom: 12, animationDuration: 1.2)
    }
}
//MARK: - YMKMapKit Listeners
extension MapView: YMKMapInputListener {
    func onMapTap(with map: YMKMap, point: YMKPoint) {
        if isAddAddressMode {
            let currentZoom = map.cameraPosition.zoom
            map.show(point: point, zoom: currentZoom, animationDuration: 0.3)
        }
        if isAddPlaceMode && !isAddAddressMode {
            delegate?.closePlaceView()
        }
    }
    
    func onMapLongTap(with map: YMKMap, point: YMKPoint) {
        if !isAddPlaceMode {
            let currentZoom = map.cameraPosition.zoom
            map.show(point: point, zoom: currentZoom, animationDuration: 0.3)
            delegate?.showPlaceView(with: nil)
            isAddPlaceMode = true
        }
    }
}

extension MapView: YMKMapCameraListener {
    func onCameraPositionChanged(with map: YMKMap,
                                 cameraPosition: YMKCameraPosition,
                                 cameraUpdateSource: YMKCameraUpdateSource,
                                 finished: Bool) {
        if isAddAddressMode && finished {
            YandexGeocoderService.search(point: cameraPosition.target) { (name) in
                self.delegate?.setPlaceName(name: name)
            }
        }
    }
}

extension MapView: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        self.mapObject = mapObject
        if let place = mapObject.userData as! Place? {
            let objectPoint = YMKPoint(latitude: place.latitude, longitude: place.longitude)
            map.show(point: objectPoint, zoom: 15, animationDuration: 0.3)
            delegate?.showPlaceView(with: place)
            isAddPlaceMode = true
        }
        return true
    }
}

extension YMKMap {
    func show(point: YMKPoint, zoom: Float, animationDuration: Float) {
        let cameraPosition = YMKCameraPosition(target: point, zoom: zoom, azimuth: 0, tilt: 0)
        self.move(with: cameraPosition, animationType: YMKAnimation(type: .smooth, duration: animationDuration), cameraCallback: nil)
    }
}

