//
//  MNRadiusButton.swift
//  mNoisi
//
//  Created by yanyin on 2017/07/21.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

@IBDesignable
class MNRadiusButton: UIButton {
    
    @IBInspectable
    var radius: CGFloat = 0 {
        didSet {
            if radius > 0 {
                self.layer.masksToBounds = true
                self.layer.cornerRadius = radius
            } else {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 0
            }
        }
    }
    
    @IBInspectable
    var border: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = border
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        didSet {
            guard let color = borderColor?.cgColor else { return }
            self.layer.borderColor = color
        }
        
    }

}
