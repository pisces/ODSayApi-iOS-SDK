//
//  ODSayApiAppCenterTest.swift
//  ODSayApiSDK
//
//  Created by Steve Kim on 7/20/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import XCTest
@testable import ODSayApiSDK

class ODSayApiAppCenterTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDefaultCenter() {
        XCTAssertNotNil(ODSayApiAppCenter.defaultCenter())
    }
    
    func testGetServiceKey() {
        let serviceKey: String = "NDQ0My0xNDYzMTA1MjY4NzczLWViZThlMWQzLWZhYmMtNDY1ZS1hOGUxLWQzZmFiY2U2NWUxMQ==".stringByRemovingPercentEncoding!
        
        XCTAssertNotNil(ODSayApiAppCenter.defaultCenter().serviceKey)
        XCTAssertEqual(serviceKey, ODSayApiAppCenter.defaultCenter().serviceKey)
    }
    
    func testCallPathSearchExit() {
        let expectation = expectationWithDescription("testCallPathSearchExit")
        
        let param = ODSayApiParameterSet.PathSearchExit()
        param.changeCount = 0
        param.optCount = 0
        param.resultCount = 13
        param.radius = "700:2000"
        param.weightTime = "10:5:5:10:10:5"
        param.OPT = 0
        param.SearchType = 0
        param.SX = 127.101624
        param.SY = 37.602018
        param.EX = 127.010245
        param.EY = 37.489199
        
        ODSayApiAppCenter.defaultCenter().call(
            path: ODSayApiPath.PathSearchExit,
            params: param,
            completion: {(result: ODSayApiResult.PathSearchExit?, error:NSError?) -> Void in
                XCTAssertNotNil(result)
                XCTAssertNil(error)
                expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(10) { error in
        }
    }
}