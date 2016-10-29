//
//  GraphViewController.swift
//  Calculator
//
//  Created by Pedro Baracho on 10/16/16.
//  Copyright © 2016 Pedro Baracho. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    private var brain = CalculatorBrain()
    public var program: CalculatorBrain.PropertyList?
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.origin = CGPoint(x: graphView.bounds.midX, y: graphView.bounds.midY)
            
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: self, action: #selector(self.changeScale(recognizer:))))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(
                target: self, action: #selector(self.moveGraph(recognizer:))))
            
            if let p = program {
                brain.program = p
                graphView.functionDescription = brain.currentDescription
            }
            graphView.graphFunction = self.graphFunction
        }
    }
    
    internal func graphFunction(x: Double) -> Double {
        if let p = program {
            brain.program = p
            brain.variableValue["M"] = x
            return brain.result
        }
        else {
            return Double.nan
        }
    }
    
    
    @IBAction internal func setGraphOrigin(_ sender: UITapGestureRecognizer) {
        graphView.origin = sender.location(in: graphView)
    }
    
    internal func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            graphView.scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    internal func moveGraph(recognizer: UIPanGestureRecognizer) {
        let origin = graphView.origin
        switch recognizer.state {
        case .changed, .ended:
            let translation = recognizer.translation(in: graphView)
            graphView.origin = CGPoint(x: origin.x + translation.x, y: origin.y + translation.y)
            recognizer.setTranslation(CGPoint.zero, in: graphView)
        default:
            break
        }
    }
    
    

}
