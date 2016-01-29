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
                print(result)  // Optional(1)
                return "2"
            }.userInteractive { result in
                // called third
                // called at userInteractive qos class thread queue
                print(result)  // Optional(2)
                return "3"
            }.userInitiated { result in
                // called fourth
                // called at userInitiated qos class thread queue
                print(result)  // Optional(3)
                return "4"
            }.onDefault { result in
                // called fifth
                // called at default qos class thread queue
                print(result)  // Optional(4)
                return "5"
            }.run(.Main) { result in
                // called last
                // called at main thread queue
                print(result)  // Optional(5)
                print("completion")
        }
        
        // Custom Queue
        
        let customQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        
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
    }
}


