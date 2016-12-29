//
//  ViewController.swift
//  Demo
//
//  Created by xxxAIRINxxx on 2016/01/27.
//  Copyright © 2016 xxxAIRINxxx. All rights reserved.
//

import UIKit
import Chain

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Basics
        
        Chain.main {
            // called first
            // called at main thread queue
            print("start")
            return "1"
            }.background { result in
                // called second
                // called at background qos class thread queue
                print(result!)  // Optional(1)
                return "2"
            }.userInteractive { result in
                // called third
                // called at userInteractive qos class thread queue
                print(result!)  // Optional(2)
                return "3"
            }.userInitiated { result in
                // called fourth
                // called at userInitiated qos class thread queue
                print(result!)  // Optional(3)
                return "4"
            }.onDefault { result in
                // called fifth
                // called at default qos class thread queue
                print(result!)  // Optional(4)
                return "5"
            }.run(.main) { result in
                // called last
                // called at main thread queue
                print(result!)  // Optional(5)
                print("completion")
        }
        
        // Custom Queue
        
        let customQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        
        Chain.custom(customQueue) {
            // called first
            // called at customQueue
            return nil
            }.onDefault { result in
                // called second
                // called default qos class thread queue
                return result
            }.main { result in
                // called third
                // called at main thread queue
                return result
            }.custom(customQueue) { result in
                // called fourth
                // called at customQueue
                return result
            }.run()
        
        // After
        
        Chain.main {
            // called first
            // called at main thread queue
            print("start after: \(Date().description)")
            return "1"
            }.after(seconds: 5) { result in
                // called second
                // called to 5 seconds after the previous block
                // called at background qos class thread queue
                print(result!)  // Optional(1)
                return "after 2: \(Date().description)"
            }.userInteractive { result in
                // called third
                // called at userInteractive qos class thread queue
                print(result!)  // Optional(2)
                return "after 3: \(Date().description)"
            }.after(Queue.utility, seconds: 5) { result in
                // called fourth
                // called to 5 seconds after the previous block
                // called at utility qos class thread queue
                print(result!)  // Optional(3)
                return "after 4: \(Date().description)"
            }.run(.main) { result in
                // called last
                // called at main thread queue
                print(result!)  // Optional(4)
                print("after completion: \(Date().description)")
        }
        
        // Wait
        
        Chain.main {
            // called first
            // called at main thread queue
            print("start wait: \(Date().description)")
            return "1"
            }.wait(seconds: 5).background { result in
                // called to 5 seconds after the previous block
                // called at background qos class thread queue
                print("wait 2: \(Date().description)")
                return result
            }.wait(seconds: 5).main { result in
                // called to 5 seconds after the previous block
                // called at main thread queue
                print("wait 3: \(Date().description)")
                return result
            }.run()
        
    }
}


