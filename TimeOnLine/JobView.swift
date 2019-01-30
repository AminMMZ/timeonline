//
//  JobView.swift
//  TimeOnLine
//
//  Created by Amin on 1/30/19.
//  Copyright © 2019 Amin. All rights reserved.
//

import UIKit

class JobView: UIView {
    
    var color: UIColor = .white {
        didSet {
            setNeedsDisplay()
        }
    }
    var text: String = "Job" {
        didSet {
            setNeedsLayout()
        }
    }
    
    private lazy var titleLabel = createTitleLabel()
    
    func createTitleLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = text
        label.textColor = .white
        label.sizeToFit()
        addSubview(label)
        return label
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    private func setup() {
        contentMode = .redraw
        backgroundColor = .clear
    }
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width / 20)
        roundedRect.addClip()
        color.setFill()
        roundedRect.fill()
        
    }
    
    override func layoutSubviews() {
        titleLabel.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
    }

}
