//
//  MNSegmentControl.swift
//  mNoisi
//
//  Created by Leon.yan on 09/07/2017.
//  Copyright © 2017 Leon.yan. All rights reserved.
//

import UIKit


open class MNSegmentControl: UIControl {

    open class Item {
        var imageName: String?
        var title: String?
        var attributeTitle: NSAttributedString?
        var tag: Int = 0
    }

    var selectedItem: Int = -1
    private var _target: Any?
    private var _selector: Selector?

    override open func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        if controlEvents.contains(.valueChanged) {
            _target = target
            _selector = action
        }
    }
    
    private var _items: [UIButton] = []
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)

        _commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        _commonInit()
    }

    private func _commonInit() {
        let size = self.bounds.size
        let button1 = UIButton.init(type: UIButtonType.system)
        button1.frame = CGRect(x: 0, y: 0, width: size.width / 2.0, height: size.height)
        button1.setImage(UIImage.init(named: "music"), for: .normal)
        button1.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        button1.setTitle("Scenes", for: .normal)
        button1.tintColor = UIColor.white
        button1.adjustsImageWhenHighlighted = false
//        button1.setAttributedTitle(title1, for: .normal)
        button1.addTarget(self, action: #selector(itemSelected(_:)), for: .touchUpInside)
        _items.append(button1)
        self.addSubview(button1)

        let button2 = UIButton.init(type: UIButtonType.system)
        button2.frame = CGRect(x: size.width / 2.0, y: 0, width: size.width / 2.0, height: size.height)
        button2.setImage(UIImage.init(named: "favor-on"), for: .normal)
        button2.setTitle("Favorite", for: .normal)
        button2.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        button2.tintColor = UIColor.gray
        button2.adjustsImageWhenHighlighted = false
        button2.addTarget(self, action: #selector(itemSelected(_:)), for: .touchUpInside)
        _items.append(button2)
        self.addSubview(button2)

        selectedItem = 0
    }

    @objc
    private func itemSelected(_ sender: UIButton) {
        guard let index = _items.index(of: sender) else {
            return
        }
        guard index != selectedItem else {
            return
        }
        _items.forEach { $0.tintColor = ((sender == $0) ? UIColor.white : UIColor.gray) }
        guard let target = _target,
            let action = _selector else {
                return
        }
        selectedItem = index
        self.sendAction(action, to: target, for: nil)
    }

}
