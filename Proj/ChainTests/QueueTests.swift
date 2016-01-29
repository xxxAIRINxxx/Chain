//
//  QueueTests.swift
//  Chain
//
//  Created by xxxAIRINxxx on 2016/01/28.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import Foundation
import XCTest
@testable import Chain

class QueueTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMainQueue() {
        XCTAssertTrue(Queue.Main.get === dispatch_get_main_queue(), "on main queue")
    }
    
    func testBackgroundQueue() {
        let expectation = expectationWithDescription("")
        
        dispatch_async(Queue.Background.get) {
            XCTAssertEqual(qos_class_self(), QOS_CLASS_BACKGROUND, "on background queue")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testUserInteractiveQueue() {
        let expectation = expectationWithDescription("")
        
        dispatch_async(Queue.UserInteractive.get) {
            XCTAssertEqual(qos_class_self(), QOS_CLASS_USER_INTERACTIVE, "on user interactive queue")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testUserInitiatedQueue() {
        let expectation = expectationWithDescription("")
        
        dispatch_async(Queue.UserInitiated.get) {
            XCTAssertEqual(qos_class_self(), QOS_CLASS_USER_INITIATED, "on user initiated queue")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testUtilityQueue() {
        let expectation = expectationWithDescription("")
        
        dispatch_async(Queue.Utility.get) {
            XCTAssertEqual(qos_class_self(), QOS_CLASS_UTILITY, "on utility queue")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testDefaultQueue() {
        let expectation = expectationWithDescription("")
        
        dispatch_async(Queue.Default.get) {
            XCTAssertEqual(qos_class_self(), QOS_CLASS_DEFAULT, "on default queue")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
    
    func testCustomQueue() {
        let serialQueue = dispatch_queue_create("serial_queue", DISPATCH_QUEUE_SERIAL)
        let queue = Queue.Custom(queue: serialQueue)
        
        XCTAssertTrue(queue.get === serialQueue, "on custom queue")
        
        let expectation = expectationWithDescription("")
        dispatch_async(Queue.Background.get) {
            XCTAssertTrue(queue.get === serialQueue, "on custom queue")
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(0.5, handler: nil)
    }
}
