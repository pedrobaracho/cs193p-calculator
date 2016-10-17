//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Pedro Baracho on 9/7/16.
//  Copyright © 2016 Pedro Baracho. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    fileprivate enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> (Double, String?))
        case binaryOperation((Double, Double) -> (Double, String?))
        case equals
        case percent
        case void(() -> Double)
    }
    
    fileprivate struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> (Double, String?)
        var firstOperand: Double
    }
    
    fileprivate var accumulator = 0.0
    
    fileprivate func descriptionIsEmpty () -> Bool {
        return description == ""
    }
    
    private var accumulatorSymbol: String?
    
    fileprivate var accumulatorValue: String {
        if accumulatorSymbol != nil {
            return accumulatorSymbol!
        }
        else {
            return formatter.string(from: NSNumber(value: accumulator))!
        }
    }
    
    init() {
        formatter.allowsFloats = true
        formatter.maximumFractionDigits = 6
        formatter.minimumIntegerDigits = 1
    }
    
    var formatter = NumberFormatter()
    
    fileprivate var pending: PendingBinaryOperationInfo?
    fileprivate var pendingOperandOnDescription = true
    fileprivate var description = ""
    
    func clear() {
        accumulator = 0.0
        pending = nil
        accumulatorSymbol = nil
        lastError = nil
        pendingOperandOnDescription = true
        description = ""
        internalProgram.removeAll()
        variableValue.removeAll()
    }
    
    
    fileprivate var internalProgram = [AnyObject]()
    
    private func runInternalProgram() {
        for op in internalProgram {
            if let operand = op as? Double {
                setOperand(operand)
            } else if let operation = op as? String {
                performOperation(operation)
            }
        }
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        set {
            clear()
            internalProgram = newValue as! [AnyObject]
            runInternalProgram()
        }
    }
    
    func undo() {
        internalProgram.removeLast()
        runInternalProgram()
    }
    
    var currentDescription: String {
        return description.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    var isPartialResult: Bool {
        return pending != nil
    }
    
    var result: Double {
        return accumulator
    }
    
    fileprivate var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(M_PI),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation({(sqrt($0), ($0 < 0 ? "sqrt of negative number" : nil))}),
        "x²": Operation.unaryOperation({($0*$0, nil)}),
        "cos": Operation.unaryOperation({(cos($0), nil)}),
        "sin": Operation.unaryOperation({(sin($0), nil)}),
        "log": Operation.unaryOperation({(log($0), nil)}),
        "⁺⁄-": Operation.unaryOperation({(-$0, nil)}),
        "×" : Operation.binaryOperation({($0 * $1, nil)}),
        "÷" : Operation.binaryOperation({($0/$1, ($1 == 0 ? "Division by zero": nil))}),
        "+" : Operation.binaryOperation({($0 + $1, nil)}),
        "−" : Operation.binaryOperation({($0 - $1, nil)}),
        "=" : Operation.equals,
        "%" : Operation.percent,
        "RNG": Operation.void({ Double(arc4random()) / Double(UINT32_MAX) })
    ]
    
    fileprivate func executePendingOperation() {
        if isPartialResult {
            (accumulator, lastError) = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    func performOperation(_ symbol: String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                if !isPartialResult {
                    description = ""
                }
                accumulator = value
                accumulatorSymbol = symbol
                pendingOperandOnDescription = true
            case .unaryOperation(let function):
                if isPartialResult {
                    description += symbol + "(" + accumulatorValue + ")"
                }
                else {
                    if (pendingOperandOnDescription) {
                        description += accumulatorValue
                    }
                    description = symbol + "("  + currentDescription + ")"
                }
                pendingOperandOnDescription = false
                (accumulator,lastError) = function(accumulator)
            case .binaryOperation(let function):
                if descriptionIsEmpty() {
                    description += accumulatorValue + " " + symbol + " "
                }
                else {
                    if pendingOperandOnDescription {
                        description += accumulatorValue
                    }
                    if isPartialResult && ["×", "÷"].contains(symbol) {
                        description = "(" + currentDescription + ")"
                    }
                    description += " " + symbol + " "
                }
                pendingOperandOnDescription = true
                executePendingOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .equals:
                if pendingOperandOnDescription {
                    description += accumulatorValue
                }
                pendingOperandOnDescription = false
                executePendingOperation()
            case .percent:
                description += accumulatorValue + symbol
                
                if isPartialResult {
                    accumulator = pending!.firstOperand * accumulator / 100.0
                }
                else {
                    accumulator = accumulator / 100.0
                }
            case .void(let function):
                if !isPartialResult {
                    description = ""
                }
                pendingOperandOnDescription = true
                accumulator = function()
                accumulatorSymbol = symbol
            }
        }
        else {
            let value = variableValue[symbol] ?? 0.0
            
            if !isPartialResult {
                description = ""
            }
            accumulator = value
            accumulatorSymbol = symbol
            pendingOperandOnDescription = true
        }
    }
    
    func setOperand(_ operand: Double?) {
        if !isPartialResult {
            description = ""
        }
        accumulator = operand ?? 0.0
        accumulatorSymbol = nil
        pendingOperandOnDescription = true
        internalProgram.append(accumulator as AnyObject)
    }
    
    var variableValue = Dictionary<String, Double>() {
        didSet {
            if let last = internalProgram.last as? String {
                if let op = operations[last] {
                    switch op {
                    case .constant:
                        internalProgram.removeLast()
                    default: break
                        
                    }
                }
            }
            runInternalProgram()
        }
    }
    
    var errorMessage: String? {
        return lastError
    }
    
    private var lastError: String? {
        didSet {
            if lastError != nil {
                print(lastError!)
            }
        }
    }
}
