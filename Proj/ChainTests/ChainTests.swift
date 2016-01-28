//
//  ChainTests.swift
//  ChainTests
//
//  Created by xxxAIRINxxx on 2016/01/28.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import Foundation
import XCTest
@testable import Chain

class ChainTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGCD() {
        let expectation = expectationWithDescription("")
        
        Chain.main {
            XCTAssertEqual(qos_class_self(), qos_class_main(), "on main queue")
            return nil
            }.background { result in
                XCTAssertEqual(qos_class_self(), QOS_CLASS_BACKGROUND, "on background queue")
                return nil
            }.userInteractive { result in
                XCTAssertEqual(qos_class_self(), QOS_CLASS_USER_INTERACTIVE, "on user interactive queue")
                return nil
            }.userInitiated { result in
                XCTAssertEqual(qos_class_self(), QOS_CLASS_USER_INITIATED, "on user initiated queue")
                return nil
            }.utility { result in
                XCTAssertEqual(qos_class_self(), QOS_CLASS_UTILITY, "on utility queue")
                return nil
            }.on { result in
                XCTAssertEqual(qos_class_self(), QOS_CLASS_UTILITY, "on utility queue")
                return nil
            }.run(.Main) { result in
                XCTAssertEqual(qos_class_self(), qos_class_main(), "on main queue")
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testCustom() {
        let customQueue = dispatch_queue_create("CustomQueueLabel", DISPATCH_QUEUE_CONCURRENT)
        
        let ex = expectationWithDescription("")
        
        var qos_class : qos_class_t = qos_class_self()
        dispatch_async(customQueue) {
            qos_class = qos_class_self()
            ex.fulfill()
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
        
        
        let expectation = expectationWithDescription("")
        
        Chain.custom(customQueue) {
            XCTAssertEqual(qos_class_self(), qos_class, "")
            return nil
            }.on { result in
                XCTAssertEqual(qos_class_self(), qos_class, "")
                return result
            }.main { result in
                XCTAssertEqual(qos_class_self(), qos_class_main(), "")
                return result
            }.custom(customQueue) { result in
                XCTAssertEqual(qos_class_self(), qos_class, "")
                return result
            }.background { result in
                XCTAssertEqual(qos_class_self(), QOS_CLASS_BACKGROUND, "")
                return result
            }.run(.Custom(queue: customQueue)) { result in
                XCTAssertEqual(qos_class_self(), qos_class, "")
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testChain() {
        let expectation = expectationWithDescription("")
        
        Chain.main {
            return 1
            }.background { result in
                let _result = result as! Int
                XCTAssertTrue(_result == 1, "")
                return _result + 1
            }.userInteractive { result in
                let _result = result as! Int
                XCTAssertTrue(_result == 2, "")
                return _result + 1
            }.userInitiated { result in
                let _result = result as! Int
                XCTAssertTrue(_result == 3, "")
                return _result + 1
            }.utility { result in
                let _result = result as! Int
                XCTAssertTrue(_result == 4, "")
                return _result + 1
            }.on { result in
                let _result = result as! Int
                XCTAssertTrue(_result == 5, "")
                return _result + 1
            }.run(.Main) { result in
                let _result = result as! Int
                XCTAssertTrue(_result == 6, "")
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testChainReference() {
        let expectation = expectationWithDescription("")
        
        let obj: TestObj = TestObj()
        
        Chain.main {
            return obj
            }.background { result in
                XCTAssertTrue(result! === obj, "")
                return result!
            }.userInteractive { result in
                XCTAssertTrue(result! === obj, "")
                return result!
            }.userInitiated { result in
                XCTAssertTrue(result! === obj, "")
                return result!
            }.utility { result in
                XCTAssertTrue(result! === obj, "")
                return result!
            }.on { result in
                XCTAssertTrue(result! === obj, "")
                return result!
            }.run(.Main) { result in
                XCTAssertTrue(result! === obj, "")
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testChainNil() {
        let expectation = expectationWithDescription("")
        
        Chain.main {
            return nil
            }.background { result in
                XCTAssertNil(result, "")
                return result
            }.userInteractive { result in
                XCTAssertNil(result, "")
                return result
            }.userInitiated { result in
                XCTAssertNil(result, "")
                return result
            }.utility { result in
                XCTAssertNil(result, "")
                return result
            }.on { result in
                XCTAssertNil(result, "")
                return result
            }.run(.Main) { result in
                XCTAssertNil(result, "")
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
}

final class TestObj {
    
    deinit {
        print("deinit TestObj")
    }
    
    init() {}
}
