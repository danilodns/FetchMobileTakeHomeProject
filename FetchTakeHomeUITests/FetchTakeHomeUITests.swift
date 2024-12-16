//
//  FetchTakeHomeUITests.swift
//  FetchTakeHomeUITests
//
//  Created by Danilo Silveira on 2024-12-03.
//

import XCTest

final class FetchTakeHomeUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNewFeatures() throws {
        
        let app = XCUIApplication()
        app.launch()
        XCTAssert(app.navigationBars["Recipes"]/*@START_MENU_TOKEN@*/.buttons["line.3.horizontal.decrease"]/*[[".otherElements[\"line.3.horizontal.decrease\"].buttons[\"line.3.horizontal.decrease\"]",".buttons[\"line.3.horizontal.decrease\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
        app.navigationBars["Recipes"]/*@START_MENU_TOKEN@*/.buttons["line.3.horizontal.decrease"]/*[[".otherElements[\"line.3.horizontal.decrease\"].buttons[\"line.3.horizontal.decrease\"]",".buttons[\"line.3.horizontal.decrease\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(app.buttons["Select All"].exists)
        XCTAssert(app.buttons["Remove All"].exists)
        XCTAssert(app.navigationBars["Filter"]/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".otherElements[\"Done\"].buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
                                        
    }
}
