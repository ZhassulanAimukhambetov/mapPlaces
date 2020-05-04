//
//  MapVC.swift
//  namazPlace
//
//  Created by Zhassulan Aimukhambetov on 30.04.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import UIKit
import RealmSwift

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MapView!
    @IBOutlet weak var placeView: PlaceView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var markerPin: UIImageView!
    @IBOutlet weak var botViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressLabel: UILabel!
    
    var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardNotification()
        mapView.delegate = self
        placeView.delegate = self
        if let places = StorageManager.readFromStorage(), places.count != 0 {
            self.places = places
            mapView.addPlaceMarks(places: places)
            FirebaseService.shared.readFromDatabase { (places) in
                self.places = places
                self.mapView.map.mapObjects.clear()
                self.mapView.addPlaceMarks(places: places)
                StorageManager.deleteAllPlaces()
                StorageManager.writeToStorage(places: places)
            }
        } else {
            FirebaseService.shared.readFromDatabase { (places) in
                self.places = places
                self.mapView.addPlaceMarks(places: places)
                StorageManager.writeToStorage(places: places)
            }
        }
        print(places.count)
    }
    
    @IBAction func menuButtonTouch(_ sender: Any) {
        showMenu()
        menuButton.isHidden = true
    }
    @IBAction func closeButton(_ sender: Any) {
        pickMapPoint(show: false)
    }
    @IBAction func addressTextTouched(_ sender: UITextField) {
        self.view.endEditing(true)
        pickMapPoint(show: true)
        YandexGeocoderService.search(point: mapView.map.cameraPosition.target) { (title) in
            sender.text = title
        }
    }
    
    private func pickMapPoint(show: Bool) {
        botViewConstraint.constant = show ? -200 : 20
        animation(duration: 0.5)
        markerPin.isHidden = !show
        closeButton.isHidden = !show
        mapView.isAddAddressMode = show
        addressLabel.isHidden = !show
        addressLabel.text = "Выберите место на карте"
    }
    
    private func showMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let addPlaceAction = UIAlertAction(title: "Добавить новое место", style: .default) { (_) in
            self.placeView.show()
            self.mapView.isAddPlaceMode = true
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (_) in
            self.menuButton.isHidden = false
        }
        alert.addAction(addPlaceAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
//MARK: - PlaceViewDelegate
extension MapVC: PlaceViewDelegate {
    func closeMenu() {
        menuButton.isHidden = false
        mapView.isAddPlaceMode = false
    }
    func create(_ place: Place) {
        if placeView.isEditingMode {
            let currentPlace = mapView.curentPlace()
            places.removeAll{ $0.id == currentPlace.id }
            place.id = currentPlace.id
        } else {
            place.id = UUID().uuidString
        }
        let point = mapView.map.cameraPosition.target
        place.latitude = point.latitude
        place.longitude = point.longitude
        add(newPlace: place)
        mapView.isAddPlaceMode = false
    }
    func replaceMenu() {
        if mapView.isAddAddressMode {
            pickMapPoint(show: false)
        }
    }
    private func add(newPlace: Place) {
        places.append(newPlace)
        FirebaseService.shared.writeToDatabase(place: newPlace)
        StorageManager.writeToStorage(places: places)
        mapView.addPlaceMarks(places: [newPlace])
    }
}
//MARK: - MapViewDelegate
extension MapVC: MapViewDelegate {
    func closePlaceView() {
        placeView.close()
    }
    func setPlaceName(name: String?) {
        placeView.addressText.text = name
        addressLabel.text = name
    }
    func showPlaceView(with place: Place?) {
        menuButton.isHidden = true
        if let place = place {
            placeView.show(with: place)
        } else {
            placeView.show()
        }
    }
}

//MARK: - Textfield and Keyboard configure
extension MapVC {
    private func addKeyboardNotification() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    private func animation(duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: { self.view.layoutIfNeeded() })
    }
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.botViewConstraint?.constant = 20
            } else {
                self.botViewConstraint?.constant = (endFrame?.size.height ?? 0.0) + 10
            }
            animation(duration: 0.5)
        }
    }
}
