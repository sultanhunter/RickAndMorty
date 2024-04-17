//
//  CharacterStatusIcon.swift
//  RickAndMorty
//
//  Created by Sultan on 09/04/24.
//

import UIKit

class CharacterStatusIcon: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ rect: CGRect) {
        drawCircle()
    }
    
    private var color: CGColor = UIColor.red.cgColor
    
    private let shapeLayer = CAShapeLayer()

    private func drawCircle() {
        let halfSize: CGFloat = min(bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth: CGFloat = 1 // your desired value
                
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: halfSize, y: halfSize),
            radius: CGFloat(halfSize - (desiredLineWidth/2)),
            startAngle: CGFloat(0),
            endAngle: CGFloat(M_PI * 2),
            clockwise: true)
        
        shapeLayer.path = circlePath.cgPath
                
        shapeLayer.fillColor = color
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = desiredLineWidth
        
        layer.addSublayer(shapeLayer)
    }
    
    public func setColor(_ color: CGColor) {
        shapeLayer.fillColor = color
        shapeLayer.strokeColor = color
    }
}
