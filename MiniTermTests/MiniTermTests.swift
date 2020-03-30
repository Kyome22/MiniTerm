//
//  MiniTermTests.swift
//  MiniTermTests
//
//  Created by Takuto Nakamura on 2020/03/30.
//  Copyright © 2020 Takuto Nakamura. All rights reserved.
//

import XCTest

class MiniTermTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAnsiEscaping() {
        let parser = ANSIParser()
        let case1 = #"Hello\[36mWorld"#
        XCTAssertEqual(parser.removeAnsiEscape(case1), "HelloWorld")
        
        let case2 = #"Hello\[34;1HWorld"#
        XCTAssertEqual(parser.removeAnsiEscape(case2), "HelloWorld")
        
        let case3 = #"Hello\[45;3fWorld"#
        XCTAssertEqual(parser.removeAnsiEscape(case3), "HelloWorld")
        
        let case4 = #"Hello\[1AWorld"#
        XCTAssertEqual(parser.removeAnsiEscape(case4), "HelloWorld")
        
        let case5 = #"Hello\[2BWorld"#
        XCTAssertEqual(parser.removeAnsiEscape(case5), "HelloWorld")
        
        let case6 = #"Hello\[3CWorld"#
        XCTAssertEqual(parser.removeAnsiEscape(case6), "HelloWorld")
        
        let case7 = #"Hello\[JWorld"#
        XCTAssertEqual(parser.removeAnsiEscape(case7), "HelloWorld")
        
        let case8 = #"Hello\[2KWorld"#
        XCTAssertEqual(parser.removeAnsiEscape(case8), "HelloWorld")
        
        let case9 = #"Hello\[uWorld"#
        XCTAssertEqual(parser.removeAnsiEscape(case9), "HelloWorld")
        
        let case10 = #"Hello\[=300hWorld"#
        XCTAssertEqual(parser.removeAnsiEscape(case10), "HelloWorld")
        
        let case11 = #"Hello\[0;68;"DIR";13pWorld"#
        XCTAssertEqual(parser.removeAnsiEscape(case11), "HelloWorld")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
