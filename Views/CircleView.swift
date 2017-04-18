//
//  CircleView.swift
//  Pi-Weather
//
//  Created by Hendrik on 22.09.16.
//  Copyright © 2016 JG-Bits UG (haftungsbeschränkt). All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIView {

    let circlePathLayer = CAShapeLayer()
    var circleRadius: CGFloat = 20.0
    var view:UIView!
    var shapeLayer = CAShapeLayer()
    
    @IBOutlet weak var textLabel: LabelWithAdaptiveTextHeight!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        view.layer.addSublayer(shapeLayer)
        view.layer.masksToBounds = true
        drawRingFittingInsideView()
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    func setupViews() {
        
        self.backgroundColor = UIColor.clear
        
//        circlePathLayer.frame = bounds
//        circlePathLayer.lineWidth = 2
//        circlePathLayer.fillColor = UIColor.clear.cgColor
//        circlePathLayer.strokeColor = UIColor.red.cgColor
//        circlePathLayer.strokeEnd = 1
//        
//        var circleFrame = CGRect(x: 0, y: 0, width: bounds.size.width/2, height: bounds.size.height/2)
//        circleFrame.origin.x = circlePathLayer.bounds.midX - bounds.size.width/2
//        circleFrame.origin.y = circlePathLayer.bounds.midY - bounds.size.height/2
//        
//        let circlePath = UIBezierPath(ovalIn: circleFrame)
//        circlePathLayer.path = circlePath.cgPath
//        
//        self.layer.rasterizationScale = UIScreen.main.scale
//        
//        layer.addSublayer(circlePathLayer)
        //drawRingFittingInsideView()
        
    }
    
    override func awakeFromNib() {
        
        self.view.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
    }
    
    internal func drawRingFittingInsideView() {
        
        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth:CGFloat = 4    // your desired value
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x:halfSize,y:halfSize),
            radius: CGFloat( halfSize - (desiredLineWidth/2) ),
            startAngle: CGFloat(0),
            endAngle:CGFloat(Double.pi * 2),
            clockwise: true)
        
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor(hex: 0x2781B4).cgColor
        shapeLayer.lineWidth = desiredLineWidth
    }
    
    func setup() {
        
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for:type(of: self))
        #if os(iOS)
            let nib = UINib(nibName: "CircleView", bundle: bundle)
        #elseif os(tvOS)
            let nib = UINib(nibName: "CircleViewTv", bundle: bundle)
        #elseif os(watchOS)
            let nib = UINib(nibName: "CircleViewWatch", bundle: bundle)
        #endif
        // swiftlint:disable:next force_cast
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
