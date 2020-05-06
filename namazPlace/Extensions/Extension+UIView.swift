//
//  UIViewExtension.swift
//  namazPlace
//
//  Created by Zhassulan Aimukhambetov on 30.04.2020.
//  Copyright © 2020 Zhassulan Aimukhambetov. All rights reserved.
//

import UIKit

extension UIView {

    var safeArea: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        } else {
            return UIEdgeInsets.zero
        }
    }

    var safeAreaLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leadingAnchor
        } else {
            return self.leadingAnchor
        }
    }

    var safeAreaTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.trailingAnchor
        } else {
            return self.trailingAnchor
        }
    }

    var safeAreaTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }

    var safeAreaBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
    
    func animation(isShow: Bool, bottomConstraintValue: CGFloat) {
        self.layer.removeAllAnimations()
        UIView.animate(
            withDuration: isShow ? 1 : 0.5,
            delay: 0,
            usingSpringWithDamping: isShow ? 0.8 : 0,
            initialSpringVelocity: 0,
            options: [.curveEaseIn, .beginFromCurrentState],
            animations: {
                self.isHidden = false
                self.transform = isShow ? .identity : CGAffineTransform(translationX: 0, y: self.safeArea.bottom + self.frame.height + bottomConstraintValue)
        }, completion: { completed in
            if !isShow && completed {
                self.isHidden = true
            }
        })
    }
}
