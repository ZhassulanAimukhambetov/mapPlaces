//
//  addPlaceView.swift
//  namazPlace
//
//  Created by Zhassulan Aimukhambetov on 30.04.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import UIKit

class PlaceView: UIView {
    
    @IBOutlet weak var adressText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var onClose: (() -> Void)!
    var frameY: CGFloat!
    var mapView: MapView!
    var currentPoint: Point!
    var mapVCDelegate: MapVCDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameText.delegate = self
        descriptionText.delegate = self
        adressText.delegate = self
        loadUI()
    }
    
    @IBAction func addButtonTouched(_ sender: UIButton) {
        let place = Place(point: currentPoint, name: nameText.text, description: descriptionText.text)
        mapVCDelegate.addPlace(place: place)
        onClose()
        close()
        mapView.isAddMode = false
        mapView.addPlaceMark(point: mapView.currentPoint)
    }
    
    @IBAction func cancelButtonTouched(_ sender: Any) {
        onClose()
        close()
        mapView.isAddMode = false
    }
    
    func show() {
        clearView()
        animation(isShow: true)
        mapView.isAddMode = true
    }
    private func clearView() {
        nameText.text = nil
        descriptionText.text = nil
        adressText.text = nil
    }
    
    func close() {
        animation(isShow: false)
    }
    
    private func animation(isShow: Bool) {
        self.layer.removeAllAnimations()
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: [.curveEaseIn, .beginFromCurrentState],
            animations: {
                self.isHidden = false
                self.transform = isShow ? .identity : CGAffineTransform(translationX: 0, y: self.safeArea.bottom + self.frame.height + 16)
        }, completion: { completed in
            if !isShow && completed {
                self.isHidden = true
            }
        })
    }
    
    private func loadUI() {
        self.transform = CGAffineTransform(translationX: 0, y: self.safeArea.bottom + self.frame.height + 16)
        self.layer.cornerRadius = 20
        addButton.layer.cornerRadius = 10
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.2)
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.2)
    }
}

extension PlaceView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

