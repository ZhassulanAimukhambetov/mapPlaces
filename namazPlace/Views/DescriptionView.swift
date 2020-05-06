//
//  DescriptionView.swift
//  namazPlace
//
//  Created by Zhassulan Aimukhambetov on 5/5/20.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import UIKit

protocol DescriptionViewDelegate: AnyObject {
    func setRating(of place: Place)
}

class DescriptionView: UIView {
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var delegate: DescriptionViewDelegate?
    
    var currentPlace: Place! {
        didSet {
            addressLabel.text = currentPlace?.address
            nameLabel.text = currentPlace?.name
            descriptionLabel.text = currentPlace?.description
            let rating = currentPlace.rating
            openButton.isUserInteractionEnabled = rating < 4 ? true : false
            if rating == 0 {
                closeButton.setTitle("Удалить", for: .normal)
            } else {
                closeButton.setTitle("Закрыто", for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadUI()
    }
    
    func show(with place: Place) {
        currentPlace = place
        self.animation(isShow: true, bottomConstraintValue: 16)
    }
    
    private func clear() {
        addressLabel.text = "Адрес"
        nameLabel.text = "Название"
        descriptionLabel.text = "Описание"
    }
    
    func close() {
        clear()
        animation(isShow: false, bottomConstraintValue: 16)
    }
    
    private func loadUI() {
        self.transform = CGAffineTransform(translationX: 0, y: self.safeArea.bottom + self.frame.height + 16)
        self.layer.cornerRadius = 20
        openButton.layer.cornerRadius = 10
        openButton.layer.borderWidth = 1
        openButton.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.2)
        closeButton.layer.cornerRadius = 10
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.2)
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.2)
    }
    
    private func ratedPlace(open: Bool) -> Place {
        if open && currentPlace.rating < 3 {
            currentPlace.rating = currentPlace.rating + 1
        } else if !open && currentPlace.rating >= 0 {
            currentPlace.rating = currentPlace.rating - 1
        }
        return currentPlace ?? Place()
    }
    
    @IBAction func openButtonTouched(_ sender: Any) {
        delegate?.setRating(of: ratedPlace(open: true))
        close()
    }
    
    @IBAction func closeButtonTouched(_ sender: Any) {
        delegate?.setRating(of: ratedPlace(open: false))
        close()
    }
    
    @IBAction func cancelButtonTouched(_ sender: Any) {
        close()
    }
}
