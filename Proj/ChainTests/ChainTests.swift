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
    
    // Typical testing time delay. Must be bigger than `timeMargin`
    static let timeDelay =  1.5
    // Allowed error for timeDelay
    static let timeMargin = 0.2
    
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
            }.onDefault { result in
                XCTAssertEqual(qos_class_self(), QOS_CLASS_DEFAULT, "on default queue")
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
            }.onDefault { result in
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
            }.onDefault { result in
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
            }.onDefault { result in
                XCTAssertNil(result, "")
                return result
            }.run(.Main) { result in
                XCTAssertNil(result, "")
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testChainAfter() {
        let expectation = expectationWithDescription("")
        
        let timeDelay = ChainTests.timeDelay
        let lowerTimeDelay1 = timeDelay - ChainTests.timeMargin
        let upperTimeDelay1 = timeDelay + ChainTests.timeMargin

        Chain.main {
            return NSDate()
            }.after(seconds: timeDelay) { result in
                let _date = result as! NSDate
                print(_date)
                let timePassed = NSDate().timeIntervalSinceDate(_date)
                print(timePassed)
                
                XCTAssert(timePassed >= lowerTimeDelay1, "Should wait \(timePassed) >= \(lowerTimeDelay1) seconds before firing")
                XCTAssert(timePassed < upperTimeDelay1, "Shouldn't wait \(timePassed), but <\(upperTimeDelay1) seconds before firing")
                
                return NSDate()
            }.after(Queue.Main, seconds: timeDelay) { result in
                let _date = result as! NSDate
                print(_date)
                let timePassed = NSDate().timeIntervalSinceDate(_date)
                print(timePassed)
                
                XCTAssert(timePassed >= lowerTimeDelay1, "Should wait \(timePassed) >= \(lowerTimeDelay1) seconds before firing")
                XCTAssert(timePassed < upperTimeDelay1, "Shouldn't wait \(timePassed), but <\(upperTimeDelay1) seconds before firing")
                
                return NSDate()
            }.after(Queue.UserInitiated, seconds: timeDelay) { result in
                let _date = result as! NSDate
                print(_date)
                let timePassed = NSDate().timeIntervalSinceDate(_date)
                print(timePassed)
                
                XCTAssert(timePassed >= lowerTimeDelay1, "Should wait \(timePassed) >= \(lowerTimeDelay1) seconds before firing")
                XCTAssert(timePassed < upperTimeDelay1, "Shouldn't wait \(timePassed), but <\(upperTimeDelay1) seconds before firing")
                
                return NSDate()
            }.after(Queue.Default, seconds: timeDelay) { result in
                let _date = result as! NSDate
                print(_date)
                let timePassed = NSDate().timeIntervalSinceDate(_date)
                print(timePassed)
                
                XCTAssert(timePassed >= lowerTimeDelay1, "Should wait \(timePassed) >= \(lowerTimeDelay1) seconds before firing")
                XCTAssert(timePassed < upperTimeDelay1, "Shouldn't wait \(timePassed), but <\(upperTimeDelay1) seconds before firing")
                
                return NSDate()
            }.run(.Main) { result in
                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
    
    func testChainWait() {
        let expectation = expectationWithDescription("")
        
        let timeDelay = ChainTests.timeDelay
        let lowerTimeDelay1 = timeDelay - ChainTests.timeMargin
        let upperTimeDelay1 = timeDelay + ChainTests.timeMargin
        
        Chain.main {
            return NSDate()
            }.wait(seconds: timeDelay).main { result in
                let _date = result as! NSDate
                print(_date)
                let timePassed = NSDate().timeIntervalSinceDate(_date)
                print(timePassed)
                
                XCTAssert(timePassed >= lowerTimeDelay1, "Should wait \(timePassed) >= \(lowerTimeDelay1) seconds before firing")
                XCTAssert(timePassed < upperTimeDelay1, "Shouldn't wait \(timePassed), but <\(upperTimeDelay1) seconds before firing")
                
                return NSDate()
            }.wait(seconds: timeDelay).background { result in
                let _date = result as! NSDate
                print(_date)
                let timePassed = NSDate().timeIntervalSinceDate(_date)
                print(timePassed)
                
                XCTAssert(timePassed >= lowerTimeDelay1, "Should wait \(timePassed) >= \(lowerTimeDelay1) seconds before firing")
                XCTAssert(timePassed < upperTimeDelay1, "Shouldn't wait \(timePassed), but <\(upperTimeDelay1) seconds before firing")
                
                return NSDate()
            }.wait(seconds: timeDelay).userInitiated { result in
                let _date = result as! NSDate
                print(_date)
                let timePassed = NSDate().timeIntervalSinceDate(_date)
                print(timePassed)
                
                XCTAssert(timePassed >= lowerTimeDelay1, "Should wait \(timePassed) >= \(lowerTimeDelay1) seconds before firing")
                XCTAssert(timePassed < upperTimeDelay1, "Shouldn't wait \(timePassed), but <\(upperTimeDelay1) seconds before firing")
                
                return NSDate()
            }.wait(seconds: timeDelay).onDefault { result in
                let _date = result as! NSDate
                print(_date)
                let timePassed = NSDate().timeIntervalSinceDate(_date)
                print(timePassed)
                
                XCTAssert(timePassed >= lowerTimeDelay1, "Should wait \(timePassed) >= \(lowerTimeDelay1) seconds before firing")
                XCTAssert(timePassed < upperTimeDelay1, "Shouldn't wait \(timePassed), but <\(upperTimeDelay1) seconds before firing")
                
                return NSDate()
            }.wait(seconds: timeDelay).run(.Main) { result in
                let _date = result as! NSDate
                print(_date)
                let timePassed = NSDate().timeIntervalSinceDate(_date)
                print(timePassed)
                
                XCTAssert(timePassed >= lowerTimeDelay1, "Should wait \(timePassed) >= \(lowerTimeDelay1) seconds before firing")
                XCTAssert(timePassed < upperTimeDelay1, "Shouldn't wait \(timePassed), but <\(upperTimeDelay1) seconds before firing")

                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
}

final class TestObj {
    
    deinit {
        print("deinit TestObj")
    }
    
    init() {}
}
