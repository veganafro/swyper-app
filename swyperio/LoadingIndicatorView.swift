//
//  LoadingIndicatorView.swift
//  swyperio
//
//  Created by Jeremia Muhia on 12/16/16.
//  Copyright © 2016 NYU. All rights reserved.
//

import UIKit

class LoadingIndicatorView: UIView {

    let circlePathLayer = CAShapeLayer()
    let circleRadius: CGFloat = 20.0
    
    var loadingProgress: CGFloat {
        
        get {
            return circlePathLayer.strokeEnd
        }
        set {
            
            if newValue > 1 {
                circlePathLayer.strokeEnd = 1
            }
            else if newValue < 0 {
                circlePathLayer.strokeEnd = 0
            }
            else {
                circlePathLayer.strokeEnd = newValue
            }
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
    
        circlePathLayer.frame = bounds
        circlePathLayer.lineWidth = 2
        circlePathLayer.fillColor = UIColor.clear.cgColor
        circlePathLayer.strokeColor = UIColor.red.cgColor
        
        loadingProgress = 0
        
        layer.addSublayer(circlePathLayer)
        backgroundColor = UIColor.white
    }
    
    func circleFrame() -> CGRect {
    
        var circleFrame = CGRect(x: 0, y: 0, width: 2 * circleRadius, height: 2 * circleRadius)
        circleFrame.origin.x = circlePathLayer.bounds.midX - circleFrame.midX
        circleFrame.origin.y = circlePathLayer.bounds.midY - circleFrame.midY
        return circleFrame
    }
    
    func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: circleFrame())
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        circlePathLayer.frame = bounds
        circlePathLayer.path = circlePath().cgPath
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
