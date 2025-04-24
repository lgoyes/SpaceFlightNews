//
//  SpaceFlightNewsUITests.swift
//  SpaceFlightNewsUITests
//
//  Created by Luis David Goyes Garces on 22/4/25.
//

import XCTest

final class SpaceFlightNewsUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
}
