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
    
    @IBInspectable var scale: CGFloat = 100 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var function : ((Double) -> (Double))? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private var axesDrawer = AxesDrawer(color: UIColor.black)
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        axesDrawer.drawAxesInRect(bounds: bounds, origin: CGPoint(x: bounds.midX, y: bounds.midY), pointsPerUnit: scale)
    }
    
    public func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    private func graphFunction() {
        
    }

}
