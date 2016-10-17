
//
//  CalculatorUITests.swift
//  CalculatorUITests
//
//  Created by Pedro Baracho on 10/15/16.
//  Copyright © 2016 Pedro Baracho. All rights reserved.
//

import XCTest

class CalculatorUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        let app = XCUIApplication()
        app.buttons["C"].tap()
    }
    
    // a. touching 7 + would show “7 + ...” (with 7 still in the display)
    func testA() {
        let app = XCUIApplication()
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        
        XCTAssert(app.staticTexts["7 + ..."].exists && app.staticTexts["7"].exists)
    }
    
    // b. 7 + 9 would show “7 + ...” (9 in the display)
    func testB() {
        let app = XCUIApplication()
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        
        XCTAssert(app.staticTexts["7 + ..."].exists && app.staticTexts["9"].exists)
    }
    
    // c. 7 + 9 = would show “7 + 9 =” (16 in the display)
    func testC() {
        let app = XCUIApplication()
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["="].tap()
        
        XCTAssert(app.staticTexts["7 + 9 ="].exists && app.staticTexts["16"].exists)
    }
    
    // d. 7 + 9 = √ would show “√(7 + 9) =” (4 in the display)
    func testD() {
        let app = XCUIApplication()
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["="].tap()
        app.buttons["√"].tap()
        
        XCTAssert(app.staticTexts["√(7 + 9) ="].exists && app.staticTexts["4"].exists)
    }
    
    // e. 7 + 9 √ would show “7 + √(9) ...” (3 in the display)
    func testE() {
        let app = XCUIApplication()
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["√"].tap()
        
        XCTAssert(app.staticTexts["7 + √(9) ..."].exists && app.staticTexts["3"].exists)
    }
    
    // f. 7 + 9 √ = would show “7 + √(9) =“ (10 in the display)
    func testF() {
        let app = XCUIApplication()
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["√"].tap()
        app.buttons["="].tap()
        
        XCTAssert(app.staticTexts["7 + √(9) ="].exists && app.staticTexts["10"].exists)
    }
    
    // g. 7 + 9 = + 6 + 3 = would show “7 + 9 + 6 + 3 =” (25 in the display)
    func testG() {
        let app = XCUIApplication()
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["="].tap()
        app.buttons["+"].tap()
        app.buttons["6"].tap()
        app.buttons["+"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()
        
        XCTAssert((app.staticTexts["7 + 9 + 6 + 3 ="].exists || app.staticTexts["((7 + 9) + 6) + 3 ="].exists)
            && app.staticTexts["25"].exists)
    }
    
    // h. 7 + 9 = √ 6 + 3 = would show “6 + 3 =” (9 in the display)
    func testH() {
        let app = XCUIApplication()
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["="].tap()
        app.buttons["√"].tap()
        app.buttons["6"].tap()
        app.buttons["+"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()
        
        XCTAssert(app.staticTexts["6 + 3 ="].exists && app.staticTexts["9"].exists)
    }
    
    // i. 5 + 6 = 7 3 would show “5 + 6 =” (73 in the display)
    func testI() {
        let app = XCUIApplication()
        app.buttons["5"].tap()
        app.buttons["+"].tap()
        app.buttons["6"].tap()
        app.buttons["="].tap()
        app.buttons["7"].tap()
        app.buttons["3"].tap()
        
        XCTAssert(app.staticTexts["5 + 6 ="].exists && app.staticTexts["73"].exists)
    }
    
    // j. 7 + = would show “7 + 7 =” (14 in the display)
    func testJ() {
        let app = XCUIApplication()
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["="].tap()
        
        XCTAssert(app.staticTexts["7 + 7 ="].exists && app.staticTexts["14"].exists)
    }
    
    // k. 4 × π = would show “4 × π =“ (12.566371 in the display)
    func testK() {
        let app = XCUIApplication()
        app.buttons["4"].tap()
        app.buttons["×"].tap()
        app.buttons["π"].tap()
        app.buttons["="].tap()
        
        XCTAssert(app.staticTexts["4 × π ="].exists && app.staticTexts["12.566371"].exists)
    }
    
    // l. 4 + 5 × 3 = would show “4 + 5 × 3 =” (27 in the display)
    // m. 4 + 5 × 3 = could also show “(4 + 5) × 3 =” if you prefer (27 in the display)
    func testLM() {
        let app = XCUIApplication()
        
        app.buttons["4"].tap()
        app.buttons["+"].tap()
        app.buttons["5"].tap()
        app.buttons["×"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()
        
        XCTAssert((app.staticTexts["4 + 5 × 3 ="].exists && app.staticTexts["27"].exists) ||
            (app.staticTexts["(4 + 5) × 3 ="].exists && app.staticTexts["27"].exists))
    }
    
    /*
     9 + M = √ ⇒ description is √(9+M), display is 3 because M is not set (and so is 0) 
     7 →M ⇒ display now shows 4 (the square root of 16), description is still √(9+M)
     + 14 = ⇒ display now shows 18, description is now √(9+M)+14
     */
    func testPP2() {
        let app = XCUIApplication()
        
        app.buttons["9"].tap()
        app.buttons["+"].tap()
        app.buttons["M"].tap()
        app.buttons["="].tap()
        app.buttons["√"].tap()
        
        XCTAssert((app.staticTexts["√(9 + M) ="].exists && app.staticTexts["3"].exists))
        
        app.buttons["7"].tap()
        app.buttons["→M"].tap()
        XCTAssert((app.staticTexts["√(9 + M) ="].exists && app.staticTexts["4"].exists))
        
        
        app.buttons["+"].tap()
        app.buttons["1"].tap()
        app.buttons["4"].tap()
        app.buttons["="].tap()
        XCTAssert((app.staticTexts["√(9 + M) + 14 ="].exists && app.staticTexts["18"].exists))
    }
    
    
}
