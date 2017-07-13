//
//  MNShadowButton.swift
//  mNoisi
//
//  Created by yan on 2017/07/11.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit

@IBDesignable
class MNShadowButton: UIButton {

    @IBInspectable
    var shadowOpacity: Float = 0.75 {
        didSet {
            _commonInit()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        _commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        _commonInit()
    }

    private func _commonInit() {
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = 2.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.init(width: 0, height: 2)

        if let image = self.image(for: .selected) {
            self.setImage(image, for: [.selected, .highlighted])
        }
    }
}
