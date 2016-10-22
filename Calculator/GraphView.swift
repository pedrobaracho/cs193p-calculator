//
//  GraphView.swift
//  Calculator
//
//  Created by Pedro Baracho on 10/16/16.
//  Copyright © 2016 Pedro Baracho. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    @IBInspectable public var scale: CGFloat = 50 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var origin: CGPoint = CGPoint.zero {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var graphFunction : ((Double) -> (Double))? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private var axesDrawer = AxesDrawer(color: UIColor.black)
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        drawAxes()
        drawGraph()
    }
    
    private func drawAxes() {
        axesDrawer.drawAxesInRect(bounds: bounds, origin: origin, pointsPerUnit: scale)
    }
    
    private func drawGraph() {
        
    }

}
