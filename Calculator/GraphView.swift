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
    
    private func convertToGraphCoordinateSystem(x: CGFloat) -> CGFloat {
        return (x - origin.x) / scale
    }
    
    private func convertToGraphCoordinateSystem(y: CGFloat) -> CGFloat {
        return (y - origin.y) / scale
    }
    
    private func convertFromGraphCoordinateSystem(x: CGFloat) -> CGFloat {
        return x * scale + origin.x
    }
    
    private func convertFromGraphCoordinateSystem(y: CGFloat) -> CGFloat {
        return -y * scale + origin.y
    }
    
    private func drawGraph() {
        if let function = graphFunction {
            let graph = UIBezierPath()
            UIColor.blue.set()
            graph.lineWidth = 5.0
            let min = bounds.minX
            let max = bounds.maxX
            
            let initialX = min
            let initialY = convertFromGraphCoordinateSystem(y: CGFloat(function(Double(convertToGraphCoordinateSystem(x: min)))))
            
            graph.move(to: CGPoint(x: initialX, y: initialY))
            
            for i in Int(min)...Int(max) {
                let x = convertToGraphCoordinateSystem(x: CGFloat(i))
                let y = CGFloat(function(Double(x)))
                
                if x.isFinite && y.isFinite {
                    let drawableX = convertFromGraphCoordinateSystem(x: x)
                    let drawableY = convertFromGraphCoordinateSystem(y: y)
                
                    graph.addLine(to: CGPoint(x: drawableX, y: drawableY))
                }
            }
            
            UIColor.blue.set()
            graph.stroke()
        }
    }

}
