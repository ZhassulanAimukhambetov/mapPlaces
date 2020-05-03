//
//  addPlaceView.swift
//  namazPlace
//
//  Created by Zhassulan Aimukhambetov on 30.04.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import UIKit

protocol PlaceViewDelegate: AnyObject {
    func create(_ place: Place)
    func closeMenu()
    func replaceMenu()
}

class PlaceView: UIView {
    
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var delegate: PlaceViewDelegate?
    var isEditingMode = false
        
    override func awakeFromNib() {
        super.awakeFromNib()
        nameText.delegate = self
        descriptionText.delegate = self
        addressText.delegate = self
        loadUI()
    }
    
    func show() {
        animation(isShow: true)
        addButton.setTitle("Добавить", for: .normal)
    }
    
    func show(with place: Place) {
        addressText.text = place.address
        nameText.text = place.name
        descriptionText.text = place.description
        addButton.setTitle("Сохранить", for: .normal)
        isEditingMode = true
        animation(isShow: true)
    }
    
    @IBAction func addButtonTouched(_ sender: UIButton) {
        if addressText.hasText {
            delegate?.create(newPlace())
            close()
        } else {
            close()
        }
    }
    
    @IBAction func cancelButtonTouched(_ sender: Any) {
        close()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.replaceMenu()
    }
    
    func close() {
        animation(isShow: false)
        clearView()
        isEditingMode = false
        delegate?.closeMenu()
    }
    
    func newPlace() -> Place {
        let place = Place()
        place.address = addressText.text
        place.name = nameText.text
        place.description = descriptionText.text
        return place
    }
    
    private func clearView() {
        nameText.text = nil
        descriptionText.text = nil
        addressText.text = nil
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == addressText {
            return false
        }
        return true
    }
}

