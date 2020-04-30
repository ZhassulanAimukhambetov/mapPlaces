//
//  MapVC.swift
//  namazPlace
//
//  Created by Zhassulan Aimukhambetov on 30.04.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import UIKit

protocol MapVCDelegate {
    func addPlace(place: Place)
}

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MapView!
    @IBOutlet weak var placeView: PlaceView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var markerPin: UIImageView!
    @IBOutlet weak var botViewConstraint: NSLayoutConstraint!
    
    var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeView.mapVCDelegate = self
        placeView.mapView = self.mapView
        mapView.placeView = self.placeView
        addKeyboardNotification()
        self.mapView.onClose = {
            self.markerPin.isHidden = false
        }
        self.mapView.onPlaceTap = {
            self.showMenu()
        }
        self.placeView.onClose = {
            self.view.endEditing(true)
            self.markerPin.isHidden = true
        }
    }
    
    @IBAction func menuButtonTouch(_ sender: Any) {
        showMenu()
        
    }
    
    private func showMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let addPlaceAction = UIAlertAction(title: "Добавить новое место", style: .default) { (_) in
            self.addPlace()
            YandexGeocoderService.search(point: self.mapView.map.cameraPosition.target) { (title) in
                self.placeView.adressText.text = title
            }
        }
        let editPlaceAction = UIAlertAction(title: "Редактировать место", style: .default) { (_) in
            
        }
        let updateAction = UIAlertAction(title: "Обновить карту", style: .default) { (_) in
            self.updatePlaces()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (_) in
            
        }
        alert.addAction(addPlaceAction)
        alert.addAction(editPlaceAction)
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func addPlace() {
        self.placeView.show()
        self.markerPin.isHidden = false
    }
    //TODO: - add UPDATE PLACE
    private func updatePlaces() {
        
    }
}

extension MapVC: MapVCDelegate {
    func addPlace(place: Place) {
        places.append(place)
        //UserDefaults.se
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
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.botViewConstraint?.constant = 30
            } else {
                self.botViewConstraint?.constant = (endFrame?.size.height ?? 0.0) + 10
            }
            UIView.animate(withDuration: duration, delay: TimeInterval(0), options: animationCurve,
                           animations: { self.view.layoutIfNeeded() }, completion: nil)
        }
    }
}
