            //
//  ViewController.swift
//  Calculator
//
//  Created by Pedro Baracho on 9/7/16.
//  Copyright © 2016 Pedro Baracho. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet fileprivate weak var display: UILabel!
    @IBOutlet weak var descriptor: UILabel!
    
    fileprivate var userIsInTheMiddleOfTyping = false
    fileprivate var displayValue: Double? {
        get {
            if display.text == nil {
                return nil
            }
            else {
                return brain.formatter.number(from: display.text!)?.doubleValue
            }
        }
        set {
            if brain.errorMessage != nil {
                display.adjustsFontSizeToFitWidth = true
                display.text = brain.errorMessage!
            }
            else {
                display.adjustsFontSizeToFitWidth = false
                if newValue == nil {
                    display.text = " "
                }
                else {
                    let num = NSNumber(value: newValue!)
                    display.text = brain.formatter.string(from: num)
                }
            }
        }
    }
    fileprivate var descriptionValue: String {
        get {
            return descriptor.text!
        }
        set {
            if newValue == "" {
                descriptor.text = " "
                return
            }
            if brain.isPartialResult {
                descriptor.text = newValue + " ..."
            }
            else {
                descriptor.text = newValue + " ="
            }
        }
    }
    
    fileprivate var brain = CalculatorBrain()
    fileprivate var formatter = NumberFormatter()
    
    private func updateDisplay() {
        displayValue = brain.result
        descriptionValue = brain.currentDescription
    }
    
    @IBAction fileprivate func clear() {
        brain.clear()
        userIsInTheMiddleOfTyping = false
        savedProgram = nil
        updateDisplay()
    }
    
    @IBAction func backspace() {
        if let count = display.text?.characters.count , userIsInTheMiddleOfTyping {
            if count > 1 {
                userIsInTheMiddleOfTyping = true
                display.text!.remove(at: display.text!.characters.index(before: display.text!.endIndex))
            }
            else if count == 1 {
                userIsInTheMiddleOfTyping = false
                display.text = "0"
            }
        }
    }
    
    @IBAction func undo() {
        if userIsInTheMiddleOfTyping {
            backspace()
        }
        else {
            brain.undo()
            updateDisplay()
        }
    }
    
    @IBAction func setVariableValue() {
        brain.variableValue["M"] = displayValue ?? 0.0
        userIsInTheMiddleOfTyping = false
        updateDisplay()
    }
    
    @IBAction func inputVariableIntoExpression() {
        brain.performOperation("M")
        userIsInTheMiddleOfTyping = false
        updateDisplay()
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    @IBAction func save() {
        savedProgram = brain.program
        userIsInTheMiddleOfTyping = false
    }
    
    @IBAction func load() {
        if savedProgram != nil {
            brain.program = savedProgram!
            userIsInTheMiddleOfTyping = false
            updateDisplay()
        }
    }
    
    @IBAction fileprivate func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        updateDisplay()
    }
    
    @IBAction fileprivate func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentInDisplay = display.text!
            display.text = textCurrentInDisplay + digit
        }
        else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    @IBAction fileprivate func touchFloatingPoint() {
        let decimalSeparator = NSLocale.current.decimalSeparator ?? "."
        if display.text?.contains(decimalSeparator) == false {
            display.text! += decimalSeparator
            userIsInTheMiddleOfTyping = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationvc = segue.destination
        if let navcon = destinationvc as? UINavigationController {
            destinationvc = navcon.visibleViewController ?? destinationvc
        }
        if let graphVC = destinationvc as? GraphViewController {
            if brain.isPartialResult {
                let shakeAnimation = CABasicAnimation(keyPath: "position")
                shakeAnimation.duration = 0.07
                shakeAnimation.repeatCount = 4
                shakeAnimation.autoreverses = true
                shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 10, y: view.center.y - 5))
                shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 10, y: view.center.y + 5))
                view.layer.add(shakeAnimation, forKey: "position")
            }
            else {
                graphVC.program = brain.program
            }
        }
    }
}
